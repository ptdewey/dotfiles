import QtQuick

// A single tag pill for River. Calls riverService.focusTag(tagIndex) on click.
Item {
    id: root

    property int tagIndex: 0      // 0-based tag index
    property bool focused: false  // tag is currently focused/visible
    property bool occupied: false // tag has at least one window
    property bool urgent: false   // tag has an urgent window

    readonly property string label: String(tagIndex + 1)

    implicitWidth: Math.max(pill.implicitWidth, theme.pillHeight)
    implicitHeight: theme.pillHeight

    Rectangle {
        id: pill
        anchors.centerIn: parent

        implicitWidth: theme.pillHeight
        implicitHeight: theme.pillHeight
        width: implicitWidth
        height: implicitHeight
        radius: height / 2

        color: {
            if (focused && occupied) return theme.green
            if (focused)             return Qt.darker(theme.accent, 1.8)
            if (occupied)            return theme.surface
            return "transparent"
        }

        border.color: {
            if (urgent)                      return theme.urgent
            if (!occupied && !focused)       return theme.border
            return "transparent"
        }
        border.width: 1.5

        Text {
            anchors.centerIn: parent
            text: root.label
            color: focused ? theme.textBright : theme.textDim
            font.family: theme.fontFamily
            font.pixelSize: theme.fontSize - 2
            font.weight: Font.Medium
        }

        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            onClicked: riverService.focusTag(root.tagIndex)
        }
    }
}
