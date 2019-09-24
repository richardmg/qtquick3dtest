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

    property Node nodeBeingManipulated: initalPot

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

        Overlay3D {
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
            id: worldView
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
            id: overlayLabels
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

        WasdController {
            id: wasd
            controlledObject: worldView.camera
            acceptedButtons: Qt.RightButton
        }
    }

    ToolButton {
        id: menuButton
        text: "|||"
        rotation: 90
        checkable: true
        onCheckedChanged: wasd.forceActiveFocus()
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

}
