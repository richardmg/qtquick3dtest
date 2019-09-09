import QtQuick 2.0
import QtQuick3D 1.0
import MouseArea3D 0.1

Node {
    id: root
    property Node targetNode
    property View3D targetView
    property bool trackPosition: true
    property bool trackRotation: true
    property bool autoScale: true

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

        if (autoScale) {
            var targetPos1 = targetNode.globalPosition
            var targetViewPos = targetView.mapFrom3DScene(targetPos1)
            var viewPos2 = Qt.vector3d(targetViewPos.x + 100, targetViewPos.y, targetViewPos.z)

            var rayPos1 = targetView.mapTo3DScene(Qt.vector3d(viewPos2.x, viewPos2.y, 0))
            var rayPos2 = targetView.mapTo3DScene(Qt.vector3d(viewPos2.x, viewPos2.y, 1))

            var planeNormal = targetView.camera.forward
            var targetPos2 = helper.rayIntersectsPlane(rayPos1, rayPos2, targetPos1, planeNormal)

            var dist = targetPos1.minus(targetPos2).length() / 100
            root.scale = Qt.vector3d(dist, dist, dist)
        }
    }

    MouseArea3D {
        id: helper
        view3D: targetView
    }
}
