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

                    var xLabelScenePos = sceneGizmo.arrowX.mapPositionToScene(Qt.vector3d(0, 2, -12));
                    var xLabelViewPos = root.mapFrom3DScene(xLabelScenePos)
                    xLabel.x = xLabelViewPos.x - xLabel.width
                    xLabel.y = xLabelViewPos.y - xLabel.height

                    var yLabelScenePos = sceneGizmo.arrowY.mapPositionToScene(Qt.vector3d(4, 0, -9.5));
                    var yLabelViewPos = root.mapFrom3DScene(yLabelScenePos)
                    yLabel.x = yLabelViewPos.x - yLabel.width
                    yLabel.y = yLabelViewPos.y - yLabel.height

                    var zLabelScenePos = sceneGizmo.arrowZ.mapPositionToScene(Qt.vector3d(0, 2, -12));
                    var zLabelViewPos = root.mapFrom3DScene(zLabelScenePos)
                    zLabel.x = zLabelViewPos.x - zLabel.width
                    zLabel.y = zLabelViewPos.y - zLabel.height
                }
            }
        }
    }

    Text {
        id: xLabel
        text: "x"
        color: "red"
    }

    Text {
        id: yLabel
        text: "y"
        color: "blue"
    }

    Text {
        id: zLabel
        text: "z"
        color: "green"
    }

}
