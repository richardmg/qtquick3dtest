import QtQuick 2.12
import QtQuick.Window 2.12
import QtDemon 1.0
import QtQuick.Controls 2.4

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
        id: standAloneScene

        DemonCamera {
            id: camera2
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
            scene: standAloneScene
        }
    }

}
