import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick3D 1.0
import QtQuick3D.Helpers 1.0
import QtQuick3D.Scripts 1.0

import QtQuick.Controls 2.5
import QtQuick.Layouts 1.12

ApplicationWindow {
    id: window
    width: 640
    height: 480
    visible: true

    property Node targetNode: initalPot
    property var targetPos
    property var startDragPos

    property bool useGlobalGizmo: true
    property bool usePerspective: true

    property bool hoveringGizmoHeadX: false
    property bool hoveringGizmoHeadY: false
    property bool hoveringGizmoHeadZ: false

    property bool draggingGizmoHeadX: false
    property bool draggingGizmoHeadY: false
    property bool draggingGizmoHeadZ: false

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
                    targetNode: window.targetNode
                    targetView: worldView
                    Arrows {
                        highlightX: hoveringGizmoHeadX || draggingGizmoHeadX
                        highlightY: hoveringGizmoHeadY || draggingGizmoHeadY
                        highlightZ: hoveringGizmoHeadZ || draggingGizmoHeadZ
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

        HoverHandler {
            id: handler
            onPointChanged: {
                var hoverRadius = 20
                var eventX = point.position.x
                var eventY = point.position.y

                var xArrowHeadPos = targetGizmo.mapToGlobal(Qt.vector3d(80, 0, 0))
                var yArrowHeadPos = targetGizmo.mapToGlobal(Qt.vector3d(0, 80, 0))
                var zArrowHeadPos = targetGizmo.mapToGlobal(Qt.vector3d(0, 0, 80))

                var xArrowHeadPosInView = overlayView.mapFrom3DScene(xArrowHeadPos)
                var yArrowHeadPosInView = overlayView.mapFrom3DScene(yArrowHeadPos)
                var zArrowHeadPosInView = overlayView.mapFrom3DScene(zArrowHeadPos)

                var distX = Math.sqrt(Math.pow(eventX - xArrowHeadPosInView.x, 2) + Math.pow(eventY - xArrowHeadPosInView.y, 2))
                var distY = Math.sqrt(Math.pow(eventX - yArrowHeadPosInView.x, 2) + Math.pow(eventY - yArrowHeadPosInView.y, 2))
                var distZ = Math.sqrt(Math.pow(eventX - zArrowHeadPosInView.x, 2) + Math.pow(eventY - zArrowHeadPosInView.y, 2))

                hoveringGizmoHeadX = distX < hoverRadius
                hoveringGizmoHeadY = distY < hoverRadius
                hoveringGizmoHeadZ = distZ < hoverRadius

                // We could also check z in xyzArrowHeadPosInView in case we hover more than one head
            }
        }

        PointHandler {
            id: pointHandler
            acceptedButtons: Qt.LeftButton
            property bool pressed: point.pressedButtons === Qt.LeftButton
            onPressedChanged: {
                if (pressed) {
                    startDragPos = point.position
                    targetPos = targetNode.position
                    if (hoveringGizmoHeadX)
                        draggingGizmoHeadX = true
                    if (hoveringGizmoHeadY)
                        draggingGizmoHeadY = true
                    if (hoveringGizmoHeadZ)
                        draggingGizmoHeadZ = true
                } else {
                    draggingGizmoHeadX = false
                    draggingGizmoHeadY = false
                    draggingGizmoHeadZ = false
                }
            }
        }

        DragHandler {
            target: null
            acceptedButtons: Qt.LeftButton
            onCentroidChanged: {
                if (centroid.pressedButtons !== Qt.LeftButton)
                    return

                // 1. We should not get a change to centroid when dragging stops (with an unrelated position), since
                // 		that will just confuse any calculations. We're then (after som debugging) forced to check
                // 		centroid.pressedButtons.
                // 2  Add a pressed property to _all_ PointerHandlers, at least PointHandler.
//                print("drag:", centroid.pressedButtons === Qt.LeftButton, centroid.position)

                var diffPosX = startDragPos.x - centroid.position.x
                var diffPosY = startDragPos.y - centroid.position.y

                if (draggingGizmoHeadX)
                    targetNode.position = Qt.vector3d(targetNode.position.x - diffPosX, targetPos.y, targetPos.z)
                startDragPos = centroid.position
            }
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
