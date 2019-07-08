import QtQuick 2.0
import QtDemon 1.0

FixedScreenSizeNode {
    property alias arrowX: arrowX
    property alias arrowY: arrowY
    property alias arrowZ: arrowZ

    view: demonview

    Arrow {
        id: arrowX
        rotation: Qt.vector3d(0, 90, 0)
        color: "red"
        scale.z: 1.5
    }

    Arrow {
        id: arrowY
        rotation: Qt.vector3d(-90, 0, 0)
        color: "blue"
        scale.z: 1.5
    }

    Arrow {
        id: arrowZ
        rotation: Qt.vector3d(0, 180, 0)
        color: "green"
        scale.z: 1.5
    }
}
