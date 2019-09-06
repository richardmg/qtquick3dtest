import QtQuick 2.0
import QtQuick3D 1.0

Node {
    property bool highlightOnHover: false
    objectName: "Arrows"

    scale: Qt.vector3d(7, 7, 7)

    Arrow {
        id: arrowX
        rotation: Qt.vector3d(0, 90, 0)
        color: highlightOnHover && hovering ? Qt.lighter(Qt.rgba(1, 0, 0, 1)) : Qt.rgba(1, 0, 0, 1)
    }

    Arrow {
        id: arrowY
        rotation: Qt.vector3d(-90, 0, 0)
        color: highlightOnHover && hovering ? Qt.lighter(Qt.rgba(0, 0, 1, 1)) : Qt.rgba(0, 0, 1, 1)
    }

    Arrow {
        id: arrowZ
        rotation: Qt.vector3d(0, 180, 0)
        color: highlightOnHover && hovering ? Qt.lighter(Qt.rgba(0, 0.6, 0, 1)) : Qt.rgba(0, 0.6, 0, 1)
    }
}
