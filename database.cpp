#include "database.h"
#include <QDebug>
#include <QDir>
#include <QSqlQuery>
#include <QSqlError>

const QString DB_CONNECTION_NAME = "notes_db";

Database::Database()
{
    openDatabase();
}

bool Database::openDatabase()
{
    QDir dataDir = QDir::currentPath();
    QString dbPath = dataDir.absolutePath() + "/" + DB_CONNECTION_NAME + ".db3";

    if(!isConnected()) {
        m_db = QSqlDatabase::addDatabase("QSQLITE", DB_CONNECTION_NAME);
    } else {
        m_db = QSqlDatabase::database(DB_CONNECTION_NAME);
    }

    m_db.setDatabaseName(dbPath);

    bool needCreate = !dataDir.exists(m_db.databaseName());

    bool ok = m_db.open();


    if(ok && needCreate) {
        QString path = ":/create_db.sql";
        runSqlScript(m_db, path);
    }

    return ok;
}

QSqlDatabase &Database::database()
{
    return m_db;
}

bool Database::isConnected()
{
    return QSqlDatabase::contains(DB_CONNECTION_NAME);
}

bool Database::runSqlScript(QSqlDatabase db, QString path)
{
    QFile scriptFile(path);
    bool allQueriesOk = false;
    if(scriptFile.exists() && db.isOpen() && db.isValid()) {
        if(scriptFile.open(QIODevice::ReadOnly)) {
            QStringList queries = QTextStream(&scriptFile).readAll().split(";");

            for (QString query : queries) {
                if(query.trimmed().isEmpty()) {
                    continue;
                }
                if(db.exec(query.trimmed()).lastError().isValid()) {
                   qDebug() << query << "fail";
                   allQueriesOk = false;
                } else {
                    qDebug() << query << "success";
                    allQueriesOk = true;
                }
            }
        }
    }
    return allQueriesOk;
}

