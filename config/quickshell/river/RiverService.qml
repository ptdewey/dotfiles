import QtQuick
import Quickshell.Io

// River tag service. Polls `riverctl list-views` to track occupied/focused tags.
// outputName is unused for now (River doesn't expose per-output focus via riverctl).
Item {
    id: root
    visible: false

    // Bitmasks: bit N set = tag (N+1) has that state
    property int focusedTags: 0
    property int occupiedTags: 0
    property int urgentTags: 0

    property bool enabled: true

    // How many tags to expose (default 9)
    property int tagCount: 9

    // Accumulation buffer for the polling process
    property string _buf: ""

    Timer {
        interval: 200
        running: root.enabled
        repeat: true
        onTriggered: {
            if (!_pollProc.running) {
                root._buf = ""
                _pollProc.running = true
            }
        }
    }

    Process {
        id: _pollProc
        command: ["riverctl", "list-views"]
        running: false

        stdout: SplitParser {
            splitMarker: "\n"
            onRead: function(line) {
                root._buf += line + "\n"
            }
        }

        onExited: function(code, status) {
            if (code !== 0) return
            root._parseViews(root._buf)
        }
    }

    function _parseViews(text) {
        var lines = text.split("\n")
        var occupied = 0
        var focused = 0
        var currentTags = 0

        for (var i = 0; i < lines.length; i++) {
            var line = lines[i].trim()

            var tagMatch = line.match(/^Tags:\s+(\d+)$/)
            if (tagMatch) {
                currentTags = parseInt(tagMatch[1])
                occupied |= currentTags
                continue
            }

            var focusMatch = line.match(/^Focused:\s+(yes|no)$/)
            if (focusMatch && focusMatch[1] === "yes") {
                focused = currentTags
            }
        }

        root.occupiedTags = occupied
        // Only update focused if we got a non-zero result (keep last known if no focused view)
        if (focused !== 0)
            root.focusedTags = focused
    }

    Process {
        id: _actionProc
        running: false
    }

    function focusTag(tagIndex) {
        if (_actionProc.running) return
        var mask = 1 << tagIndex
        _actionProc.command = ["riverctl", "set-focused-tags", String(mask)]
        _actionProc.running = true
    }
}
