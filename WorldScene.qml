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
//        Gizmo {
//            id: gizmo
//            visible: false
//            ScaleToLookFixed.camera: camera1
//            ScaleToLookFixed.scale: Qt.vector3d(0.5, 0.5, 0.5)
//        }

        Model {
            id: someChildNode1
            objectName: "child1"
            source: "#Cone"
            x: 100
            y: 100
            z: 100
            scale: Qt.vector3d(0.3, 0.3, 0.3)
            rotation: Qt.vector3d(0, 0, 45)
            materials: DefaultMaterial {
                diffuseColor: "red"
                lighting: DefaultMaterial.NoLighting
            }
            Model {
                id: someChildNode2
                objectName: "child2"
                source: "#Cone"
                x: 150
                y: 100
                z: 100
                rotation: Qt.vector3d(0, 0, 90)
                materials: DefaultMaterial {
                    diffuseColor: "green"
                    lighting: DefaultMaterial.NoLighting
                }
            }
        }

    }
    Component.onCompleted: targetNode = someChildNode2
}
