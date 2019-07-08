import QtQuick 2.0
import QtDemon 1.0

DemonLight {
    id: light
    FixedScreenSizeNode {
        camera: camera1
        Gizmo {
            id: gizmo
            //            arrowX.visible: false
            //            arrowY.visible: false
            //            arrowZ.color: "yellow"
            //        FixedScreenSizeScript.enabled: true
            //        FixedScreenSizeScript.camera: camera1
            //        FixedScreenPositionScript.enabled: true
        }
    }
}

