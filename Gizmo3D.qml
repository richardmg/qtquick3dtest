import QtQuick 2.0
import QtQuick3D 1.0

Node {
    id: root
    property Node targetNode
    property View3D targetView
    property bool trackPosition: true
    property bool trackRotation: true

    Connections {
        target: targetNode
        onGlobalTransformChanged: updateGizmo()
    }

    Connections {
        target: targetView.camera
        onGlobalTransformChanged: updateGizmo()
    }

    function updateGizmo()
    {
        // todo: detect camera? or at least detect the given cameras projection
        // orthographic
//        if (trackPosition) {
//            var viewportPos = targetView.camera.mapFromScene(targetNode.globalPosition)
//            position = overlayCamera.mapToScene(viewportPos)
//        }
        if (trackPosition)
            root.position = targetNode.globalPosition
        if (trackRotation)
            root.rotation = targetNode.globalRotation

        // HANDLE FIXED SCALE
    }
}
