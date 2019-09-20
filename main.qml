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
                Camera {
                    id: camera1
                    y: 200
                    z: -300
                    clipFar: 100000
                    projectionMode: perspectiveControl.checked ? Camera.Perspective : Camera.Orthographic
                }

                Light {
                    id: light
                    y: 400
                    diffuseColor: Qt.rgba(0.4, 0.5, 0.0, 1.0)
                    rotation: Qt.vector3d(60, 0, 0)
                    brightness: 80
                }

//                AxisHelper {
//                    enableXZGrid: true
//                    enableAxisLines: false
//                }

                Model {
                    id: initalPot
                    objectName: "initalPot"
                    y: 200
//                    rotation: Qt.vector3d(0, 0, 45)
                    source: "#Cube"
//                    scale: Qt.vector3d(20, 20, 20)
                    materials: DefaultMaterial {
                        diffuseColor: "salmon"
                    }
                }
            }
        }

        TapHandler {
            onTapped: {
                print("PICK FROM WORLDVIEW")
                var pickResult = worldView.pick(point.position.x, point.position.y)
                print(pickResult.objectHit)
                print("PICK FROM GIZMO VIEW")
                var pickResult2 = gizmo.pick(point.position.x, point.position.y)
                print(pickResult2.objectHit)
            }
        }

//        View3D {
//            id: overlayView
////            anchors.fill: parent
//            camera: overlayCamera
//            visible: false
////            scene: Node {

//                Camera {
//                    id: overlayCamera
//                    projectionMode: perspectiveControl.checked ? Camera.Perspective : Camera.Orthographic
//                    clipFar: camera1.clipFar
//                    position: camera1.position
//                    rotation: camera1.rotation
//                }

//                Arrows {
//                    id: targetGizmo
//                    objectName: "Arrows overlay"
//                    scale: autoScale.getScale(Qt.vector3d(5, 5, 5))
//                    highlightOnHover: true
//                    position: window.nodeBeingManipulated.positionInScene
//                    rotation: globalControl.checked ? Qt.vector3d(0, 0, 0) : window.nodeBeingManipulated.rotationInScene
//                }

////                Overlay3D {
////                    id: autoScale
////                    overlayView: overlayView
////                    position: targetGizmo.positionInScene
////                }
////            }

//        }


        CameraGizmo {
            id: gizmo
            targetCamera: camera1
            anchors.right: parent.right
//            width: 100
//            height: 100
        }

        WasdController {
            id: wasd
            controlledObject: worldView.camera
            acceptedButtons: Qt.RightButton
        }

        Overlay2D {
            id: overlayGizmo2D
            targetNode: nodeBeingManipulated
            targetView: worldView
            offsetY: 100
            visible: showLabelsControl.checked

            Rectangle {
                color: "white"
                x: -width / 2
                y: -height
                width: text.width + 4
                height: text.height + 4
                border.width: 1
                Text {
                    id: text
                    text: nodeBeingManipulated.objectName
                    anchors.centerIn: parent
                }
            }
        }
    }

    Item {
        id: menu
        anchors.fill: parent
        visible: menuButton.checked
        z: 100

//        Rectangle {
//            anchors.fill: parent
//            color: "white"
//            opacity: 0.7
//        }

        RowLayout {
            id: topRow
            x: menuButton.width + 10
            width: parent.width
            height: childrenRect.height

            ToolButton {
                text: qsTr("Add pot")
            }
            ToolButton {
                text: qsTr("Reset camera")
                onClicked: {
                    camera1.position = Qt.vector3d(0, 200, -300)
                    camera1.rotation = Qt.vector3d(0, 0, 0)
                }
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
                text: qsTr("Use global orientation")
                checked: true
            }
            CheckBox {
                id: perspectiveControl
                text: qsTr("Use perspective transform")
                checked: true
            }
            CheckBox {
                id: autoScaleControl
                text: qsTr("Use fixed-sized gizmo")
                checked: true
            }
            CheckBox {
                id: showLabelsControl
                text: qsTr("Show labels")
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
        rotation: 90
        checkable: true
        onCheckedChanged: wasd.forceActiveFocus()
    }

}
