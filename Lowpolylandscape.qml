import QtDemon 1.0
import QtQuick 2.12

DemonNode {
    id: rootNode
    rotationOrder: DemonNode.XYZr
    orientation: DemonNode.RightHanded
    DemonModel {
        id: plane
        x: 1.6019463539123535
        y: -5.477954387664795
        z: -0.8363485336303711
        rotation: Qt.vector3d(-90, 0, 0)
        scale: Qt.vector3d(471.317, 471.317, 471.317)
        rotationOrder: DemonNode.XYZr
        orientation: DemonNode.RightHanded
        source: "meshes/Plane.mesh"
        DemonDefaultMaterial {
            id: defaultMaterial_material
//            diffuseColor: Qt.rgba(0.4, 0.5, 0.0, 1)
            diffuseColor: Qt.rgba(0.9, 0.9, 0.9, 1)
        }
        materials: [
            defaultMaterial_material
        ]
    }
}
