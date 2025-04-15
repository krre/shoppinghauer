#include "Database.h"
#include <QStandardPaths>
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
}
