import QtQuick
import QtQuick.Layouts

// Workspace switcher for niri.
// Reads from the niriService context object (set in shell.qml).
// outputName must match niri's output name (e.g. "DP-1").
Item {
    id: root

    property string outputName: ""

    // Reactively recomputes whenever niriService.workspaces changes
    property var _workspaces: {
        var all = niriService.workspaces
        return all
            .filter(function(ws) { return ws.output === root.outputName })
            .sort(function(a, b) { return a.idx - b.idx })
    }

    implicitWidth: row.implicitWidth
    implicitHeight: row.implicitHeight

    RowLayout {
        id: row
        anchors.fill: parent
        spacing: 4

        Repeater {
            model: root._workspaces

            delegate: WorkspaceButton {
                required property var modelData
                ws: modelData
            }
        }
    }
}
