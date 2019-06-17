import QtQuick 2.12
import QtQuick.Window 2.12
import QtDemon 1.0
import QtQuick.Controls 2.4
import QtDemonHelpers 1.0

Window {
    id: window
    width: 1280
    height: 720
    visible: true

    Timer {
        id: clock
        property real time: 12
        readonly property real dawn: 6
        readonly property real dusk: 18
        property real msPerHour: 1000
        running: true
        repeat: true
        interval: msPerHour
        onTriggered: time++
    }

    DemonNode {
        id: scene

        DemonCamera {
            id: camera
            z: -600
            y: 200
            rotation: Qt.vector3d(15, 0, 0)
        }

        Sun {
            secondsPerOrbit: 10
        }

        Lowpolylandscape {}
    }

    Sky {
        anchors.fill: parent
        DemonView3D {
            anchors.fill: parent
            scene: scene

            property int foo: 0
            focus: true
            Keys.onPressed: {
                switch (event.key) {
                case Qt.Key_W:
                case Qt.Key_Up:
                    wasdController.forwardPressed();
                    break;
                case Qt.Key_S:
                case Qt.Key_Down:
                    wasdController.backPressed();
                    break;
                case Qt.Key_A:
                case Qt.Key_Left:
                    wasdController.leftPressed();
                    break;
                case Qt.Key_D:
                case Qt.Key_Right:
                    wasdController.rightPressed();
                    break;
                case Qt.Key_R:
                case Qt.Key_PageUp:
                    wasdController.upPressed();
                    break;
                case Qt.Key_F:
                case Qt.Key_PageDown:
                    wasdController.downPressed();
                    break;
                }
            }

            Keys.onReleased: {
                switch (event.key) {
                case Qt.Key_W:
                case Qt.Key_Up:
                    wasdController.forwardReleased();
                    break;
                case Qt.Key_S:
                case Qt.Key_Down:
                    wasdController.backReleased();
                    break;
                case Qt.Key_A:
                case Qt.Key_Left:
                    wasdController.leftReleased();
                    break;
                case Qt.Key_D:
                case Qt.Key_Right:
                    wasdController.rightReleased();
                    break;
                case Qt.Key_R:
                case Qt.Key_PageUp:
                    wasdController.upReleased();
                    break;
                case Qt.Key_F:
                case Qt.Key_PageDown:
                    wasdController.downReleased();
                    break;
                }
            }

        }
    }

    WasdController {
        id: wasdController
        controlledObject: camera
    }

    MouseArea {
        anchors.fill: parent
        onPressed: {
            wasdController.mousePressed(mouse);
        }
        onReleased: {
            wasdController.mouseReleased(mouse);
        }

        onPositionChanged: {
            wasdController.mouseMoved(Qt.vector2d(mouse.x, mouse.y));
        }
    }

}
