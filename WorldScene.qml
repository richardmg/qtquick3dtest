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

        Model {
            id: someChildNode1
            objectName: "cone1"
            source: "#Cone"
            x: 0
            y: 100
            z: 0
            scale: Qt.vector3d(0.5, 0.5, 0.5)
//            rotation: Qt.vector3d(0, 0, 30)
//            orientation: Node.RightHanded
            materials: DefaultMaterial {
                diffuseColor: "red"
                lighting: DefaultMaterial.NoLighting
            }

            SequentialAnimation on rotation {
                loops: Animation.Infinite
                PropertyAnimation { duration: 5000; to: Qt.vector3d(0, 360, 0); from: Qt.vector3d(0, 0, 0) }
            }

            Model {
                id: someChildNode2
                objectName: "cone2"
                source: "#Cone"
                x: 150
                y: 150
                z: 100
                scale: Qt.vector3d(0.5, 0.5, 0.5)
                materials: DefaultMaterial {
                    diffuseColor: "green"
                    lighting: DefaultMaterial.NoLighting
                }

                SequentialAnimation on rotation {
                    loops: Animation.Infinite
                    PropertyAnimation { duration: 5000; to: Qt.vector3d(360, 0, 0); from: Qt.vector3d(0, 0, 0) }
                }
            }
        }

    }
    Component.onCompleted: targetNode = someChildNode2
}
