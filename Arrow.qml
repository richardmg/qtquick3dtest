import QtQuick 2.0
import QtQuick3D 1.0

Model {
    id: arrow
    rotationOrder: Node.XYZr
    orientation: Node.RightHanded
    source: "meshes/Arrow.mesh"

    property alias color: material.emissiveColor

    materials: DefaultMaterial {
        id: material
        emissiveColor: Qt.rgba(1.0, 0.0, 0.0, 1.0)
        lighting: DefaultMaterial.NoLighting
    }
}

