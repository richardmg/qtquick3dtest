import QtQuick 2.0
import QtDemon 1.0

DemonNode {
    id: root
    property DemonNode target: root
    property DemonView3D view: undefined; // a node can be drawn by several views. But a gizmo can only belong to one view...
    property real unscaledScreenLength: 10 // in Orthographic projection
    property real wantedScreenLength: 100

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
      */

    Connections {
        target: view.camera
        onPositionChanged: updateGizmo()
        onRotationChanged: updateGizmo()
    }

    Arrow {
        id: arrowX
        rotation: Qt.vector3d(0, 90, 0)
        color: "red"
    }

    Arrow {
        id: arrowY
        rotation: Qt.vector3d(-90, 0, 0)
        color: "blue"
    }

    Arrow {
        id: arrowZ
        rotation: Qt.vector3d(0, 180, 0)
        color: "green"
    }

    function updateGizmo()
    {
        var pos1World = position
        var pos1Screen = view.worldToView(pos1World)

        // Note: vec3 should really be copy by value, not pointer?
        // Centeralize positions so that we don't change scale when
        // the camera rotates without any change of position
        var center = view.width / 2
        var pos2Screen = Qt.vector3d(center - wantedScreenLength / 2, 0, pos1Screen.z)
        pos1Screen.x = center + wantedScreenLength / 2
        pos1Screen.y = 0

        var pos1BackWorld = view.viewToWorld(pos1Screen)
        var pos2BackWorld = view.viewToWorld(pos2Screen)
        var worldDist = distVec3(pos1BackWorld, pos2BackWorld)

        var s = worldDist / unscaledScreenLength
        scale.x = s
        scale.y = s
        scale.z = s
    }

    function distVec3(v1, v2)
    {
        v1.x -= v2.x
        v1.y -= v2.y
        v1.z -= v2.z
        return Math.sqrt(v1.x * v1.x + v1.y * v1.y + v1.z * v1.z)
    }
}
