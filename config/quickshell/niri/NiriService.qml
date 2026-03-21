import QtQuick
import Quickshell.Io

Item {
    id: root
    visible: false

    property bool enabled: true
    property var workspaces: []

    // Long-running event stream
    Process {
        command: ["stdbuf", "-oL", "niri", "msg", "-j", "event-stream"]
        running: root.enabled

        stdout: SplitParser {
            splitMarker: "\n"
            onRead: function(line) {
                var s = line.trim()
                if (!s) return
                try {
                    var ev = JSON.parse(s)
                    if (ev.WorkspacesChanged) {
                        root.workspaces = ev.WorkspacesChanged.workspaces
                    } else if (ev.WorkspaceActivated) {
                        var activatedId = ev.WorkspaceActivated.id
                        var isFocused   = ev.WorkspaceActivated.focused
                        var targetOutput = ""
                        for (var i = 0; i < root.workspaces.length; i++) {
                            if (root.workspaces[i].id === activatedId) {
                                targetOutput = root.workspaces[i].output
                                break
                            }
                        }
                        root.workspaces = root.workspaces.map(function(ws) {
                            var w = Object.assign({}, ws)
                            if (w.output === targetOutput)
                                w.is_active = (w.id === activatedId)
                            if (isFocused)
                                w.is_focused = (w.id === activatedId)
                            return w
                        })
                    }
                } catch(e) {
                    console.warn("[NiriService] parse error:", s)
                }
            }
        }

        onExited: function(code, status) {
            console.warn("[NiriService] event-stream exited (code " + code + ")")
        }
    }

    Process {
        id: _actionProc
        running: false
    }

    function focusWorkspace(reference) {
        if (_actionProc.running) return
        _actionProc.command = ["niri", "msg", "action", "focus-workspace", reference]
        _actionProc.running = true
    }

    function workspacesForOutput(outputName) {
        return root.workspaces
            .filter(function(ws) { return ws.output === outputName })
            .sort(function(a, b) { return a.idx - b.idx })
    }
}
