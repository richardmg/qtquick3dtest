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
            }
        }

        CameraGizmo {
            width: 70
            height: 70
            targetCamera: worldView.camera
        }

        View3D {
            id: overlayView
            anchors.fill: parent
            camera: overlayCamera
            scene: Node {
                id: overlayScene

                Camera {
                    id: overlayCamera
//                    projectionMode: Camera.Orthographic
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
                        var viewportPos = worldView.camera.mapFromScene(targetNode.globalPosition)
                        position = overlayCamera.mapToScene(viewportPos)
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
            onGlobalPositionChanged: {
                // Consider putting all this in a BehaviourScript
                var viewPos = worldView.mapFrom3DScene(targetNode.globalPosition)
                hoverIcon.x = viewPos.x
                hoverIcon.y = viewPos.y - 100
            }
        }
    }

    WasdController {
        controlledObject: worldView.camera
    }

    /*
      Noen tanker:
      Hvis man lager små 3d views som overlay, så vil de få et annet perspektiv enn de
      nodene de er overlay for. Og det vil kanskje se litt rart ut? I så fall, bør de
      da ha ortho projection? Eller er det derfor bedre å ha ett stort overlay view?
      Så kan man uansett velge projeksjon.
    */
}
