import QtQuick 2.0
import QtGraphicalEffects 1.0

RadialGradient {
    gradient: Gradient {
        GradientStop { position: 0.0; color: Qt.rgba(0.4, 0.4, 0.4, 1) }
        GradientStop { position: 0.5; color: Qt.rgba(0.1, 0.1, 0.2, 1) }
    }

    RadialGradient {
        id: daySky
        anchors.fill: parent
        visible: true
        gradient: Gradient {
            GradientStop { position: 0.0; color: "white" }
            GradientStop { position: 0.5; color: "lightblue" }
        }

        Connections {
            target: clock
            onTimeChanged: {
                var t = clock.time % 24
                if (t >= 3 && t <= 12)
                    anim.to = 1 - ((12 - t) / 9)
                else if (t >= 12 && t <= 21)
                    anim.to = 1 - ((t - 12) / 9)
                else
                    anim.to = 0
                anim.restart()
            }
        }

        NumberAnimation {
            id: anim
            target: daySky
            property: "opacity"
            duration: clock.msPerHour
        }

    }
}

