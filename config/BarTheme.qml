pragma Singleton

import Quickshell
import QtQuick

// Bar colors derived from Theme.barStyle.
// Referenced from Bar.qml and its submodules as BarTheme.colorFg, etc.
Singleton {
    id: root

    // Foreground (text/icons)
    property color colorFg: {
        switch (Theme.barStyle) {
        case "solid":
            return Theme.colorFg;
        case "transparent":
        default:
            return Theme.colorFg;
        }
    }

    // Foreground-on-fill (e.g. text sitting on a filled pill)
    property color colorBf: {
        switch (Theme.barStyle) {
        case "solid":
            return Theme.colorBg;
        case "transparent":
        default:
            return Theme.colorBg;
        }
    }

    // Bar background
    property color colorBg: {
        switch (Theme.barStyle) {
        case "solid":
            return Theme.colorBg;
        case "transparent":
        default:
            return Qt.alpha(Theme.colorFg, Theme.barOpacity);
        }
    }
}
