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

    property Node targetNode

    Sky {
        anchors.fill: parent

        View3D {
            id: worldView
            anchors.fill: parent
            camera: worldScene.camera
            visible: false
            scene: WorldScene {
                id: worldScene
            }
        }

        View3D {
            id: overlay
            anchors.fill: parent
            camera: overlayCamera
            scene: Node {
                id: overlayScene

                Camera {
                    id: overlayCamera
                    projectionMode: Camera.Orthographic
                    objectName: "overlayCamera"
                }

                Gizmo {
                    id: sceneOrientation
                    scale: Qt.vector3d(5, 5, 5)
                    position: overlay.viewToScene.transform(Qt.vector3d(100, 100, 100))
                    rotation: worldView.camera.globalRotation
                }

                Gizmo {
                    id: trackingOtherNode
                    scale: Qt.vector3d(5, 5, 5)
                    position: overlayCamera.viewportToScene.transform(worldView.camera.sceneToViewport.transform(targetNode.globalPosition))
                    rotation: targetNode.globalRotation
                }
            }
        }
    }

    WasdController {
        controlledObject: worldView.camera
    }
}
