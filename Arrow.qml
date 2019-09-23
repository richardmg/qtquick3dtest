import QtQuick 2.0
import QtQuick3D 1.0
import MouseArea3D 0.1

Model {
    id: arrow
    rotationOrder: Node.XYZr
    source: "meshes/Arrow.mesh"

    property alias color: material.emissiveColor
    property bool draggable: false

    readonly property bool hovering: mouseAreaYZ.hovering || mouseAreaXZ.hovering
    signal pressed()
    signal dragged(var distance)

    property var _pointerPosPressed
    property var _targetStartPos

    materials: DefaultMaterial {
        id: material
        emissiveColor: mouseAreaFront.hovering ? "white" : Qt.rgba(1.0, 0.0, 0.0, 1.0)
        lighting: DefaultMaterial.NoLighting
    }

    function handlePressed(node, pointerPosition)
    {
        if (!draggable)
            return;

        var maskedPosition = Qt.vector3d(pointerPosition.x, 0, 0)
        _pointerPosPressed = node.mapPositionToScene(maskedPosition)
        var sp = nodeBeingManipulated.positionInScene
        _targetStartPos = Qt.vector3d(sp.x, sp.y, sp.z);
    }

    function handleDragged(node, pointerPosition)
    {
        if (!draggable)
            return;

        var maskedPosition = Qt.vector3d(pointerPosition.x, 0, 0)
        var scenePointerPos = node.mapPositionToScene(maskedPosition)
        var sceneRelativeDistance = Qt.vector3d(
                    scenePointerPos.x - _pointerPosPressed.x,
                    scenePointerPos.y - _pointerPosPressed.y,
                    scenePointerPos.z - _pointerPosPressed.z)

        var newScenePos = Qt.vector3d(
                    _targetStartPos.x + sceneRelativeDistance.x,
                    _targetStartPos.y + sceneRelativeDistance.y,
                    _targetStartPos.z + sceneRelativeDistance.z)

        var posInParent = nodeBeingManipulated.parent.mapPositionFromScene(newScenePos)
        nodeBeingManipulated.position = posInParent
    }

    MouseArea3D {
        id: mouseAreaYZ
        view3D: overlayView
        x: 0
        y: -1.5
        width: 12
        height: 3
        rotation: Qt.vector3d(0, 90, 0)
        grabsMouse: draggable
        onPressed: arrow.handlePressed(mouseAreaYZ, pointerPosition)
        onDragged: arrow.handleDragged(mouseAreaYZ, pointerPosition)
    }

    MouseArea3D {
        id: mouseAreaXZ
        view3D: overlayView
        x: 0
        y: -1.5
        width: 12
        height: 3
        rotation: Qt.vector3d(90, 90, 0)
        grabsMouse: draggable
        onPressed: arrow.handlePressed(mouseAreaXZ, pointerPosition)
        onDragged: arrow.handleDragged(mouseAreaXZ, pointerPosition)
    }

}

