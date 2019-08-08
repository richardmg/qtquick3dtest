import QtQuick 2.0
import QtGraphicalEffects 1.0

RadialGradient {
    gradient: Gradient {
        GradientStop { position: 0.0; color: Qt.rgba(0.4, 0.4, 0.4, 1) }
        GradientStop { position: 0.5; color: Qt.rgba(0.1, 0.1, 0.2, 1) }
    }
}

