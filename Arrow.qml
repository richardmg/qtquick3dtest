import QtQuick 2.0
import QtDemon 1.0

DemonModel {
    id: arrow
    scale: Qt.vector3d(10, 10, 10)
    rotationOrder: DemonNode.XYZr
    orientation: DemonNode.RightHanded
    source: "meshes/Arrow.mesh"
    DemonDefaultMaterial {
        id: defaultMaterial_material
        emissiveColor: Qt.rgba(1.0, 0.0, 0.0, 1.0)
        lighting: DemonDefaultMaterial.NoLighting
    }
    materials: [
        defaultMaterial_material
    ]
}

