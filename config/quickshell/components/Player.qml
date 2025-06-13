import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Services.Mpris

import "root:/config"

// TODO: replace with Mpris version
Text {
    id: root
    property string status

    text: status
    font.pointSize: Appearance.font.size.normal
    font.family: Appearance.font.family.mono

    Process {
        id: playerProc
        // command: ["playerctl", "status"]
        command: ["playerctl", "metadata", "xesam:title"]
        stdout: SplitParser {
            onRead: data => root.status = data
        }
    }

    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: playerProc.running = true
    }
}

