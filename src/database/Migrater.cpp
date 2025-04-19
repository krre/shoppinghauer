#include "Migrater.h"
#include "Database.h"
#include <QSqlQuery>

constexpr auto CurrentVersion = 1;

Migrater::Migrater(Database* db) : m_db(db) {
    migrations[1] = [this] { migration1(); };
}

void Migrater::run() {
    int dbVersion = version();

    if (dbVersion == CurrentVersion) return;

    for (int i = dbVersion + 1; i <= CurrentVersion; ++i) {
        qInfo() << "Run database migration:" << i;
        migrations[i]();
    }

    setVersion(CurrentVersion);
}

int Migrater::version() const {
    if (!m_db->db().tables().contains("meta")) {
        return 0;
    }

    QSqlQuery query = m_db->exec("SELECT version FROM meta");
    return query.first() ? query.value("version").toInt() : 0;
}

void Migrater::setVersion(int version) const {
    m_db->exec("UPDATE meta SET version = :version", { { "version", version } });
}

void Migrater::migration1() const {
    m_db->exec(R"(
        CREATE TABLE meta(
            version INTEGER
        );)"
    );

    m_db->exec(R"(
        CREATE TABLE shopping_lists(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            shopping_date TIMESTAMP,
            name TEXT
        );)"
    );

    m_db->exec(R"(
        CREATE TABLE products(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT UNIQUE
        );)"
    );

    m_db->exec("INSERT INTO meta (version) VALUES (0);");
}
