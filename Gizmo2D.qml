import QtQuick 2.0
import QtQuick3D 1.0

Item {
    id: root
    property Node targetNode
    property View3D targetView

    Connections {
        target: targetNode
        onGlobalPositionChanged: {
            var viewPos = targetView.mapFrom3DScene(targetNode.globalPosition)
            root.x = viewPos.x
            root.y = viewPos.y
        }
    }
}
