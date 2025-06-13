import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.Mpris

import "root:/"
import "root:/config"

Item {
    Layout.fillHeight: true
    Layout.fillWidth: true

    RowLayout {
        id: rowLayout
        spacing: 4
        anchors.centerIn: parent

        Rectangle {
            id: contentRect
            color: "green"
            radius: Appearance.rounding.normal

            // Let layout inside determine size
            implicitWidth: contentRowLayout.implicitWidth + 20
            implicitHeight: contentRowLayout.implicitHeight

            Behavior on implicitWidth {
                NumberAnimation {
                    duration: 1000
                    easing.type: Easing.InOutQuart
                }
            }

            RowLayout {
                id: contentRowLayout
                spacing: 4

                anchors {
                    fill: parent
                    leftMargin: Appearance.margin.horizontal
                    rightMargin: Appearance.margin.horizontal
                }

                Player {}
                Player {}
            }
        }
    }
}
