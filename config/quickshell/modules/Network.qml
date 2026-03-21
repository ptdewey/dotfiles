import QtQuick
import Quickshell.Io

Item {
    id: root
    implicitWidth: pill.implicitWidth
    implicitHeight: pill.implicitHeight

    property string _type: ""
    property string _name: ""

    // Buffers to accumulate results before committing (avoids flicker)
    property string _pendingType: ""
    property string _pendingName: ""

    Process {
        id: _poll
        command: ["nmcli", "-t", "-f", "type,state,connection", "dev"]
        running: false

        stdout: SplitParser {
            splitMarker: "\n"
            onRead: function(line) {
                var parts = line.split(":")
                var type  = parts[0], state = parts[1], conn = parts[2] || ""
                if (state !== "connected") return
                // prefer wifi > ethernet
                if (type === "wifi") {
                    root._pendingType = "wifi"
                    root._pendingName = conn
                } else if (type === "ethernet" && root._pendingType !== "wifi") {
                    root._pendingType = "eth"
                    root._pendingName = conn
                }
            }
        }

        onExited: {
            root._type = root._pendingType
            root._name = root._pendingName
            _poll.running = false
        }
    }

    Timer {
        interval: 5000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: {
            root._pendingType = ""
            root._pendingName = ""
            _poll.running = true
        }
    }

    Rectangle {
        id: pill
        implicitWidth: label.implicitWidth + 18
        implicitHeight: theme.pillHeight
        radius: height / 2
        color: root._type ? theme.cyan : theme.urgent

        Text {
            id: label
            anchors.centerIn: parent
            text: {
                if (root._type === "wifi") return " " + root._name
                if (root._type === "eth")  return "󰈀 eth"
                return " Disconnected"
            }
            color: theme.text
            font.family: theme.fontFamily
            font.pixelSize: theme.fontSize
        }
    }
}
