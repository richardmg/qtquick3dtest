import QtQuick 2.0
import QtQuick3D 1.0

Item {
    id: root
    property Node targetNode
    property View3D targetView

    // To make the gizmo appear to be a part of the 3D scene.
    property real xOffsetInSceneUnits
    property real yOffsetInSceneUnits

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
        var viewPos = targetView.mapFrom3DScene(targetNode.globalPosition)
        root.x = viewPos.x
        root.y = viewPos.y
    }
}
