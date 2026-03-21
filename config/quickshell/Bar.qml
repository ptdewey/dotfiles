import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import "./niri/"
import "./river/"
import "./modules/"

PanelWindow {
    id: bar

    anchors { top: true; left: true; right: true }
    implicitHeight: theme.pillHeight + 10
    color: "transparent"

    Rectangle {
        anchors.fill: parent
        color: theme.bg

        // Left – workspace switcher (compositor-aware)
        Loader {
            anchors { left: parent.left; leftMargin: 10; verticalCenter: parent.verticalCenter }
            sourceComponent: compositor === "river" ? _riverWs : _niriWs
        }

        Component {
            id: _niriWs
            NiriWorkspaces { outputName: bar.screen.name }
        }

        Component {
            id: _riverWs
            RiverWorkspaces { outputName: bar.screen.name }
        }

        // Center (centered regardless of left/right widths)
        MediaPlayer {
            anchors.centerIn: parent
        }

        // Right
        RowLayout {
            anchors { right: parent.right; rightMargin: 10; verticalCenter: parent.verticalCenter }
            spacing: 6

            Volume  { Layout.alignment: Qt.AlignVCenter }
            Network { Layout.alignment: Qt.AlignVCenter }
            Clock   { Layout.alignment: Qt.AlignVCenter }
            Tray    { Layout.alignment: Qt.AlignVCenter }
        }
    }
}
