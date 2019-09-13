import QtQuick 2.0
import QtQuick3D 1.0

/*
    The gizmo showing the rotation of the camera differs from other
    gizmos by the fact that it doesn't overlay the camera in the
    scene, but rather stays in a corner of the view. Still, the
    perspective of the gizmo should reflect the perspective as if
    it was located on the same spot as the camera. For that reason, we
    draw it in a separate View3D, which means that the user can position
    it wherever he wants on the screen without affecting how it looks.
 */
View3D {
    id: root
    property Camera targetCamera
//    implicitWidth: 50
//    implicitHeight: 50
    width: parent.width
    height: parent.height
    camera: localCamera

    scene: Node {
        Camera {
            id: localCamera
            position: targetCamera.positionInScene
            rotation: targetCamera.rotationInScene
        }

        Arrows {
            id: sceneGizmo
            Connections {
                target: localCamera
                onGlobalTransformChanged: {
                    // A problem here is that the target and this node belongs to two different
                    // views. And therefore they might not be completly in sync. Especially, the
                    // first emit does not seem to get throught...
                    sceneGizmo.position = localCamera.mapFromViewport(Qt.vector3d(0.5, 0.5, 180))
                    var p1 = sceneGizmo.arrowX.positionInScene
                    var p2 = Qt.vector3d(p1.x, p1.y, 0)
                    xLabel.x = root.mapFrom3DScene(p2).x
                    xLabel.y = root.mapFrom3DScene(p2).y
                    print(p2)
//                    print(sceneGizmo.arrowX.positionInScene, root.mapFrom3DScene(sceneGizmo.arrowX.positionInScene))
                }
            }
        }
    }

    Text {
        id: xLabel
        text: "x"
        color: "red"
//        x: root.mapFrom3DScene(sceneGizmo.arrowX.positionInScene).x
    }

}
