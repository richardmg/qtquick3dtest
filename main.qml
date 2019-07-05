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
        running: true
        repeat: true
        interval: msPerHour
        onTriggered: time++
    }

    DemonNode {
        id: scene

        DemonCamera {
            id: camera1
            z: -600
//            projectionMode: DemonCamera.Orthographic
            y: 200
            rotation: Qt.vector3d(15, 0, 0)
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

        Lowpolylandscape {
            id: landscape
        }

//        AxisHelper {
//            enableAxisLines: true
//            enableXZGrid: true
//            enableYZGrid: false
//            enableXYGrid: true
//        }

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

        WasdController {
            controlledObject: camera1
            x: 0
            y: 0
            width: parent.width
            height: parent.height
            speed: 0.1
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
