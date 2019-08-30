import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick3D 1.0
import QtQuick3D.Helpers 1.0
import QtQuick3D.Scripts 1.0

import QtQuick.Controls 2.5
import QtQuick.Layouts 1.12

import MouseArea3D 0.1

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
                    z: -300
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
//                    rotation: Qt.vector3d(0, 90, 0)
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
                        id: arrows
                        highlightX: mousePointGizmoX.hovering || mousePointGizmoX.dragging
                        highlightY: mousePointGizmoY.hovering || mousePointGizmoY.dragging
                        highlightZ: mousePointGizmoZ.hovering || mousePointGizmoZ.dragging
                        MouseArea3D {
                            id: mousePointGizmoX
                            view3D: overlayView
                            x: 0
                            y: -1.5
                            width: 12
                            height: 3
                            onDragMoved: {
                                var oldPos = nodeBeingManipulated.position
                                var globalDeltaX = deltaX * arrows.globalScale.x
                                var targetDeltaX = globalDeltaX / nodeBeingManipulated.parent.globalScale.x
                                nodeBeingManipulated.position = Qt.vector3d(oldPos.x + targetDeltaX, oldPos.y, oldPos.z)
                            }
                        }
                        MouseArea3D {
                            id: mousePointGizmoY
                            view3D: overlayView
                            x: -0.5
                            y: 0
                            width: 3
                            height: 12
                            onDragMoved: {
                                var oldPos = nodeBeingManipulated.position
                                var globalDeltaY = deltaY * arrows.globalScale.y
                                var targetDeltaY = globalDeltaY / nodeBeingManipulated.parent.globalScale.y
                                nodeBeingManipulated.position = Qt.vector3d(oldPos.x, oldPos.y + targetDeltaY, oldPos.z)
                            }
                        }
                        MouseArea3D {
                            id: mousePointGizmoZ
                            view3D: overlayView
                            onDragMoved: {
//                                var oldPos = nodeBeingManipulated.position
//                                var globalDeltaX = deltaX * arrows.globalScale.x
//                                var targetDeltaX = globalDeltaX / nodeBeingManipulated.parent.globalScale.x
//                                nodeBeingManipulated.position = Qt.vector3d(oldPos.x + targetDeltaX, oldPos.y, oldPos.z)
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

        WasdController {
            controlledObject: worldView.camera
            acceptedButtons: Qt.RightButton
        }

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
