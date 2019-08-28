import QtQuick 2.12
import QtQuick3D 1.0

MouseArea {
    id: root

    property Node targetNode
    property View3D view3D

    property var localPosition: Qt.vector3d(0, 0, 0)
    property real radius: 20

    property bool hovering: false
    property bool dragging: false

    signal dragMoved(real deltaX, real deltaY)

    property real _prevMouseX
    property real _prevMouseY

    anchors.fill: parent
    hoverEnabled: true

    onPressedChanged: {
        _prevMouseX = mouseX
        _prevMouseY = mouseY
        dragging = hovering && pressed
    }

    onPositionChanged: {
        var globalPosition = targetNode ? targetNode.mapToGlobal(localPosition) : position
        var viewPosition = view3D.mapFrom3DScene(globalPosition)
        var distance = Math.sqrt(Math.pow(mouseX - viewPosition.x, 2) + Math.pow(mouseY - viewPosition.y, 2))
        hovering = distance < radius

        if (!dragging)
            return

        var deltaX = mouseX - _prevMouseX
        var deltaY = mouseY - _prevMouseY
        _prevMouseX = mouseX
        _prevMouseY = mouseY

        dragMoved(deltaX, deltaY)
    }
}
