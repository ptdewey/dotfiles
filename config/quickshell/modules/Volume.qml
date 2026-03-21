import QtQuick
import Quickshell.Io

Item {
    id: root
    implicitWidth: pill.implicitWidth
    implicitHeight: pill.implicitHeight

    property real _volume: 0
    property bool _muted: false

    Process {
        id: _getProc
        running: false
        command: ["wpctl", "get-volume", "@DEFAULT_AUDIO_SINK@"]
        stdout: SplitParser {
            splitMarker: "\n"
            onRead: function(line) {
                // "Volume: 0.49" or "Volume: 0.49 [MUTED]"
                var m = line.match(/Volume:\s*([\d.]+)(\s+\[MUTED\])?/)
                if (m) {
                    root._volume = parseFloat(m[1])
                    root._muted  = m[2] !== undefined
                }
            }
        }
    }

    Timer {
        interval: 1500
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: if (!_getProc.running) _getProc.running = true
    }

    Rectangle {
        id: pill
        implicitWidth: volText.implicitWidth + 18
        implicitHeight: theme.pillHeight
        radius: height / 2
        color: root._muted ? theme.urgent : theme.accent

        Text {
            id: volText
            anchors.centerIn: parent
            text: root._muted ? "\uf026 MUTED" : " " + Math.round(root._volume * 100) + "%"
            color: theme.text
            font.family: theme.fontFamily
            font.pixelSize: theme.fontSize
        }
    }

    Process { id: _muteProc; running: false; onExited: _getProc.running = true }
    Process { id: _volProc;  running: false; onExited: _getProc.running = true }

    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton
        onClicked: {
            _muteProc.command = ["wpctl", "set-mute", "@DEFAULT_AUDIO_SINK@", "toggle"]
            _muteProc.running = true
        }
        onWheel: function(wheel) {
            var dir = wheel.angleDelta.y > 0 ? "1%+" : "1%-"
            _volProc.command = ["wpctl", "set-volume", "-l", "1.5", "@DEFAULT_AUDIO_SINK@", dir]
            _volProc.running = true
        }
    }
}
