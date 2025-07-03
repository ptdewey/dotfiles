pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland

import "root:/components"

Scope {
    id: root

    Variants {
        model: Quickshell.screens

        PanelWindow {
            id: bar
            property var modelData
            screen: modelData
            implicitHeight: 30
            implicitWidth: 100
            color: "transparent"

            anchors {
                top: true
                left: true
                right: true
            }

            margins {
                top: 1
                left: 1
                right: 1
                bottom: 1
            }

            Behavior on width {
                NumberAnimation {
                    duration: 1000
                    easing.type: Easing.InOutQuart
                }
            }

            Rectangle {
                anchors.fill: parent
                radius: 5
                color: "transparent"

                Item {
                    id: barLayoutContainer
                    anchors.fill: parent

                    LeftBar{
                        anchors {
                            left: parent.left
                            verticalCenter: parent.verticalCenter
                            leftMargin: 3
                        }
                    }

                    RightBar{
                        anchors {
                            right: parent.right
                            verticalCenter: parent.verticalCenter
                            rightMargin: 3
                        }
                    }

                    // Align center bar to universal center
                    CenterBar{
                        anchors.centerIn: parent
                    }
                }
            }
        }
    }
}
