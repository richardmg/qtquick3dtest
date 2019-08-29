#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QtQuick3D/private/qquick3dviewport_p.h>
#include "mousepoint3d.h"

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QGuiApplication app(argc, argv);
    QSurfaceFormat::setDefaultFormat(QQuick3DViewport::idealSurfaceFormat());

    qmlRegisterType<MousePoint3D>("MousePoint3D", 0, 1, "MousePoint3D");

    QQmlApplicationEngine engine;
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));
    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}
