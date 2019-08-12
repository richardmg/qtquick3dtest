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
                    objectName: "worldGizmo"
                    scale: Qt.vector3d(5, 5, 5)
                }
            }
        }

        View3D {
            id: overlay
            anchors.fill: parent
//            visible: false
            scene: OverlayScene {
                id: overlayScene
                mainView: worldView

                onUpdateOverlay: {
                    worldGizmo.position = targetNode.globalPosition
//                    overlayGizmo.position = overlayPos(targetNode)
                    print(targetNode.globalPosition)
                }

                Gizmo {
                    id: overlayGizmo
                    scale: Qt.vector3d(5, 5, 5)
                }
            }
        }
    }

    WasdController {
        controlledObject: worldView.camera
    }

    /*
      After vacation notes:

      So what I'm trying to do is to have an icon or gizmo stay on top of a node
      in the world. I could do this by letting the icon be a child of the node, but
      then it would also inherit the scale and rotation of that node, which is not
      what I want. Besides, the icon should be shown with an orthographic camera
      rather than the perspective one.

      The problem is that worldTransform is only calculated for any node when we
      update the spacial node graph. And if I try to move another node at this
      point, upon receiving the globalTransformChanged signals, I run into a couple
      of problems:
      1. setting a nodes position at this point will not take effect until the next
        time we update the graph. The result will be that the icon will seem to wiggle
        after the node, rather than staying put.
      2. Actually, trying to change the position of a node while we're updating the
        graph puts it into a locked situation. Setting a position at this point will
        set the dirty flag and add the node to the dirty list, but this will all be
        cleared once the graph has finsihed updating, so nothing will take effect.

      This all makes me think that:
      1. whenever someone asks for the globalTransform, we need to check if the transform
        is dirty all the way to the root. And if so, calculate the new transform there
        and then. Otherwise globalTransform becomes pretty useless for scenarios like
        the one described above.
      2. We should postpone emitting globalTransformChanged until we're done updating
        the graph, so that any new changes will be recorded. And then we need a
        second pass to update all the new dirty nodes, which should normally not be
        that many.
        Or, we could separate out all the nodes/scripts that needs to use globalTransform
        into a separate pass all the way from the start.
        Or, we could check if a node should emit globalTransformChanged at the time when
        someone assigns it e.g a new position. If so, we emit the signal immediately. This
        would need to be registered all the way to the root. The downside is that we might
        end up updating the globalTransform more than needed if you e.g first set position, then
        set scale.
        So, we could postpose emitting globalTransform changed until when we're about to
        update the graph. We then do one pass when we calculate the global transform for the
        relevant nodes, and emit signals. After that, we update the nodes (and the possible
        new global transforms after signal emitting) like we do today.
      */

}
