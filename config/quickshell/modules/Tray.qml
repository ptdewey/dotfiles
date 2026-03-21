import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.SystemTray
import Quickshell.Widgets

Item {
    id: root
    implicitWidth: pill.implicitWidth
    implicitHeight: pill.implicitHeight

    Rectangle {
        id: pill
        implicitWidth: row.implicitWidth + 12
        implicitHeight: theme.pillHeight
        radius: height / 2
        color: theme.surface

        RowLayout {
            id: row
            anchors.centerIn: parent
            spacing: 4

            Repeater {
                model: SystemTray.items

                delegate: Item {
                    id: trayDelegate
                    required property SystemTrayItem modelData

                    // 0 = Passive; also hide empty icons and Spotify (broken SNI implementation)
                    visible: modelData.status !== 0 && modelData.icon !== ""
                             && !modelData.id.toLowerCase().includes("spotify")
                    implicitWidth: visible ? theme.fontSize + 2 : 0
                    implicitHeight: theme.fontSize + 2
                    Layout.alignment: Qt.AlignVCenter

                    IconImage {
                        source: trayDelegate.modelData.icon
                        anchors.centerIn: parent
                        width: theme.fontSize
                        height: theme.fontSize
                    }

                    // Themed menu popup
                    PopupWindow {
                        id: menuPopup
                        visible: false
                        color: "transparent"

                        Connections {
                            target: theme
                            function onMenuOpenChanged() {
                                if (!theme.menuOpen) menuPopup.visible = false
                            }
                        }

                        anchor.window: bar
                        anchor.item: trayDelegate
                        anchor.edges: Edges.Bottom
                        anchor.gravity: Edges.Bottom
                        anchor.margins.top: 4

                        implicitWidth: menuBg.width
                        implicitHeight: menuBg.height

                        Rectangle {
                            id: menuBg
                            width: 200
                            height: menuCol.implicitHeight + 12
                            color: theme.bg
                            border.color: theme.border
                            border.width: 1
                            radius: 6

                            Column {
                                id: menuCol
                                anchors { top: parent.top; topMargin: 6; left: parent.left; leftMargin: 4; right: parent.right; rightMargin: 4 }
                                spacing: 1

                                Repeater {
                                    model: menuOpener.children

                                    delegate: Item {
                                        id: menuItem
                                        required property var modelData
                                        width: menuCol.width
                                        height: modelData.isSeparator ? 9 : 26

                                        // Separator line
                                        Rectangle {
                                            visible: menuItem.modelData.isSeparator
                                            anchors.centerIn: parent
                                            width: parent.width - 8
                                            height: 1
                                            color: theme.border
                                        }

                                        // Clickable row
                                        Rectangle {
                                            visible: !menuItem.modelData.isSeparator
                                            anchors.fill: parent
                                            color: rowHover.containsMouse && menuItem.modelData.enabled
                                                   ? theme.surface : "transparent"
                                            radius: 4

                                            Text {
                                                anchors { left: parent.left; leftMargin: 10; verticalCenter: parent.verticalCenter }
                                                text: menuItem.modelData.text
                                                color: menuItem.modelData.enabled ? theme.text : theme.textDim
                                                font.family: theme.fontFamily
                                                font.pixelSize: theme.fontSize
                                            }
                                        }

                                        MouseArea {
                                            id: rowHover
                                            anchors.fill: parent
                                            hoverEnabled: true
                                            cursorShape: Qt.PointingHandCursor
                                            enabled: menuItem.modelData.enabled && !menuItem.modelData.isSeparator
                                            onClicked: {
                                                menuItem.modelData.triggered()
                                                menuPopup.visible = false
                                                theme.menuOpen = false
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }

                    QsMenuOpener {
                        id: menuOpener
                        menu: trayDelegate.modelData.menu
                    }

                    MouseArea {
                        anchors.fill: parent
                        acceptedButtons: Qt.LeftButton | Qt.RightButton
                        onClicked: function(mouse) {
                            if (mouse.button === Qt.RightButton || trayDelegate.modelData.onlyMenu) {
                                var opening = !menuPopup.visible
                                menuPopup.visible = opening
                                theme.menuOpen = opening
                            } else {
                                trayDelegate.modelData.activate()
                            }
                        }
                    }
                }
            }
        }
    }
}
