#include "Database.h"
#include "Migrater.h"
#include <QStandardPaths>
#include <QSqlQuery>
#include <QDir>
#include <QSqlError>

Database::Database(QObject* parent) : QObject(parent) {
    m_db = QSqlDatabase::addDatabase("QSQLITE");
}

void Database::init() {
    const QString directory = QStandardPaths::writableLocation(QStandardPaths::AppLocalDataLocation);
    QDir().mkpath(directory);

    const QString name = directory + "/data.db";
    m_db.setDatabaseName(name);

    if (!m_db.open()) {
        qCritical().noquote() << "Error opening database:" << m_db.lastError();
        return;
    }

    qInfo().noquote() << "Database opened:" << name;

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

QSqlQuery Database::exec(const QString& sql, const QVariantMap& params) const {
    QSqlQuery query;
    query.prepare(sql);

    for (auto [key, value] : params.asKeyValueRange()) {
        query.bindValue(":" + key, value);
    }

    if (!query.exec()) {
        qCritical().noquote() << "SQL error:" << query.lastError();
        return QSqlQuery();
    }

    return query;
}
