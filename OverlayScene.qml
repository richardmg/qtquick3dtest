import QtQuick 2.0
import QtQuick3D 1.0
import QtQuick3D.Helpers 1.0
import QtQuick3D.Scripts 1.0

Node {
    property View3D mainView: undefined

    signal updateOverlay

    function overlayPos(node)
    {
        var worldCamPosInView = mainView.camera.worldToViewport(node.position)
        return overlayCamera.viewportToWorld(worldCamPosInView)
    }

    Connections {
        target: mainView.camera
        onRotationChanged: updateOverlay()
        onPositionChanged: updateOverlay()
        // onTransformChanged: updateOverlay()
    }

    Camera {
        id: overlayCamera
        projectionMode: Camera.Orthographic
    }
}


