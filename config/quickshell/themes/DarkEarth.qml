import QtQuick

QtObject {
    // Backgrounds
    readonly property color bg:         "#24211E"
    readonly property color surface:    "#3B3330"
    readonly property color border:     "#6E665E"
    // Text
    readonly property color text:       "#D7C484"
    readonly property color textDim:    "#6B6461"
    readonly property color textBright: "#D7C484"
    // Accents
    readonly property color accent:     "#BB7844"
    readonly property color purple:     "#B3854D"
    readonly property color urgent:     "#B3664D"
    readonly property color green:      "#5F865F"
    readonly property color cyan:       "#669977"
    // Sizing
    readonly property real   fontSize:   17
    readonly property real   pillHeight: fontSize + 8
    readonly property string fontFamily: "Iosevka Patrick"
    // State
    property bool menuOpen: false
}
