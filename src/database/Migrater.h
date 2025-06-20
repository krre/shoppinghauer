#pragma once
#include <QHash>

class Database;

class Migrater {
public:
    Migrater(Database* db);
    void run();

private:
    int version() const;
    void setVersion(int version) const;

    void migration1() const; // 15.04.2024
    void migration2() const; // 18.06.2024

    Database* m_db = nullptr;
    QHash<int, std::function<void()>> m_migrations;
};
