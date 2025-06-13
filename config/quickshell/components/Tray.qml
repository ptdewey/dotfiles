pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import Quickshell.Services.SystemTray
// import Qt5Compat.GraphicalEffects

import "root:/config"

Rectangle {
    visible: SystemTray.items.values.length
    width: SystemTray.items.values.length * 20 + 10
    Layout.fillHeight: true
    color: "gray"
    radius: 10

    Row {
        id: rowLayout
        anchors.centerIn: parent

        Repeater {
            model: SystemTray.items

            Rectangle {
                id: rect
                required property var modelData
                Layout.alignment: Qt.AlignHCenter
                height: 16
                width: 16
                color: "transparent"

                anchors {
                    leftMargin: 20
                }


                Image {
                    anchors.centerIn: parent
                    width: 15
                    height: 15
                    source: modelData.icon
                }

                MouseArea {
                    anchors.fill: parent

                    acceptedButtons: Qt.LeftButton | Qt.RightButton
                    implicitWidth: Appearance.font.size.small * 2
                    implicitHeight: Appearance.font.size.small * 2

                    onClicked: event => {
                        // if (event.button === Qt.LeftButton)
                            // modelData.activate();
                        if (modelData.hasMenu)
                            menu.open();
                    }

                    QsMenuAnchor {
                        id: menu
                        menu: rect.modelData.menu
                        anchor.window: this.QsWindow.window
                    }
                }
            }
        }
    }
}
