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
//        running: true
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
            brightness: 80
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
                    id: camera2
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

                Model {
                    id: testIcon
                    source: "#Cone"
                    z: 200
//                    scale: Qt.vector3d(10, 10, 10)
                    materials: DefaultMaterial {
                        diffuseColor: "red"
                        lighting: DefaultMaterial.NoLighting
                    }

                    // Listen for changes to view position of landscape. Whenever it changes, move the
                    // cone the same position in the world according to the orthographic perspective
                    // on this camera.

                    Connections {
                        target: camera1
                        onRotationChanged: updatePos()
                        onPositionChanged: updatePos()
//                        onTransformChanged: updatePos()

                        function updatePos()
                        {
                            // use landscape.globalPosition? Note, Unity uses position to mean global, and
                            // then localPosition to mean local. Is this more intuitive?
                            var cam1PosView = camera1.worldToViewport(landscape.position)
                            var cam2PosWorld = camera2.viewportToWorld(cam1PosView)
                            testIcon.position = cam2PosWorld // assing to globalPosition


                            /*
                              After vacation notes:

                              So what I'm trying to do is to have an icon or gizmo stay on top of a node
                              in the world. I could do this by letting the icon be a child of the node, but
                              then it would also inherit the scale and rotation of that node, which is not
                              what I want. Besides, the icon should be shown with an orthographic camera
                              rather than the perspective one.

                              The problem is that worldTransform is only calculated for any node when we
                              update the spacial node graph. And if I try to move another node at this
                              point, upon receiving the globalTransformChanged signals, I run into a couple
                              of problems:
                              1. setting a nodes position at this point will not take effect until the next
                                time we update the graph. The result will be that the icon will seem to wiggle
                                after the node, rather than staying put.
                              2. Actually, trying to change the position of a node while we're updating the
                                graph puts it into a locked situation. Setting a position at this point will
                                set the dirty flag and add the node to the dirty list, but this will all be
                                cleared once the graph has finsihed updating, so nothing will take effect.

                              This all makes me think that:
                              1. whenever someone asks for the globalTransform, we need to check if the transform
                                is dirty all the way to the root. And if so, calculate the new transform there
                                and then. Otherwise globalTransform becomes pretty useless for scenarios like
                                the one described above.
                              2. We should postpone emitting globalTransformChanged until we're done updating
                                the graph, so that any new changes will be recorded. And then we need a
                                second pass to update all the new dirty nodes, which should normally not be
                                that many.
                                Or, we could separate out all the nodes/scripts that needs to use globalTransform
                                into a separate pass all the way from the start.
                                Or, we could check if a node should emit globalTransformChanged at the time when
                                someone assigns it e.g a new position. If so, we emit the signal immediately. This
                                would need to be registered all the way to the root. The downside is that we might
                                end up updating the globalTransform more than needed if you e.g first set position, then
                                set scale.
                                So, we could postpose emitting globalTransform changed until when we're about to
                                update the graph. We then do one pass when we calculate the global transform for the
                                relevant nodes, and emit signals. After that, we update the nodes (and the possible
                                new global transforms after signal emitting) like we do today.
                              */
                        }
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
