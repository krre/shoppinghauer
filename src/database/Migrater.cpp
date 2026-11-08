#include "Migrater.h"
#include "Database.h"
#include <QSqlQuery>

#define MIGRATION(ver) \
    m_migrations.append({ ver, [this] { migration##ver(); } })

Migrater::Migrater(Database* db) : m_db(db) {
    MIGRATION(20250415);
    MIGRATION(20250618);
    MIGRATION(20250811);
    MIGRATION(20260413);
}

void Migrater::run() const {
    int dbVersion = version();
    const int latestVersion = m_migrations.last().version;

    if (dbVersion >= latestVersion) return;

    // Backward compatibility
    if (dbVersion == 4) {
        setVersion(latestVersion);
        return;
    }

    for (const auto& migration: m_migrations) {
        if (migration.version <= dbVersion) continue;

        qInfo() << "Run database migration:" << migration.version;
        migration.fn();
        setVersion(migration.version);
    }
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

void Migrater::migration20250415() const {
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

void Migrater::migration20250618() const {
    m_db->exec("ALTER TABLE products ADD COLUMN is_archived BOOLEAN NOT NULL DEFAULT 0");
    m_db->exec("CREATE INDEX idx_products_is_archived ON products(is_archived)");
}

void Migrater::migration20250811() const {
    m_db->exec("ALTER TABLE shoppings RENAME COLUMN count TO amount");
}

void Migrater::migration20260413() const {
    m_db->exec(R"(
        CREATE TABLE templates(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT UNIQUE
        ))"
    );

    m_db->exec(R"(
        CREATE TABLE template_products(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            template_id INTEGER,
            product_id INTEGER,
            UNIQUE(template_id, product_id),
            FOREIGN KEY (template_id) REFERENCES templates(id) ON DELETE CASCADE,
            FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE
        ))"
    );
}
