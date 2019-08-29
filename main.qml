import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick3D 1.0
import QtQuick3D.Helpers 1.0
import QtQuick3D.Scripts 1.0

import QtQuick.Controls 2.5
import QtQuick.Layouts 1.12

import MousePoint3D 0.1

ApplicationWindow {
    id: window
    width: 640
    height: 480
    visible: true

    property Node nodeBeingManipulated: initalPot

    property bool useGlobalGizmo: true
    property bool usePerspective: true

    header: ToolBar {
        RowLayout {
            anchors.fill: parent
            ToolButton {
                text: useGlobalGizmo ? qsTr("Global") : qsTr("Local")
                onClicked: useGlobalGizmo = !useGlobalGizmo
            }
            ToolButton {
                text: usePerspective ? qsTr("Perspective") : qsTr("Orthographic")
                onClicked: usePerspective = !usePerspective
            }
            ToolButton {
                text: qsTr("+Cone")
            }
            Item {
                Layout.fillWidth: true
            }
        }
    }

    Sky {
        id: sceneBg
        anchors.fill: parent

        View3D {
            id: worldView
            anchors.fill: parent
            camera: camera1
            scene: Node {
                id: scene
                Camera {
                    id: camera1
                    y: 200
                    z: -500
                }

                Light {
                    id: light
                    y: 400
                    diffuseColor: Qt.rgba(0.4, 0.5, 0.0, 1.0)
                    rotation: Qt.vector3d(60, 0, 0)
                    brightness: 80
                }

                AxisHelper {
                    enableXZGrid: true
                    enableAxisLines: false
                }

                Model {
                    id: initalPot
                    y: 200
                    source: "meshes/Teapot.mesh"
                    scale: Qt.vector3d(20, 20, 20)
                    materials: DefaultMaterial {
                        diffuseColor: "salmon"
                    }
                }
            }
        }

        View3D {
            id: overlayView
            anchors.fill: parent
            camera: overlayCamera
            scene: Node {
                id: overlayScene

                Camera {
                    id: overlayCamera
                    projectionMode: usePerspective ? Camera.Perspective : Camera.Orthographic
                    position: camera1.position
                    rotation: camera1.rotation
                }

                Overlay3D {
                    id: targetGizmo
                    // Note: if you want orthograhic projections, you might as well
                    // use Overlay2D, since you achive the same. And in both cases, you
                    // cannot use the same overlay with two different cameras/views.
                    // The same is also true if you want perspective, and use auto
                    // scaling or billboarding.
                    targetNode: window.nodeBeingManipulated
                    targetView: worldView
                    Arrows {
                        highlightX: mousePointGizmoX.hovering || mousePointGizmoX.dragging
                        highlightY: mousePointGizmoY.hovering || mousePointGizmoY.dragging
                        MousePoint3D {
                            id: mousePointGizmoX
                            view3D: overlayView
                            position: Qt.vector3d(11, 0, 0)
                            onDragMoved: {
                                var oldPos = nodeBeingManipulated.position
                                nodeBeingManipulated.position = Qt.vector3d(oldPos.x + deltaX, oldPos.y, oldPos.z)
                            }
                        }
                        MousePoint3D {
                            id: mousePointGizmoY
                            view3D: overlayView
                            position: Qt.vector3d(0, 11, 0)
                            onDragMoved: {
                                var oldPos = nodeBeingManipulated.position
                                nodeBeingManipulated.position = Qt.vector3d(oldPos.x, oldPos.y - deltaY, oldPos.z)
                            }
                        }
                    }
                }
            }

        }

        CameraGizmo {
            targetCamera: camera1
            anchors.right: parent.right
        }

//        WasdController {
//            controlledObject: worldView.camera
//            mouseEnabled: !hoveringGizmoHeadX
//        }

//        DragHandler3D {
//            id: dragHandlerGizmoX
//            view3D: overlayView
//            targetNode: targetGizmo
//            localPosition: Qt.vector3d(80, 0, 0)
//            onDragMoved: {
//                var oldPos = nodeBeingManipulated.position
//                nodeBeingManipulated.position = Qt.vector3d(oldPos.x + deltaX, oldPos.y, oldPos.z)
//            }
//        }

//        DragHandler3D {
//            id: dragHandlerGizmoY
//            view3D: overlayView
//            targetNode: targetGizmo
//            localPosition: Qt.vector3d(0, 80, 0)
//            onDragMoved: {
//                var oldPos = nodeBeingManipulated.position
//                nodeBeingManipulated.position = Qt.vector3d(oldPos.x, oldPos.y - deltaY, oldPos.z)
//            }
//        }

//        overlay2d {
//            id: overlayGizmo2D
//            targetNode: window.targetNode
//            targetView: worldView

//            Rectangle {
//                color: "magenta"
//                y: -100
//                width: 50
//                height: 50
//            }
//        }

    }
}
