#include "core/Application.h"
#include <QQmlApplicationEngine>
#include <QQmlContext>

int main(int argc, char* argv[]) {
    Application app(argc, argv);

    QQmlApplicationEngine engine;
    engine.rootContext()->setContextProperty("app", &app);

    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);

    engine.loadFromModule("shoppinghauer", "Main");

    return app.exec();
}
