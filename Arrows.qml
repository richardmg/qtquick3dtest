import QtQuick 2.0
import QtQuick3D 1.0

Node {
    id: arrows
    property bool highlightOnHover: false
    property bool draggable: false

    scale: Qt.vector3d(7, 7, 7)

    property alias arrowX: arrowX
    property alias arrowY: arrowY
    property alias arrowZ: arrowZ

    Arrow {
        id: arrowX
        objectName: "Arrow X"
        rotation: Qt.vector3d(0, -90, 0)
        draggable: arrows.draggable
        color: highlightOnHover && hovering ? Qt.lighter(Qt.rgba(1, 0, 0, 1)) : Qt.rgba(1, 0, 0, 1)
    }

    Arrow {
        id: arrowY
        objectName: "Arrow Y"
        rotation: Qt.vector3d(90, 0, 0)
        draggable: arrows.draggable
        color: highlightOnHover && hovering ? Qt.lighter(Qt.rgba(0, 0, 1, 1)) : Qt.rgba(0, 0, 1, 1)
    }

    Arrow {
        id: arrowZ
        objectName: "Arrow Z"
        rotation: Qt.vector3d(0, 180, 0)
        draggable: arrows.draggable
        color: highlightOnHover && hovering ? Qt.lighter(Qt.rgba(0, 0.6, 0, 1)) : Qt.rgba(0, 0.6, 0, 1)
    }
}
