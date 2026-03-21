import QtQuick
import QtQuick.Layouts
import Quickshell.Io

Item {
    id: root

    property string title: ""
    property string artist: ""
    property string status: ""   // "Playing", "Paused", "Stopped"
    property bool hasPlayer: false

    visible: hasPlayer
    implicitWidth: visible ? pill.implicitWidth : 0
    implicitHeight: pill.implicitHeight

    // Follow mode: emits a line on every track/status change
    Process {
        id: watcher
        command: ["playerctl", "metadata", "-F", "--format", "{{status}}\t{{artist}}\t{{title}}"]
        running: true
        onExited: restartTimer.start()
        stdout: SplitParser {
            splitMarker: "\n"
            onRead: function(line) {
                var s = line.trim()
                if (s === "" || s.startsWith("No players")) {
                    root.hasPlayer = false
                    return
                }
                var parts = s.split("\t")
                if (parts.length < 3) { root.hasPlayer = false; return }
                root.status    = parts[0]
                root.artist    = parts[1]
                root.title     = parts[2]
                root.hasPlayer = true
            }
        }
    }

    // Restart watcher when playerctl exits (e.g. all players closed)
    Timer {
        id: restartTimer
        interval: 3000
        onTriggered: watcher.running = true
    }

    Rectangle {
        id: pill
        implicitWidth: row.implicitWidth + 18
        implicitHeight: theme.pillHeight
        radius: height / 2
        color: root.status === "Playing" ? theme.accent : theme.surface

        RowLayout {
            id: row
            anchors.centerIn: parent
            spacing: 5

            Text {
                text: root.status === "Playing" ? "▶" : "⏸"
                color: theme.text
                font.family: theme.fontFamily
                font.pixelSize: theme.fontSize - 3
            }

            Text {
                text: root.artist + " – " + root.title
                color: theme.text
                font.family: theme.fontFamily
                font.pixelSize: theme.fontSize
                elide: Text.ElideRight
                maximumLineCount: 1
                Layout.maximumWidth: 500
            }
        }
    }

    Process { id: playPauseProc; command: ["playerctl", "play-pause"]; running: false }
    Process { id: nextProc;      command: ["playerctl", "next"];       running: false }
    Process { id: prevProc;      command: ["playerctl", "previous"];   running: false }

    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton
        onClicked: function(mouse) {
            if (mouse.button === Qt.LeftButton)        playPauseProc.running = true
            else if (mouse.button === Qt.RightButton)  nextProc.running = true
            else if (mouse.button === Qt.MiddleButton) prevProc.running = true
        }
    }
}
