pragma Singleton

import Quickshell
import QtQuick

Singleton {
    readonly property bool expire: true
    readonly property int defaultExpireTimeout: 4000
    readonly property real clearThreshold: 0.3
    readonly property real expandThreshold: 0.3
    readonly property bool actionOnClick: false
    readonly property Sizes siezes: Sizes{}

    component Sizes: QtObject {
        readonly property int width: 400
        readonly property int height: 41
        readonly property int badge: 41
    }
}
