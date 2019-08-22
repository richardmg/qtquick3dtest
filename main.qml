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

        View3D {
            id: overlayView
            anchors.fill: parent
            scene: Node {
                id: overlayScene

                Camera {
                    id: overlayCamera
//                    projectionMode: Camera.Orthographic
                    objectName: "overlayCamera"
                    position: worldView.camera.position
                    rotation: worldView.camera.rotation
                }

                Gizmo3D {
                    // Note: if you want orthograhic projections, you might as well
                    // use Overlay2D, since you achive the same. And in both cases, you
                    // cannot use the same overlay with two different cameras/views.
                    targetNode: window.targetNode
                    targetView: worldView
                    Arrows {
                        id: overlayGizmo3D
                        scale: Qt.vector3d(5, 5, 5)
                    }
                    trackRotation: false
                }

            }
        }
    }

    CameraGizmo {
        width: 70
        height: 70
        targetCamera: worldView.camera
    }

    Gizmo2D {
        id: overlayGizmo2D
        targetNode: window.targetNode
        targetView: worldView

        Rectangle {
            color: "magenta"
            y: -100
            width: 50
            height: 50
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
