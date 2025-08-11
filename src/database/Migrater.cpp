#include "Migrater.h"
#include "Database.h"
#include <QSqlQuery>

constexpr auto CurrentVersion = 3;

Migrater::Migrater(Database* db) : m_db(db) {
    m_migrations[1] = [this] { migration1(); };
    m_migrations[2] = [this] { migration2(); };
    m_migrations[3] = [this] { migration3(); };
}

void Migrater::run() {
    int dbVersion = version();

    if (dbVersion == CurrentVersion) return;

    for (int i = dbVersion + 1; i <= CurrentVersion; ++i) {
        qInfo() << "Run database migration:" << i;
        m_migrations[i]();
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
        ))"
    );

    m_db->exec(R"(
        CREATE TABLE shopping_lists(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            shopping_date TIMESTAMP,
            name TEXT
        ))"
    );

    m_db->exec(R"(
        CREATE TABLE products(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT UNIQUE
        ))"
    );

    m_db->exec(R"(
        CREATE TABLE shoppings(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            shopping_list_id INTEGER,
            product_id INTEGER,
            count INTEGER,
            UNIQUE(shopping_list_id, product_id),
            FOREIGN KEY (shopping_list_id) REFERENCES shopping_lists(id) ON DELETE CASCADE,
            FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE
        ))"
    );

    m_db->exec("INSERT INTO meta (version) VALUES (0);");
    m_db->exec("CREATE INDEX idx_shoppings_shopping_list_id ON shoppings(shopping_list_id)");
}

void Migrater::migration2() const {
    m_db->exec("ALTER TABLE products ADD COLUMN is_archived BOOLEAN NOT NULL DEFAULT 0");
    m_db->exec("CREATE INDEX idx_products_is_archived ON products(is_archived)");
}

void Migrater::migration3() const {
    m_db->exec("ALTER TABLE shoppings RENAME COLUMN count TO amount");
}
