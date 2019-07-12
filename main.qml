import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick3D 1.0
import QtQuick3D.Helpers 1.0
import QtQuick3D.Scripts 1.0

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
        running: true
        repeat: true
        interval: msPerHour
        onTriggered: time++
    }

    Node {
        id: scene

        Camera {
            id: camera1
            z: -600
//            projectionMode: Quick3DCamera.Orthographic
            y: 200
//            rotation: Qt.vector3d(15, 0, 0)
        }

//        Sun {
//            secondsPerOrbit: 10
//        }

        ConeLight {
            id: ambient
            y: 400
            diffuseColor: Qt.rgba(0.4, 0.5, 0.0, 1.0)
            rotation: Qt.vector3d(60, 0, 0)
            brightness: 30
//            gizmo: Gizmo.Light
        }

        Lowpolylandscape {
            id: landscape
//            ScaleToLookFixed.camera: camera1
//            ScaleToLookFixed.scale: Qt.vector3d(0.1, 0.1, 0.1)
        }

//        AxisHelper {
//            enableAxisLines: true
//            enableXZGrid: true
//            enableYZGrid: false
//            enableXYGrid: true
//        }

//        Gizmo {
//            parent: camera1
//            z: 100
////            StayInFrontOfCamera.camera: camera1
////            StayInFrontOfCamera.viewportPosition: Qt.vector3d(0.05, 0.2, 20)
//            scale: Qt.vector3d(0.2, 0.2, 0.2)
//        }
    }

    Component {
        id: ray
        Model {
            source: "meshes/Arrow.mesh"
            rotation: Qt.vector3d(90, 0, 0)
            materials: DefaultMaterial {
                diffuseColor: "red"
                lighting: DefaultMaterial.NoLighting
            }
        }
    }

    Sky {
        anchors.fill: parent
        View3D {
            id: demonview
            anchors.fill: parent
            scene: scene
            camera: camera1
        }

        View3D {
            id: overlay
            anchors.fill: parent
            scene: Node {
                Camera {
                    projectionMode: Camera.Orthographic
                    Gizmo {
                        id: gizmo2
                        x: -550
                        y: 350
                        z: 500
                        // This implementation assumes that the camera is a child of root
                        rotation: Qt.vector3d(-camera1.rotation.x, -camera1.rotation.y, -camera1.rotation.z)
                        scale: Qt.vector3d(5, 5, 5)
                    }
                }
            }
        }
    }

        WasdController {
            controlledObject: camera1
            x: 0
            y: 0
            width: parent.width
            height: parent.height
            speed: 1
        }

//        PointHandler {
//            acceptedButtons: Qt.RightButton
//            onPointChanged: {
//                if (!point.pressure)
//                    return

//                var screenPosNear = Qt.vector3d(point.position.x, point.position.y, 0);
//                var worldPosNear = demonview.viewToWorld(screenPosNear)

//                var screenPosFar = Qt.vector3d(point.position.x, point.position.y, 10);
//                var worldPosFar = demonview.viewToWorld(screenPosFar)

//                var arrow = ray.createObject(scene)
//                arrow.position = worldPosFar
//                //arrow.lookAtGlobal(worldPosFar)
//            }
//        }

}
