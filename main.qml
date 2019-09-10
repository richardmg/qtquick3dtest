import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick3D 1.0
import QtQuick3D.Helpers 1.0

import QtQuick.Controls 2.5
import QtQuick.Layouts 1.12

import MouseArea3D 0.1

ApplicationWindow {
    id: window
    width: 640
    height: 480
    visible: true

    property Node nodeBeingManipulated: initalPot

    Sky {
        id: sceneBg
        anchors.fill: parent

        View3D {
            id: worldView
            anchors.fill: parent
            camera: camera1
            scene: Node {
                id: scene
                objectName: "scene root"
                Camera {
                    id: camera1
                    y: 200
                    z: -300
                    projectionMode: perspectiveControl.checked ? Camera.Perspective : Camera.Orthographic
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
                    objectName: "initalPot"
                    y: 200
                    rotation: Qt.vector3d(0, 0, 45)
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
                    projectionMode: perspectiveControl.checked ? Camera.Perspective : Camera.Orthographic
                    position: camera1.position
                    rotation: camera1.rotation
                }

                Overlay3D {
                    id: targetGizmo
                    objectName: "Arrows overlay"
                    overlayView: overlayView
                    autoScale: autoScaleControl.checked
                    position: window.nodeBeingManipulated.globalPosition
                    rotation: globalControl.checked ? Qt.vector3d(0, 0, 0) : window.nodeBeingManipulated.globalRotation
                    Arrows {
                        id: arrows
                        highlightOnHover: true
                    }
                }

            }

        }

        CameraGizmo {
            targetCamera: camera1
            anchors.right: parent.right
        }

        WasdController {
            id: wasd
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

        // last commit: d3fb8b7d7e8a172782d3465658980824702e73e5
        // url: ssh://richard@codereview.qt-project.org:29418/qt/qtquick3d

    }

    Item {
        id: menu
        anchors.fill: parent
        visible: menuButton.checked
        z: 100

        RowLayout {
            id: topRow
            x: menuButton.width + 10
            width: parent.width
            height: childrenRect.height

            ToolButton {
                text: qsTr("Add pot")
            }
            ToolButton {
                text: qsTr("Add pot")
            }
            Item {
                Layout.fillWidth: true
            }
        }

        ColumnLayout {
            anchors.fill: parent
            anchors.topMargin: menuButton.height + 10

            CheckBox {
                id: globalControl
                text: "Use global orientation"
                checked: true
            }
            CheckBox {
                id: perspectiveControl
                text: "Use perspective transform"
                checked: true
            }
            CheckBox {
                id: autoScaleControl
                text: qsTr("Use fixed-sized gizmo")
                checked: true
            }
            Item {
                Layout.fillHeight: true
            }

            TapHandler {
                acceptedButtons: Qt.LeftButton | Qt.RightButton
                onTapped: menuButton.checked = false
            }
        }
    }

    ToolButton {
        id: menuButton
        text: "|||"
        checkable: true
        onCheckedChanged: wasd.forceActiveFocus()
    }

}
