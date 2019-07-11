import QtQuick 2.0
import QtQuick3D 1.0

Node {
    id: root
    property Quick3DCamera camera: undefined; // a node can be drawn by several cameras. But a gizmo can only belong/scale to one camera...
    property var baseScale: undefined

    /*
      I need a way to specify that a node should only be visible in
      some cameras, but not in others...
      ...Or have a hook so that I can change the node based on the
      view that is about to render

      Note: vec3 should really be copy by value, not pointer?
      Centeralize positions so that we don't change scale when
      the camera rotates without any change of position

      todo: add onTick:
      */

    Connections {
        target: camera
        onPositionChanged: updateScale()
        onRotationChanged: updateScale()
    }

    function updateScale()
    {
        var distanceToCamera = distVec3(globalPosition, camera.globalPosition)
        var pos1Screen = Qt.vector3d(0, 0, distanceToCamera)
        var pos2Screen = Qt.vector3d(1, 0, distanceToCamera)
        var pos1World = camera.viewportToWorld(pos1Screen)
        var pos2World = camera.viewportToWorld(pos2Screen)
        var distance = distVec3(pos1World, pos2World)
        var newScale = distance / 100;

        if (baseScale == undefined) {
            // First time initialization.
            // Use the assigned scale as base scale
            baseScale = Qt.vector3d(scale.x, scale.y, scale.z)
        }

        scale.x = baseScale.x * newScale
        scale.y = baseScale.y * newScale
        scale.z = baseScale.z * newScale
    }

    function distVec3(v1, v2)
    {
        var v = Qt.vector3d(v1.x - v2.x, v1.y - v2.y, v1.z - v2.z)
        return Math.sqrt(v.x * v.x + v.y * v.y + v.z * v.z)
    }
}
