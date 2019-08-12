import QtQuick 2.0
import QtQuick3D 1.0
import QtQuick3D.Helpers 1.0
import QtQuick3D.Scripts 1.0

Node {
    property View3D mainView: undefined
    objectName: "overlayRootNode"

    signal updateOverlay

    function overlayPos(node)
    {
        var worldCamPosInView = mainView.camera.worldToViewport(node.globalPosition)
        var worldNodeOverlayPos = overlayCamera.viewportToWorld(worldCamPosInView)
        return worldNodeOverlayPos
    }

    Connections {
        target: mainView.camera
//        onRotationChanged: updateOverlay()
//        onPositionChanged: updateOverlay()
        onGlobalTransformChanged: updateOverlay()
    }

    Camera {
        id: overlayCamera
        projectionMode: Camera.Orthographic
        objectName: "overlayCamera"
    }

    Timer {
        running: true
        onTriggered: updateOverlay()
    }
}


