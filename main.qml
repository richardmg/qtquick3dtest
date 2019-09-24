import QtQuick 2.12
import QtQuick.Window 2.12

import QtQuick3D 1.0
import QtQuick3D.Helpers 1.0

import QtGraphicalEffects 1.0

import QtQuick.Controls 2.5
import QtQuick.Layouts 1.12

import MouseArea3D 0.1

ApplicationWindow {
    id: window
    width: 640
    height: 480
    visible: true

    property Node nodeBeingManipulated: pot1

    Node {
        id: mainScene

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

        AxisHelper {
            id: axisGrid
            enableXZGrid: true
            enableAxisLines: false
        }

        Model {
            id: pot1
            objectName: "First pot"
            y: 200
            rotation: Qt.vector3d(0, 0, 45)
            source: "meshes/Teapot.mesh"
            scale: Qt.vector3d(20, 20, 20)
            materials: DefaultMaterial {
                diffuseColor: "salmon"
            }
        }

        Model {
            id: pot2
            objectName: "Second pot"
            x: 200
            y: 200
            z: 300
            rotation: Qt.vector3d(45, 45, 0)
            source: "meshes/Teapot.mesh"
            scale: Qt.vector3d(20, 20, 20)
            materials: DefaultMaterial {
                diffuseColor: "salmon"
            }
        }
    }

    Node {
        id: overlayScene

        Camera {
            id: overlayCamera
            projectionMode: perspectiveControl.checked ? Camera.Perspective : Camera.Orthographic
            clipFar: camera1.clipFar
            position: camera1.position
            rotation: camera1.rotation
        }

        MoveGizmo {
            id: targetGizmo
            scale: autoScaleControl.checked ? autoScale.getScale(Qt.vector3d(5, 5, 5)) : Qt.vector3d(5, 5, 5)
            highlightOnHover: true
            draggable: true
            position: window.nodeBeingManipulated.positionInScene
            rotation: globalControl.checked ? Qt.vector3d(0, 0, 0) : window.nodeBeingManipulated.rotationInScene
        }

        AutoScaleHelper {
            id: autoScale
            overlayView: overlayView
            position: targetGizmo.positionInScene
        }
    }

    RadialGradient {
        id: sceneBg
        anchors.fill: parent

        gradient: Gradient {
            GradientStop { position: 0.0; color: Qt.rgba(0.7, 0.7, 0.8, 1) }
            GradientStop { position: 0.5; color: Qt.rgba(0.5, 0.5, 0.5, 1) }
        }

        View3D {
            id: mainView
            anchors.fill: parent
            camera: camera1
            scene: mainScene
        }

        View3D {
            id: overlayView
            anchors.fill: parent
            camera: overlayCamera
            scene: overlayScene
        }

        CameraGizmo {
            targetCamera: camera1
            anchors.right: parent.right
            width: 100
            height: 100
        }

        Overlay2D {
            id: overlayLabel
            targetNode: nodeBeingManipulated
            targetView: mainView
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

        WasdController {
            id: wasd
            controlledObject: mainView.camera
            acceptedButtons: Qt.RightButton
        }

        TapHandler {
            onTapped: {
                // Pick a pot, and use it as target for the gizmo
                var pickResult = mainView.pick(point.position.x, point.position.y)
                print("picked in mainView:", pickResult.objectHit)

                if (pickResult.objectHit && pickResult.objectHit !== axisGrid)
                    nodeBeingManipulated = pickResult.objectHit

                // Dummy test for now, just to show how it doesn't work to click on an arrow/gizmo
                var pickResult2 = overlayView.pick(point.position.x, point.position.y)
                print("picked in overlayView:", pickResult2.objectHit)
            }
        }
    }

    Item {
        id: menu
        anchors.fill: parent

        ColumnLayout {
            anchors.fill: parent

            CheckBox {
                id: globalControl
                checked: true
                onCheckedChanged: wasd.forceActiveFocus()
                Text {
                    anchors.left: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    text: qsTr("Use global orientation")
                }
            }
            CheckBox {
                id: perspectiveControl
                checked: true
                onCheckedChanged: wasd.forceActiveFocus()
                Text {
                    anchors.left: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    text: qsTr("Use perspective transform")
                }
            }
            CheckBox {
                id: autoScaleControl
                checked: true
                onCheckedChanged: wasd.forceActiveFocus()
                Text {
                    anchors.left: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    text: qsTr("Use fixed-sized gizmo")
                }
            }
            CheckBox {
                id: showLabelsControl
                checked: true
                onCheckedChanged: wasd.forceActiveFocus()
                Text {
                    anchors.left: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    text: qsTr("Show labels")
                }
            }
            Item {
                Layout.fillHeight: true
            }
        }
    }

}
