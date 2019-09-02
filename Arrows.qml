import QtQuick 2.0
import QtQuick3D 1.0

Node {
    property bool highlightOnHover: false

    scale: Qt.vector3d(7, 7, 7)

    property var _pointerStartPos
    property var _targetStartPos

    Arrow {
        id: arrowX
        rotation: Qt.vector3d(0, 90, 0)
        color: highlightOnHover && hovering ? Qt.lighter(Qt.rgba(1, 0, 0, 1)) : Qt.rgba(1, 0, 0, 1)

        onPressed: {
            var gp = nodeBeingManipulated.globalPosition
            _targetStartPos = Qt.vector3d(gp.x, gp.y, gp.z);
        }

        onDragged: {
            var newGlobalPos = Qt.vector3d(
                        _targetStartPos.x + distance.x,
                        _targetStartPos.y + distance.y,
                        _targetStartPos.z + distance.z)
            var posInParent = nodeBeingManipulated.parent.mapFromGlobalPosition(newGlobalPos)
            nodeBeingManipulated.position = posInParent
        }
    }

    Arrow {
        id: arrowY
        rotation: Qt.vector3d(-90, 0, 0)
        color: highlightOnHover && hovering ? Qt.lighter(Qt.rgba(0, 0, 1, 1)) : Qt.rgba(0, 0, 1, 1)

        onPressed: {
            var gp = nodeBeingManipulated.globalPosition
            _targetStartPos = Qt.vector3d(gp.x, gp.y, gp.z);
        }

        onDragged: {
            var newGlobalPos = Qt.vector3d(
                        _targetStartPos.x + distance.x,
                        _targetStartPos.y + distance.y,
                        _targetStartPos.z + distance.z)
            var posInParent = nodeBeingManipulated.parent.mapFromGlobalPosition(newGlobalPos)
            nodeBeingManipulated.position = posInParent
        }
    }

    Arrow {
        id: arrowZ
        rotation: Qt.vector3d(0, 180, 0)
        color: highlightOnHover && hovering ? Qt.lighter(Qt.rgba(0, 0.6, 0, 1)) : Qt.rgba(0, 0.6, 0, 1)

        onPressed: {
            var gp = nodeBeingManipulated.globalPosition
            _targetStartPos = Qt.vector3d(gp.x, gp.y, gp.z);
        }

        onDragged: {
            var newGlobalPos = Qt.vector3d(
                        _targetStartPos.x + distance.x,
                        _targetStartPos.y + distance.y,
                        _targetStartPos.z + distance.z)
            var posInParent = nodeBeingManipulated.parent.mapFromGlobalPosition(newGlobalPos)
            nodeBeingManipulated.position = posInParent
        }
    }
}
