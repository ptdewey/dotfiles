import QtQuick
import Quickshell

Item {
    implicitWidth: pill.implicitWidth
    implicitHeight: pill.implicitHeight

    SystemClock {
        id: clock
        precision: SystemClock.Seconds
    }

    Rectangle {
        id: pill
        implicitWidth: row.implicitWidth + 18
        implicitHeight: theme.pillHeight
        radius: height / 2
        color: theme.purple

        Text {
            id: row
            anchors.centerIn: parent
            text: Qt.formatDateTime(clock.date, "ddd MMM d, h:mm AP")
            color: theme.text
            font.family: theme.fontFamily
            font.pixelSize: theme.fontSize
            font.weight: Font.Medium
        }
    }
}
