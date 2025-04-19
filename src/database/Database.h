#pragma once
#include <QObject>
#include <QSqlDatabase>

class Database : public QObject {
    Q_OBJECT
public:
    Database(QObject* parent = nullptr);

    Q_INVOKABLE void init();

    Q_INVOKABLE void insertShoppingList(const QDate& date, const QString& name = {});

    const QSqlDatabase& db() const { return m_db; }
    QSqlQuery exec(const QString& sql, const QVariantMap& params = {}) const;

private:
    QSqlDatabase m_db;
};
