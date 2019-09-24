import QtQuick 2.0
import QtQuick3D 1.0

Item {
    id: root
    property Node targetNode
    property View3D targetView

    property real offsetX: 0
    property real offsetY: 0

    onTargetNodeChanged: updateOverlay()

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
        var posInScene = targetNode.positionInScene
        var posInSceneWithOffset = Qt.vector3d(posInScene.x + offsetX, posInScene.y + offsetY, posInScene.z)
        var viewPos = targetView.mapFrom3DScene(posInSceneWithOffset)
        root.x = viewPos.x
        root.y = viewPos.y
    }
}
