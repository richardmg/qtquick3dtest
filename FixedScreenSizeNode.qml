import QtQuick 2.0
import QtDemon 1.0

DemonNode {
    id: root
    property DemonView3D view: undefined; // a node can be drawn by several views. But a gizmo can only belong to one view...
    property var baseScale: undefined

//    x: target.globalPosition.x
//    y: target.globalPosition.y
//    z: target.globalPosition.z
//    rotation: target.rotation // should be target.globalRotation
//    Component.onCompleted: parent = target
//    onTargetChanged: parent = target

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
        target: view.camera
        onPositionChanged: updateGizmo()
        onRotationChanged: updateGizmo()
    }

    function updateGizmo()
    {
        // calculate scale based on distance to camera
        var viewCenter = view.width / 2
        var distanceToCamera = distVec3(globalPosition, view.camera.globalPosition)
        var pos1Screen = Qt.vector3d(viewCenter - 0.5, 0, distanceToCamera)
        var pos2Screen = Qt.vector3d(viewCenter + 0.5, 0, distanceToCamera)
        var pos1World = view.viewToWorld(pos1Screen)
        var pos2World = view.viewToWorld(pos2Screen)
        var distance = distVec3(pos1World, pos2World)

        if (baseScale == undefined) {
            // First time initialization.
            // Use the assigned scale as base scale
            baseScale = Qt.vector3d(scale.x, scale.y, scale.z)
        }

        scale.x = baseScale.x * distance
        scale.y = baseScale.y * distance
        scale.z = baseScale.z * distance
    }

    function distVec3(v1, v2)
    {
        var v = Qt.vector3d(v1.x - v2.x, v1.y - v2.y, v1.z - v2.z)
        return Math.sqrt(v.x * v.x + v.y * v.y + v.z * v.z)
    }
}
