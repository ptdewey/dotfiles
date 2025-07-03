import Quickshell
import Quickshell.Io
import QtQuick

Item {
    property string accumulatedText: ""

    Text {
        id: niri_workspaces
        color: "white"
    }

    Timer {
        running: true
        interval: 1000
        repeat: true
        onTriggered: {
            accumulatedText = ""
            niri_state.running = false
            niri_state.running = true
        }
    }

    Process {
        id: niri_state
        command: ["node", "niri-state.mjs"]
        running: false
        stdout: SplitParser {
            // TODO: change output format of niri-state.js or parse the json
            onRead: (data) => {
                accumulatedText += data + " "
                niri_workspaces.text = accumulatedText.trim()
            }
        }
    }
}
