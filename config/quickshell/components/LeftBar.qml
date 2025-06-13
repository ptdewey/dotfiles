import Quickshell
import QtQuick
import QtQuick.Layouts
import Quickshell

import "root:/"
import "root:/config"

Rectangle {
    id: leftBar

    width: rowLayout.implicitWidth + 20
    height: rowLayout.implicitHeight
    color: "red"
    radius: Appearance.rounding.normal

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
            left: parent.left
            leftMargin: Appearance.margin.horizontal
            rightMargin: Appearance.margin.horizontal
        }

        Clock {}
        // Workspaces {}
        // Media { shouldUpdate: true }
    }
}
