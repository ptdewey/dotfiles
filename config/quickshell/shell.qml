//@ pragma UseQApplication
import QtQuick
import Quickshell
import Quickshell.Wayland
import "./niri/"
import "./river/"
import "./themes/"

ShellRoot {
    // Change themes here
    DarkEarth {
        id: theme
    }

    // Set to "niri" or "river"
    property string compositor: "niri"

    FontLoader {
        source: "file:///home/patrick/.local/share/fonts/custom/patricks-iosevka-patched/IosevkaPatrickNerdFont-Regular.ttf"
    }

    // Compositor IPC services - only the active one runs
    NiriService  { id: niriService;  enabled: compositor === "niri"  }
    RiverService { id: riverService; enabled: compositor === "river" }

    // One bar per screen
    Variants {
        model: Quickshell.screens

        Bar {
            required property var modelData
            screen: modelData
        }
    }

    // Transparent click-catcher shown when a tray menu is open.
    // Sits at the Overlay layer so it's above apps but below xdg_popups
    // xdg_popups parented to a Top-layer surface receive input above all
    // Top-layer surfaces, so the catcher at Top catches clicks outside the popup
    // without interfering with popup input.
    Variants {
        model: Quickshell.screens

        PanelWindow {
            required property var modelData
            screen: modelData
            visible: theme.menuOpen
            color: "transparent"
            exclusiveZone: -1
            anchors { top: true; left: true; right: true; bottom: true }
            WlrLayershell.layer: WlrLayer.Top
            WlrLayershell.keyboardFocus: WlrKeyboardFocus.None

            MouseArea {
                anchors.fill: parent
                acceptedButtons: Qt.AllButtons
                onClicked: theme.menuOpen = false
            }
        }
    }
}
