import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import "../components"
import "../../../config"

MouseArea {
    id: langRoot
    hoverEnabled: true

    implicitWidth: rect.implicitWidth
    implicitHeight: rect.implicitHeight

    property var layoutNames: []
    property int layoutIdx: 0
    property bool capsOn: false
    property string shortName: (layoutNames[layoutIdx] || "").substring(0, 2)

    Rectangle {
        id: rect
        color: Theme.colorFg
        radius: 4

        implicitWidth: row.implicitWidth + 8
        implicitHeight: row.implicitHeight + 4

        RowLayout {
            id: row
            anchors.centerIn: parent

            Text {
                id: text
                color: Theme.colorBg
                text: langRoot.shortName.toUpperCase()
                font: Qt.font({
                    pixelSize: Theme.textSize - 4,
                    family: Theme.textFont,
                    bold: true
                })
            }

            Text {
                visible: capsOn
                id: icon
                color: Theme.colorBg
                text: "\udb81\udec3"
                font: Qt.font({
                    pixelSize: Theme.textSize - 4,
                    family: Theme.iconFont,
                    bold: true
                })
            }
        }
    }

    // PopupWindow {
    //     id: popup
    //     visible: false
    //     color: "transparent"
    //
    //     implicitWidth: content.implicitWidth + 20
    //     implicitHeight: content.implicitHeight + 20
    //
    //     anchor {
    //         item: batteryRoot
    //         rect.x: (batteryRoot.width - popup.implicitWidth) / 2
    //         rect.y: batteryRoot.height + 6
    //     }
    //
    //
    //     Rectangle {
    //         anchors.fill: parent
    //         radius: 8
    //         color: Theme.colorTooltip
    //
    //         HoverHandler { id: popupHover }
    //
    //         ColumnLayout {
    //             id: content
    // anchors.centerIn: parent
    // spacing: 4
    //
    // Text {
    //                 text: batteryRoot.percent + "%"
    // 	color: "#ffffff"
    // 	Layout.alignment: Qt.AlignHCenter
    // 	horizontalAlignment: Text.AlignHCenter
    //                 font: Theme.boldText
    // }
    //
    // Text {
    //                 text: batteryRoot.tooltipText
    // 	color: "#ffffff"
    // 	Layout.alignment: Qt.AlignHCenter
    // 	horizontalAlignment: Text.AlignHCenter
    //                 font: Theme.text
    // }
    //         }
    //     }
    // }

    // emits the full layout list on start, then an event on every switch
    Process {
        id: layoutProc
        command: ["niri", "msg", "--json", "event-stream"]
        running: true

        stdout: SplitParser {
            onRead: line => {
                var ev = JSON.parse(line);
                if (ev.KeyboardLayoutsChanged) {
                    langRoot.layoutNames = ev.KeyboardLayoutsChanged.keyboard_layouts.names;
                    langRoot.layoutIdx = ev.KeyboardLayoutsChanged.keyboard_layouts.current_idx;
                } else if (ev.KeyboardLayoutSwitched) {
                    langRoot.layoutIdx = ev.KeyboardLayoutSwitched.idx;
                }
            }
        }
    }

    Process {
        id: getCaps
        command: ["sh", "-c", "cat /sys/class/leds/*capslock/brightness | head -n 1"]

        stdout: SplitParser {
            onRead: line => langRoot.capsOn = parseInt(line) > 0
        }
    }

    Timer {
        interval: 200
        running: true
        repeat: true
        onTriggered: getCaps.running = true
    }
}
