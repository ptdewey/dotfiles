import QtQuick

import "root:/config"
import "root:/widgets"

Text {
    text: Time.time
    color: "white"
    font.pointSize: Appearance.font.size.normal
    font.family: Appearance.font.family.mono
}
