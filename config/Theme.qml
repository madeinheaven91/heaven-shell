pragma Singleton

import Quickshell
import QtQuick

Singleton {
    // Fonts
    property string textFont: "SF Pro Text"
    property int textSize: 16

    property string iconFont: "CodeNewRoman Nerd Font"
    property int iconSize: textSize
    property int bigIconSize: iconSize * 1.5

    // Colors
    property color colorBar: "#33000000"
    property color colorBg: "#fdf6e6"
    property color colorFg: "#000000"

    property font text: Qt.font({
        family: textFont,
        pixelSize: textSize,
        weight: 300
    })

    property font boldText: Qt.font({
        family: textFont,
        pixelSize: textSize,
        bold: true,
    })

    property font icon: Qt.font({
        family: iconFont,
        pixelSize: iconSize
    })
}
