import QtQuick 2.0
import QtQuick3D 1.0
import MouseArea3D 0.1

Node {
    id: overlayNode

    property View3D overlayView
    property bool autoScale: true
    property Node target: parent
    property real relativeScale: 1

    onGlobalTransformChanged: updateScale()
    onAutoScaleChanged: updateScale()

    function getScale(baseScale)
    {
        return Qt.vector3d(baseScale.x * relativeScale, baseScale.y * relativeScale, baseScale.z * relativeScale)
    }

    Connections {
        target: overlayView.camera
        onGlobalTransformChanged: updateScale()
    }

    function updateScale()
    {
        if (!autoScale) {
            target.scale = Qt.vector3d(1, 1, 1)
        } else {
            var posInView1 = overlayView.mapFrom3DScene(positionInScene)
            var posInView2 = Qt.vector3d(posInView1.x + 100, posInView1.y, posInView1.z)

            var rayPos1 = overlayView.mapTo3DScene(Qt.vector3d(posInView2.x, posInView2.y, 0))
            var rayPos2 = overlayView.mapTo3DScene(Qt.vector3d(posInView2.x, posInView2.y, 10))

            var planeNormal = overlayView.camera.forward
            var rayHitPos = helper.rayIntersectsPlane(rayPos1, rayPos2, positionInScene, planeNormal)

            relativeScale = positionInScene.minus(rayHitPos).length() / 100
        }
    }

    MouseArea3D {
        id: helper
        view3D: overlayView
    }
}
