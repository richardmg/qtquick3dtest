import QtQuick 2.0
import QtDemon 1.0

DemonNode {
    id: root
    property DemonNode target: root

//    x: target.globalPosition.x
//    y: target.globalPosition.y
//    z: target.globalPosition.z
//    rotation: target.rotation // should be target.globalRotation
//    Component.onCompleted: parent = target
//    onTargetChanged: parent = target

    Arrow {
        id: arrowX
        rotation: Qt.vector3d(0, 90, 0)
        color: "red"
    }

    Arrow {
        id: arrowY
        rotation: Qt.vector3d(-90, 0, 0)
        color: "blue"
    }

    Arrow {
        id: arrowZ
        rotation: Qt.vector3d(0, 180, 0)
        color: "green"
    }
}
