import QtQuick 2.0
import QtQuick3D 1.0
import QtQuick3D.Helpers 1.0
import QtQuick3D.Scripts 1.0

Node {
    id: worldScene
    property alias camera: camera1
    property alias landscape: landscape
    objectName: "worldRootNode"

    Camera {
        id: camera1
        objectName: "camera1"
        z: -600
        y: 200
    }

    ConeLight {
        id: ambient
        y: 400
        diffuseColor: Qt.rgba(0.4, 0.5, 0.0, 1.0)
        rotation: Qt.vector3d(60, 0, 0)
        brightness: 80
    }

    Lowpolylandscape {
        id: landscape
        objectName: "landscape"
        orientation: Node.LeftHanded

//        Gizmo {
//            id: gizmo
//            visible: false
//            ScaleToLookFixed.camera: camera1
//            ScaleToLookFixed.scale: Qt.vector3d(0.5, 0.5, 0.5)
//        }

        Model {
            source: "#Cone"
            y: 100
            scale: Qt.vector3d(0.5, 0.5, 0.5)
            materials: DefaultMaterial {
                diffuseColor: "gray"
                lighting: DefaultMaterial.NoLighting
            }
        }

        Model {
            id: someChildNode1
            objectName: "cone1"
            source: "#Cone"
            x: 0
            y: 100
            z: 0
            scale: Qt.vector3d(0.5, 0.5, 0.5)
            rotation: Qt.vector3d(0, 0, 30)
//            orientation: Node.RightHanded
            pivot: Qt.vector3d(0, 0, 50)
            materials: DefaultMaterial {
                diffuseColor: "red"
                lighting: DefaultMaterial.NoLighting
            }
            Model {
                id: someChildNode2
                objectName: "cone2"
                source: "#Cone"
                x: 250
                y: 200
                z: 100
//                rotation: Qt.vector3d(0, 0, 90)
//                scale: Qt.vector3d(1, 2, 1)
                pivot: Qt.vector3d(0, 0, 50)
//                orientation: Node.LeftHanded
                materials: DefaultMaterial {
                    diffuseColor: "green"
                    lighting: DefaultMaterial.NoLighting
                }
            }
        }

    }
    Component.onCompleted: targetNode = someChildNode2
}
