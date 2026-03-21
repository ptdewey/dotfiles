import QtQuick
import QtQuick.Layouts

// Tag switcher for River.
// Reads from the riverService context object (set in shell.qml).
// Shows tags 1–tagCount, highlighting occupied and focused tags.
Item {
    id: root

    property string outputName: ""  // reserved for future per-output support

    implicitWidth: row.implicitWidth
    implicitHeight: row.implicitHeight

    RowLayout {
        id: row
        anchors.fill: parent
        spacing: 4

        Repeater {
            model: riverService.tagCount

            delegate: TagButton {
                required property int index
                tagIndex: index
                focused:  (riverService.focusedTags  & (1 << index)) !== 0
                occupied: (riverService.occupiedTags & (1 << index)) !== 0
                urgent:   (riverService.urgentTags   & (1 << index)) !== 0
            }
        }
    }
}
