import QtQuick 2.12
import QtQuick3D 1.0

Item {
    id: root
    property Node targetNode
    property View3D view3D
    property var localPosition: Qt.vector3d(0, 0, 0)
    property real hitRadius: 20

    property bool hovering
    property bool dragging

    signal dragMoved(real deltaX, real deltaY)

    property var _targetPos
    property var _prevMousePos

    anchors.fill: parent

    PointHandler {
        acceptedButtons: Qt.LeftButton
        property bool pressed: point.pressedButtons === Qt.LeftButton
        onPressedChanged: {
            dragging = pressed && hovering
            _prevMousePos = point.position
            _targetPos = targetNode.position
        }
    }

    HoverHandler {
        onPointChanged: {
            var eventX = point.position.x
            var eventY = point.position.y

            var globalPosition = targetNode.mapToGlobal(localPosition)
            var viewPosition = view3D.mapFrom3DScene(globalPosition)
            var distance = Math.sqrt(Math.pow(eventX - viewPosition.x, 2) + Math.pow(eventY - viewPosition.y, 2))

            hovering = distance < hitRadius
        }
    }

    DragHandler {
        target: null
        acceptedButtons: Qt.LeftButton
        onCentroidChanged: {
            if (!root.dragging)
                return
            if (centroid.pressedButtons !== acceptedButtons)
                return

            // 1. We should not get a change to centroid when dragging stops (with an unrelated position), since
            // 		that will just confuse any calculations. We're then (after som debugging) forced to check
            // 		centroid.pressedButtons.
            // 2  Add a pressed property to _all_ PointerHandlers, at least PointHandler.
//                print("drag:", centroid.pressedButtons === Qt.LeftButton, centroid.position)

            var deltaX = centroid.position.x - _prevMousePos.x
            var deltaY = centroid.position.y - _prevMousePos.y
            dragMoved(deltaX, deltaY)
            _prevMousePos = centroid.position
        }
    }
}
