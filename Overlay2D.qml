import QtQuick 2.0
import QtQuick3D 1.0

Item {
    id: root
    property Node targetNode
    property View3D targetView

    property real offsetX: 0
    property real offsetY: 0

    Connections {
        target: targetNode
        onGlobalTransformChanged: updateOverlay()
    }

    Connections {
        target: targetView.camera
        onGlobalTransformChanged: updateOverlay()
    }

    function updateOverlay()
    {
        var globalPos = targetNode.globalPosition
        var globalPosWithOffset = Qt.vector3d(globalPos.x + offsetX, globalPos.y + offsetY, globalPos.z)
        var viewPos = targetView.mapFrom3DScene(globalPosWithOffset)
        root.x = viewPos.x
        root.y = viewPos.y
    }
}
