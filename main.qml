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

            Arrow {
                z: 400
                rotation: Qt.vector3d(0, 90, 0)
            }
        }

        Sun {
            secondsPerOrbit: 10
        }

        ConeLight {
            id: ambient
            y: 400
            diffuseColor: Qt.rgba(0.4, 0.5, 0.0, 1.0)
            rotation: Qt.vector3d(60, 0, 0)
            brightness: 30
//            gizmo: Gizmo.Light
        }

        Lowpolylandscape {}

    }

    Sky {
        anchors.fill: parent
        DemonView3D {
            id: demonview
            anchors.fill: parent
            scene: scene
        }
    }

    WasdController {
        id: wasdController
        controlledObject: camera
        view: demonview
    }
}
