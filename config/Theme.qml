pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    id: root

    // Fonts
    property string textFont: theme.textFont
    property int textSize: 16

    property string iconFont: theme.iconFont
    property int iconSize: textSize
    property int bigIconSize: iconSize * 1.5

    // Theme
    property alias colorBg: theme.colorBg
    property alias colorFg: theme.colorFg
    property alias colorPanic: theme.colorPanic

    property alias colorTooltip: theme.colorTooltip
    property alias tooltipOpacity: theme.tooltipOpacity
    property string tooltipAlpha: Qt.alpha(colorTooltip, tooltipOpacity)

    property alias barStyle: theme.barStyle
    property alias barOpacity: theme.barOpacity
    property alias barShadow: theme.barShadow

    // Modules
    property alias workspacesModuleEnabled: theme.workspacesModuleEnabled
    property alias mprisModuleEnabled: theme.mprisModuleEnabled
    property alias trayModuleEnabled: theme.trayModuleEnabled
    property alias langModuleEnabled: theme.langModuleEnabled
    property alias batteryModuleEnabled: theme.batteryModuleEnabled
    property alias wifiModuleEnabled: theme.wifiModuleEnabled
    property alias volumeModuleEnabled: theme.volumeModuleEnabled

    FileView {
        path: `${Quickshell.shellDir}/theme.json`
        watchChanges: true
        onFileChanged: reload()
        onAdapterUpdated: writeAdapter()
        // warn (and keep the previous colors) if the file isn't valid JSON
        onLoaded: {
            try {
                JSON.parse(text());
            } catch (e) {
                console.warn(`Theme: ${path} contains invalid JSON, keeping previous colors — ${e}`);
            }
        }
        onLoadFailed: error => {
            // create the file with defaults the first time it's missing
            if (error === FileViewError.FileNotFound)
                writeAdapter();
            else
                console.warn(`Theme: failed to load ${path} — ${FileViewError.toString(error)}`);
        }

        JsonAdapter {
            id: theme

            property string colorBg: "#f6f6f6"
            property string colorFg: "#000000"
            property string colorPanic: "#e0533d"

            property string textFont: "SF Pro Text"
            property string iconFont: "CodeNewRoman Nerd Font"

            property string colorTooltip: "#2b2b2b"
            property double tooltipOpacity: 0.8

            // "transparent" | "solid"
            property string barStyle: "transparent"
            property double barOpacity: 0.10
            property bool barShadow: true

            // modules
            property bool workspacesModuleEnabled: true
            property bool mprisModuleEnabled: true
            property bool trayModuleEnabled: true
            property bool langModuleEnabled: true
            property bool batteryModuleEnabled: true
            property bool wifiModuleEnabled: true
            property bool volumeModuleEnabled: true
        }
    }

    property font text: Qt.font({
        family: textFont,
        pixelSize: textSize,
        weight: 300
    })

    property font boldText: Qt.font({
        family: textFont,
        pixelSize: textSize,
        bold: true
    })

    property font icon: Qt.font({
        family: iconFont,
        pixelSize: iconSize
    })
}
