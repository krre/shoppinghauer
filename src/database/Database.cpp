#include "Database.h"
#include "Migrater.h"
#include "src/core/Application.h"
#include <QStandardPaths>
#include <QSqlQuery>
#include <QSqlRecord>
#include <QSqlError>
#include <QDir>

Database::Database(QObject* parent) : QObject(parent) {
    m_db = QSqlDatabase::addDatabase("QSQLITE");
}

void Database::init() {
    const QString directory = QStandardPaths::writableLocation(QStandardPaths::AppLocalDataLocation);
    QDir().mkpath(directory);

    dbPath = directory + "/data.db";
    m_db.setDatabaseName(dbPath);

    if (!m_db.open()) {
        qCritical().noquote() << "Error opening database:" << m_db.lastError();
        return;
    }

    qInfo().noquote() << "Database opened:" << dbPath;

    Migrater migrater(this);
    migrater.run();
}

void Database::insertShoppingList(const QDate& date, const QString& name) {
    QVariantMap params = {
        { "shopping_date", date },
        { "name", name },
    };

    exec("INSERT INTO shopping_lists (shopping_date, name) VALUES (:shopping_date, :name)", params);
}

void Database::updateShoppingList(int id, const QDate& date, const QString& name) {
    QVariantMap params = {
        { "id", id },
        { "shopping_date", date },
        { "name", name },
    };

    exec("UPDATE shopping_lists SET shopping_date = :shopping_date, name = :name WHERE id = :id", params);
}

QVariantList Database::shoppingLists() {
    QSqlQuery query = exec("SELECT * FROM shopping_lists ORDER BY shopping_date DESC");
    return queryToList(&query);
}

QVariantMap Database::shoppingList(int id) const {
    QSqlQuery query = exec("SELECT * FROM shopping_lists WHERE id = :id", { { "id", id } });
    query.first();
    return queryToMap(&query);
}

void Database::removeShoppingList(int id) {
    exec("DELETE FROM shopping_lists WHERE id = :id", { { "id", id } });
}

void Database::insertProduct(const QString& name) {
    QVariantMap params = {
        { "name", name },
    };

    exec("INSERT INTO products (name) VALUES (:name)", params);
}

void Database::updateProduct(int id, const QString& name) {
    QVariantMap params = {
        { "id", id },
        { "name", name },
    };

    exec("UPDATE products SET name = :name WHERE id = :id", params);
}

QVariantList Database::products() {
    QSqlQuery query = exec(R"(
        SELECT *
        FROM products
        WHERE is_archived = false
        ORDER BY name ASC)");
    return queryToList(&query);
}

QVariantList Database::allProducts() {
    QSqlQuery query = exec("SELECT * FROM products ORDER BY name ASC");
    return queryToList(&query);
}

QVariantMap Database::product(int id) const {
    QSqlQuery query = exec("SELECT * FROM products WHERE id = :id", { { "id", id } });
    query.first();
    return queryToMap(&query);
}

void Database::removeProduct(int id) {
    exec("DELETE FROM products WHERE id = :id", { { "id", id } });
}

void Database::archiveProduct(int id, bool on) {
    QVariantMap params = {
        { "id", id },
        { "is_archived", on },
    };

    exec("UPDATE products SET is_archived = :is_archived WHERE id = :id", params);
}

QVariantList Database::shoppings(int shoppingListId) {
    QSqlQuery query = exec(R"(
        SELECT s.id, p.name, s.product_id, s.amount
        FROM shoppings AS s
            JOIN products AS p ON s.product_id = p.id
        WHERE s.shopping_list_id = :shopping_list_id
        ORDER BY p.name ASC
    )", { { "shopping_list_id", shoppingListId } });

    return queryToList(&query);
}

void Database::insertShoppings(int shoppingListId, const QVariantList& productIds) {
    for (const auto& productId : productIds) {
        QVariantMap params = {
            { "shopping_list_id", shoppingListId },
            { "product_id", productId.toInt() },
        };

        exec("INSERT INTO shoppings (shopping_list_id, product_id, amount) VALUES (:shopping_list_id, :product_id, 1)", params);
    }
}

void Database::removeShopping(int id) {
    exec("DELETE FROM shoppings WHERE id = :id", { { "id", id } });
}

void Database::setShoppingAmount(int id, int amount) {
    QVariantMap params = {
        { "id", id },
        { "amount", amount },
    };

    exec("UPDATE shoppings SET amount = :amount WHERE id = :id", params);
}

QString Database::exportFile() {
    QString exportPath = QStandardPaths::writableLocation(QStandardPaths::DownloadLocation) + QString("/%1.db").arg(Application::Name);
    if (QFile::exists(exportPath)) QFile::remove(exportPath);

    if (QFile::copy(dbPath, exportPath)) {
        qInfo().noquote() << "Database exported:" << exportPath;
        return exportPath;
    }

    return QString();
}

QString Database::lastErrorCode() const {
    return m_lastErrorCode;
}

QSqlQuery Database::exec(const QString& sql, const QVariantMap& params) const {
    QSqlQuery query;
    query.prepare(sql);

    for (auto [key, value] : params.asKeyValueRange()) {
        query.bindValue(":" + key, value);
    }

    bool success = query.exec();
    m_lastErrorCode = query.lastError().nativeErrorCode();

    if (!success) {
        qCritical().noquote() << "SQL error:" << query.lastError();
        return QSqlQuery();
    }

    return query;
}

QVariantMap Database::queryToMap(QSqlQuery* query) const {
    QVariantMap result;

    for (int i = 0; i < query->record().count(); ++i) {
        result[query->record().fieldName(i)] = query->record().value(i);
    }

    return result;
}

QVariantList Database::queryToList(QSqlQuery* query) const {
    QVariantList result;

    while (query->next()) {
        result.append(queryToMap(query));
    }

    return result;
}
