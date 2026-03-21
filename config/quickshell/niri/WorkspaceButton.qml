import QtQuick

// A single workspace pill. Calls niriService.focusWorkspace(ws.id) on click.
Item {
    id: root

    // ws fields from niri: id, idx, name, output, is_active, is_focused, is_urgent, active_window_id
    property var ws: ({})

    readonly property bool hasWindows: ws.active_window_id !== null && ws.active_window_id !== undefined
    readonly property string label: (ws.name !== null && ws.name !== undefined) ? ws.name : String(ws.idx)

    implicitWidth: Math.max(pill.implicitWidth, theme.pillHeight)
    implicitHeight: theme.pillHeight

    Rectangle {
        id: pill
        anchors.centerIn: parent

        implicitWidth: label.length > 2 ? pillText.implicitWidth + 18 : theme.pillHeight
        implicitHeight: theme.pillHeight
        width: implicitWidth
        height: implicitHeight
        radius: height / 2

        // Active = this output is showing this workspace
        // Focused = keyboard focus is here (only one across all outputs)
        color: {
            if (ws.is_active && ws.is_focused) return theme.green
            if (ws.is_active)                  return Qt.darker(theme.accent, 1.8)
            if (root.hasWindows)               return theme.surface
            return "transparent"
        }

        border.color: {
            if (ws.is_focused && !ws.is_active)    return theme.purple
            if (ws.is_urgent)                       return theme.urgent
            if (!ws.is_active && !root.hasWindows)  return theme.border
            return "transparent"
        }
        border.width: 1.5

        Text {
            id: pillText
            anchors.centerIn: parent
            text: root.label
            color: {
                if (ws.is_active && ws.is_focused) return theme.textBright
                if (ws.is_active)                  return theme.textBright
                return theme.textDim
            }
            font.family: theme.fontFamily
            font.pixelSize: theme.fontSize - 2
            font.weight: Font.Medium
        }

        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            onClicked: niriService.focusWorkspace(ws.name !== null && ws.name !== undefined ? ws.name : String(ws.idx))
        }
    }
}
