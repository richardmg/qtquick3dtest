import QtQuick 2.0
import QtDemon 1.0

DemonNode {
    id: root
    property DemonView3D view: undefined; // a node can be drawn by several views. But a gizmo can only belong to one view...
    property real unscaledScreenLength: 10 // in Orthographic projection
    property real wantedScreenLength: 70
    property real maxScale: 15

    property real maxScreenLength: 10
    property real minScreenLength: maxScreenLength // lock

    property bool isLight: true // type

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
      */

    Connections {
        target: view.camera
        onPositionChanged: updateGizmo()
        onRotationChanged: updateGizmo()
    }

    Arrow {
        id: arrowX
        rotation: Qt.vector3d(0, 90, 0)
        visible: !isLight
        color: "red"
    }

    Arrow {
        id: arrowY
        rotation: Qt.vector3d(-90, 0, 0)
        visible: !isLight
        color: "blue"
    }

    Arrow {
        id: arrowZ
        rotation: Qt.vector3d(0, 180, 0)
        color: isLight ? "yellow" : "green"
    }

    function updateGizmo()
    {
        // calculate scale based on distance to camera
        var distanceToCamera = distVec3(position, view.camera.position)
        var center = view.width / 2
        var pos1Screen = Qt.vector3d(center - wantedScreenLength / 2, 0, distanceToCamera)
        var pos2Screen = Qt.vector3d(center + wantedScreenLength / 2, 0, distanceToCamera)
        var pos1World = view.viewToWorld(pos1Screen)
        var pos2World = view.viewToWorld(pos2Screen)

        var distanceBetweenPositions = distVec3(pos1World, pos2World)
        var s = distanceBetweenPositions / unscaledScreenLength
        if (s > maxScale)
            s = maxScale
        print(s)
        scale.x = s
        scale.y = s
        scale.z = s
    }

    function distVec3(v1, v2)
    {
        var v = Qt.vector3d(v1.x - v2.x, v1.y - v2.y, v1.z - v2.z)
        return Math.sqrt(v.x * v.x + v.y * v.y + v.z * v.z)
    }
}
