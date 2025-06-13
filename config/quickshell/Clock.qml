import QtQuick

import "./config"

Text {
    text: Time.time

    color: "white"
    // anchors.centerIn: parent
    font.pointSize: Appearance.font.size.normal
    font.family: Appearance.font.family.mono
}
