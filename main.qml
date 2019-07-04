import QtQuick 2.12
import QtQuick.Window 2.12
import QtDemon 1.0
import QtDemonHelpers 1.0

Window {
    id: window
    width: 640
    height: 480
    visible: true

    Timer {
        id: clock
        property real time: 12
        readonly property real dawn: 6
        readonly property real dusk: 18
        property real msPerHour: 1000
        //running: true
        repeat: true
        interval: msPerHour
        onTriggered: time++
    }

    DemonNode {
        id: scene

        DemonCamera {
            id: camera1
//            x: 400
            z: -600
//            projectionMode: DemonCamera.Orthographic
            //y: 200
            //rotation: Qt.vector3d(15, 0, 0)
        }

        Sun {
            secondsPerOrbit: 10
        }

        ConeLight {
            id: ambient
            y: 400
            diffuseColor: Qt.rgba(0.4, 0.5, 0.0, 1.0)
            rotation: Qt.vector3d(60, 0, 0)
            brightness: 30
//            gizmo: Gizmo.Light
        }

//        Lowpolylandscape {
//            id: landscape
//        }

        AxisHelper {
            enableAxisLines: true
            enableXZGrid: false
            enableYZGrid: false
            enableXYGrid: true
        }

        Gizmo {
            id: gizmo
//            x: 100
//            y: 100
//            z: 10
        }

    }

    Component {
        id: ray
        DemonModel {
            source: "meshes/Arrow.mesh"
            rotation: Qt.vector3d(90, 0, 0)
            materials: DemonDefaultMaterial {
                diffuseColor: "red"
                lighting: DemonDefaultMaterial.NoLighting
            }
        }
    }

    Item {
        anchors.fill: parent
        DemonView3D {
            id: demonview
            anchors.fill: parent
            scene: scene
            camera: camera1
            Rectangle {
                width: 100
                height: 100
                color: "yellow"
            }
        }

        WasdController {
            controlledObject: camera1
            x: 0
            y: 0
            width: parent.width
            height: parent.height
            speed: 0.1
//            mouseEnabled: false
        }

        PointHandler {
            acceptedButtons: Qt.RightButton
            onPointChanged: {
                return;

                if (!point.pressure)
                    return

                var screenPosNear = Qt.vector3d(point.position.x, point.position.y, camera1.clipNear + 10);
                var worldPosNear = demonview.viewToWorld(screenPosNear)

                var screenPosFar = Qt.vector3d(point.position.x, point.position.y, camera1.clipNear + 100);
                var worldPosFar = demonview.viewToWorld(screenPosFar)

                var arrow = ray.createObject(scene)
                arrow.position = worldPosNear
                //arrow.lookAtGlobal(worldPosFar)
                arrow.rotation = camera1.rotation
                print("end pos:", arrow.position, arrow.rotation)

            }
        }

//        DemonView3D {
//            id: overlay
//            anchors.fill: parent
//            scene: DemonNode {
//                DemonCamera {
//                    position: camera1.position
//                    rotation: camera1.rotation
////                    projectionMode: DemonCamera.Orthographic
//                }

////                Gizmo {
////                    target: ambient
////                }
//            }
//        }
    }

    Connections {
        target: camera1
        onPositionChanged: updateGizmo()
        onRotationChanged: updateGizmo()
    }

//    Timer {
//        running: true
//        interval: 1000
//        repeat: true
//        onTriggered: updateGizmo()
//    }

    function updateGizmo()
    {
        var gizmoScreenPos = demonview.worldToView(gizmo.position)
        if (gizmoScreenPos.x === -1) {
            print("gizmo not visible!")
            return
        }
        var gizmoWorldPos = demonview.viewToWorld(gizmoScreenPos)
        gizmo.position = gizmoWorldPos
//        print("screen pos:", gizmoScreenPos, "world pos:", gizmoWorldPos, "cam pos:", camera1.position);

        //            var gizmoSizePos = Qt.vector3d(gizmoScreenPos.x + 50, gizmoScreenPos.y, gizmoScreenPos.z)
        //            var gizmoSizeWorldPos = demonview.viewToWorld(gizmoSizePos)

        //            var p2 = gizmo.position;

        //            var v = Qt.vector3d(p2.x, p2.y, p2.z);
        //            v.x -= gizmoSizeWorldPos.x
        //            v.y -= gizmoSizeWorldPos.y
        //            v.z -= gizmoSizeWorldPos.z
        //            var len = Math.sqrt(v.x * v.x + v.y * v.y + v.z * v.z)
        //            print("world length:", len);
    }

}
