#pragma once
#include <QObject>
#include <QSqlDatabase>

class Database : public QObject {
    Q_OBJECT
public:
    Database(QObject* parent = nullptr);

    Q_INVOKABLE void init();

private:
    QSqlDatabase m_db;
};
