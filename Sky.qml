import QtQuick 2.0
import QtGraphicalEffects 1.0

RadialGradient {
    gradient: Gradient {
        GradientStop { position: 0.0; color: Qt.rgba(0.7, 0.7, 0.8, 1) }
        GradientStop { position: 0.5; color: Qt.rgba(0.5, 0.5, 0.5, 1) }
    }
}

