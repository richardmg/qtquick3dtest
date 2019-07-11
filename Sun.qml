import QtQuick 2.0
import QtQuick3D 1.0

Node {
    property int secondsPerOrbit: 100
    property real heightAboveGround: 200

    function rotationForHour(h)
    {
        // t == 12 => rotation == 0
        // t == 18 => rotation == -90
        var fraction = (h - 12) / 24
        return 360 * -fraction
    }

    Node {
        id: sunAndMoon
        property real earthRotation: 0
        rotation: Qt.vector3d(0, 0, earthRotation)

        Connections {
            target: clock
            onTimeChanged: {
                // Note: the sun will visually be one hour behind
                // the clock because of the animation...
                var prevTo = anim.to
                anim.to = rotationForHour(clock.time % 24)
                if (anim.to > prevTo)
                    sunAndMoon.earthRotation = prevTo + 360
                anim.restart()
            }
        }

        NumberAnimation {
            id: anim
            target: sunAndMoon
            property: "earthRotation"
            duration: clock.msPerHour
        }

        ConeLight {
            id: sun
            y: heightAboveGround
            diffuseColor: Qt.rgba(0.4, 0.5, 0.0, 1.0)
            brightness: 70
            rotation: Qt.vector3d(90, 0, 0)
        }

        ConeLight {
            id: moon
            y: -heightAboveGround
            diffuseColor: Qt.rgba(0.4, 0.4, 0.4, 1.0)
            brightness: 40
            rotation: Qt.vector3d(-90, 0, 0)
            //showGizmo: true
            //gizmoVisible: true
        }
    }

}
