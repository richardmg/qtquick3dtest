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

    property Node targetNode: initalCone
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
        anchors.fill: parent

        View3D {
            id: worldView
            anchors.fill: parent
            camera: camera1
            scene: Node {
                id: scene
                Camera {
                    id: camera1
                    z: -500
                }

                Model {
                    id: initalCone
                    source: "teapot.mesh"
                    scale: Qt.vector3d(0.5, 0.5, 0.5)
                    rotation: Qt.vector3d(45, 45, 45)
                    materials: DefaultMaterial {
                        diffuseColor: "yellow"
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
                    // Note: if you want orthograhic projections, you might as well
                    // use Overlay2D, since you achive the same. And in both cases, you
                    // cannot use the same overlay with two different cameras/views.
                    // The same is also true if you want perspective, and use auto
                    // scaling or billboarding.
                    targetNode: window.targetNode
                    targetView: worldView
                    Arrows {
                        id: overlayGizmo3D
                        scale: Qt.vector3d(5, 5, 5)
                    }
                    trackPosition: false
                }

            }
        }

        CameraGizmo {
            width: 70
            height: 70
            anchors.right: parent.right
            targetCamera: worldView.camera
        }

        Overlay2D {
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
            //acceptedButtons: Qt.RightButton
        }

        TapHandler {
            onTapped: {
                var gp = targetNode.mapToGlobal(Qt.vector3d(45, 0, 0))
                var viewPos = overlayView.mapFrom3DScene(gp)
                print(eventPoint.position, " : ", viewPos)
            }
        }
    }

    /*
      Noen tanker:
      Hvis man lager små 3d views som overlay, så vil de få et annet perspektiv enn de
      nodene de er overlay for. Og det vil kanskje se litt rart ut? I så fall, bør de
      da ha ortho projection? Eller er det derfor bedre å ha ett stort overlay view?
      Så kan man uansett velge projeksjon.

 Vector3 Node::convertWorldToLocalPosition( const Vector3 &worldPos )
    {
        if (mNeedParentUpdate)
        {
            _updateFromParent();
        }
        return mDerivedOrientation.Inverse() * (worldPos - mDerivedPosition) / mDerivedScale;
    }
    //-----------------------------------------------------------------------
    Vector3 Node::convertLocalToWorldPosition( const Vector3 &localPos )
    {
        if (mNeedParentUpdate)
        {
            _updateFromParent();
        }
        return (mDerivedOrientation * localPos * mDerivedScale) + mDerivedPosition;
    }

    */
}
