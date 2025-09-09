#pragma once
#include <QObject>
#include <QSqlDatabase>

class Database : public QObject {
    Q_OBJECT
public:
    Database(QObject* parent = nullptr);

    Q_INVOKABLE void init();

    Q_INVOKABLE void insertShoppingList(const QDate& date, const QString& name = {});
    Q_INVOKABLE void updateShoppingList(int id, const QDate& date, const QString& name);
    Q_INVOKABLE QVariantList shoppingLists();
    Q_INVOKABLE QVariantMap shoppingList(int id) const;
    Q_INVOKABLE void removeShoppingList(int id);

    Q_INVOKABLE void insertProduct(const QString& name = {});
    Q_INVOKABLE void updateProduct(int id, const QString& name);
    Q_INVOKABLE QVariantList products();
    Q_INVOKABLE QVariantList allProducts();
    Q_INVOKABLE QVariantMap product(int id) const;
    Q_INVOKABLE void removeProduct(int id);
    Q_INVOKABLE void archiveProduct(int id, bool on);

    Q_INVOKABLE QVariantList shoppings(int shoppingListId);
    Q_INVOKABLE void insertShoppings(int shoppingListId, const QVariantList& productIds);
    Q_INVOKABLE void removeShopping(int id);
    Q_INVOKABLE void setShoppingAmount(int id, int amount);

    Q_INVOKABLE QString exportFile();

    Q_INVOKABLE QString lastErrorCode() const;

    const QSqlDatabase& db() const { return m_db; }
    QSqlQuery exec(const QString& sql, const QVariantMap& params = {}) const;

private:
    QVariantMap queryToMap(QSqlQuery* query) const;
    QVariantList queryToList(QSqlQuery* query) const;

    QSqlDatabase m_db;
    QString dbPath;
    mutable QString m_lastErrorCode;
};
