pragma Singleton

import Quickshell
import QtQuick

Singleton {
    id: root

    readonly property Rounding rounding: Rounding{}
    readonly property Spacing spacing: Spacing{}
    readonly property Padding padding: Padding{}
    readonly property Margin margin: Margin{}
    readonly property Font font: Font{}
    // readonly property Anim anim: Anim{}

    component Rounding: QtObject {
        readonly property int normal: 10
    }


    component Spacing: QtObject {
        readonly property int normal: 11
    }

    component Padding: QtObject {
        readonly property int normal: 10
    }

    component Margin: QtObject {
        readonly property int vertical: 1
        readonly property int horizontal: 10
    }

    component FontFamily: QtObject {
        readonly property string mono: "IosevkaPatrick Nerd Font"
        readonly property string sans: "Adwaita Sans"
        readonly property string material: "Material Symbols Rounded"
    }

    component FontSize: QtObject {
        readonly property int small: 11
        readonly property int normal: 14
        readonly property int large: 18
    }

    component Font: QtObject {
        readonly property FontFamily family: FontFamily{}
        readonly property FontSize size: FontSize{}
    }

    // TODO: animations
}
