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
                    //sceneGizmo.position = overlayCamera.mapToScene(Qt.vector3d(0.94, 0.08, 10))
                    sceneGizmo.position = localCamera.mapFromViewport(Qt.vector3d(0.5, 0.5, 180))
                }
            }
        }

// in-world-scene implementation
//                Arrows {
//                    id: sceneGizmo
//                    scale: Qt.vector3d(0.1, 0.1, 0.1)
//                    Connections {
//                        target: overlayCamera
//                        onGlobalTransformChanged: {
//                            // A problem here is that the target and this node belongs to two different
//                            // views. And therefore they might not be completly in sync. Especially, the
//                            // first emit does not seem to get throught...
//                            //sceneGizmo.position = overlayCamera.mapToScene(Qt.vector3d(0.94, 0.08, 10))
//                            sceneGizmo.position = overlayCamera.mapToScene(Qt.vector3d(0.5, 0.5, 10))
//                        }
//                    }
//                }
    }
}
