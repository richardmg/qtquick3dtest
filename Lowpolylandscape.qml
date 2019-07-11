import QtQuick3D 1.0
import QtQuick 2.12

Node {
    id: rootNode
    rotationOrder: Node.XYZr
    orientation: Node.RightHanded
    Model {
        id: plane
        x: 1.6019463539123535
        y: -5.477954387664795
        z: -0.8363485336303711
        rotation: Qt.vector3d(-90, 0, 0)
        scale: Qt.vector3d(471.317, 471.317, 471.317)
        rotationOrder: Node.XYZr
        orientation: Node.RightHanded
        source: "meshes/Plane.mesh"
        DefaultMaterial {
            id: defaultMaterial_material
//            diffuseColor: Qt.rgba(0.4, 0.5, 0.0, 1)
            diffuseColor: Qt.rgba(0.9, 0.9, 0.9, 1)
        }
        materials: [
            defaultMaterial_material
        ]
    }
}
