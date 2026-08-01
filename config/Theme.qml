pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    id: root

    // Fonts
    property string textFont: "SF Pro Text"
    property int textSize: 16

    property string iconFont: "CodeNewRoman Nerd Font"
    property int iconSize: textSize
    property int bigIconSize: iconSize * 1.5

    // Colors — persisted to disk, aliased from the JSON adapter below
    property alias barOpacity: colors.barOpacity
    property alias colorBg: colors.colorBg
    property alias colorTooltip: colors.colorTooltip
    property alias tooltipOpacity: colors.tooltipOpacity
    property alias colorFg: colors.colorFg
    property alias colorPanic: colors.colorPanic

    FileView {
        path: `${Quickshell.configDir}/theme.json`
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
            id: colors
            property double barOpacity: 0.15
            property string colorBg: "#f6f6f6"
            property string colorTooltip: "#2b2b2b"
            property double tooltipOpacity: 0.9
            property string colorFg: "#000000"
            property string colorPanic: "#e0533d"
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
