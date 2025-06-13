import Quickshell
import QtQuick
import QtQuick.Layouts
import Quickshell

import "root:/"
import "root:/config"
import "root:/components"

Rectangle {
    id: rightBar
    width: rowLayout.implicitWidth + 20
    height: rowLayout.implicitHeight
    radius: Appearance.rounding.normal
    color: "blue"

    Behavior on width {
        NumberAnimation {
            duration: 1000
            easing.type: Easing.InOutQuart
        }
    }

    RowLayout {
        id: rowLayout
        spacing: 4

        anchors {
            verticalCenter: parent.verticalCenter
            right: parent.right
            rightMargin: Appearance.margin.horizontal
        }

        Clock {}
        Clock {}
        Tray {}

        // Media { shouldUpdate: true }
        // Workspaces {}
    }
}
