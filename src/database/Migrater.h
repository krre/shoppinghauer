#pragma once
#include <QVector>

class Database;

class Migrater {
public:
    Migrater(Database* db);
    void run() const;

private:
    struct Migration {
        int version;
        std::function<void()> fn;
    };

    int version() const;
    void setVersion(int version) const;

    void migration20250415() const;
    void migration20250618() const;
    void migration20250811() const;
    void migration20260413() const;

    Database* m_db = nullptr;
    QVector<Migration> m_migrations;
};
