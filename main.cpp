#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QtQuick3D/private/qquick3dviewport_p.h>
#include "mousearea3d.h"

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QGuiApplication app(argc, argv);
    QSurfaceFormat::setDefaultFormat(QQuick3DViewport::idealSurfaceFormat());

    qmlRegisterType<MouseArea3D>("MouseArea3D", 0, 1, "MouseArea3D");

    QQmlApplicationEngine engine;
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));
    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}
