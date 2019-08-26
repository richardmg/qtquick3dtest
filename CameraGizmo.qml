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
    implicitWidth: 50
    implicitHeight: 50

    scene: Node {
        Camera {
            id: localCamera
//            fieldOfView: 23
            position: targetCamera.globalPosition
            rotation: targetCamera.globalRotation
            onGlobalTransformChanged: {
                arrows.position = mapToScene(Qt.vector3d(0.5, 0.5, 20))
            }
        }

        Arrows {
            id: arrows
        }
    }
}
