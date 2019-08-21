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
            scene: WorldScene {
                id: worldScene
                Gizmo {
                    id: worldGizmo
                    scale: Qt.vector3d(0.08, 0.08, 0.08)
                    Connections {
                        target: worldView.camera
                        onGlobalTransformChanged: worldGizmo.position = worldView.viewToWorld(Qt.vector3d(45, 45, 10))
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
                    projectionMode: Camera.Orthographic
                    objectName: "overlayCamera"
                }

                Gizmo {
                    id: gadget
                    scale: Qt.vector3d(5, 5, 5)

                    Connections {
                        target: targetNode
                        onGlobalTransformChanged: gadget.updateGadget()
                    }

                    Connections {
                        target: worldView.camera
                        onGlobalTransformChanged: gadget.updateGadget()
                    }

                    function updateGadget()
                    {
                        // Consider putting all this in a OverlayIconScript
                        var viewportPos = worldView.camera.worldToViewport(targetNode.globalPosition)
                        position = overlayCamera.viewportToWorld(viewportPos)
                        rotation = targetNode.globalRotation
                    }
                }
            }
        }
    }

    Rectangle {
        id: hoverIcon
        color: "magenta"
        width: 50
        height: 50

        Connections {
            target: targetNode
            onGlobalPositionChanged: hoverIcon.updateGadget()
        }

        function updateGadget()
        {
            // Consider putting all this in a OverlayIconScript
            var viewportPos = worldView.worldToView(targetNode.globalPosition)
            x = viewportPos.x
            y = viewportPos.y - 100
        }
    }

    WasdController {
        controlledObject: worldView.camera
    }
}
