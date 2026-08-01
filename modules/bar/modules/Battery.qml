import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.UPower
import "../components"
import "../../../config"

MouseArea {
    id: batteryRoot
    hoverEnabled: true

    implicitWidth: row.implicitWidth
    implicitHeight: row.implicitHeight

    readonly property var device: UPower.displayDevice
    readonly property int percent: Math.round(device.percentage * 100)
    readonly property bool charging: device.state === UPowerDeviceState.Charging || device.state === UPowerDeviceState.FullyCharged

    // present only on laptops with a battery; Bar combines this with the
    // theme toggle to decide visibility
    readonly property bool available: device.isLaptopBattery && device.isPresent

    function batteryIcon() {
        if (percent >= 90)
            return "";
            // full
        else if (percent >= 65)
            return "";
            // three quarters
        else if (percent >= 40)
            return "";
            // half
        else if (percent >= 15)
            return "";
            // quarter
        else
            return "";                     // empty
    }

    function fmtTime(secs) {
        if (!secs || secs <= 0)
            return "";
        var h = Math.floor(secs / 3600);
        var m = Math.floor((secs % 3600) / 60);
        return h > 0 ? (h + "h " + m + "m") : (m + "m");
    }

    readonly property string tooltipText: {
        if (device.state === UPowerDeviceState.FullyCharged)
            return "Fully charged";
        if (charging) {
            var t = fmtTime(device.timeToFull);
            return t ? (t + " until full") : "Charging…";
        }
        var e = fmtTime(device.timeToEmpty);
        return e ? (e + " remaining") : "Calculating…";
    }

    RowLayout {
        id: row
        anchors.centerIn: parent
        spacing: 6

        Text {
            text: batteryRoot.batteryIcon()
            color: (batteryRoot.percent <= 15 && !batteryRoot.charging) ? Theme.colorPanic : BarTheme.colorFg
            font: Qt.font({
                family: Theme.iconFont,
                pixelSize: Theme.iconSize + 4
            })
        }
    }

    property bool hovered: batteryRoot.containsMouse || popupHover.hovered
    onHoveredChanged: {
        popup.visible = hovered;
    }

    PopupWindow {
        id: popup
        visible: false
        color: "transparent"

        implicitWidth: content.implicitWidth + 20
        implicitHeight: content.implicitHeight + 20

        anchor {
            item: batteryRoot
            rect.x: (batteryRoot.width - popup.implicitWidth) / 2
            rect.y: batteryRoot.height + 6
        }

        Rectangle {
            anchors.fill: parent
            radius: 8
            color: Qt.alpha(Theme.colorTooltip, Theme.tooltipOpacity)

            HoverHandler {
                id: popupHover
            }

            ColumnLayout {
                id: content
                anchors.centerIn: parent
                spacing: 4

                Text {
                    text: batteryRoot.percent + "%"
                    color: "#ffffff"
                    Layout.alignment: Qt.AlignHCenter
                    horizontalAlignment: Text.AlignHCenter
                    font: Theme.boldText
                }

                Text {
                    text: batteryRoot.tooltipText
                    color: "#ffffff"
                    Layout.alignment: Qt.AlignHCenter
                    horizontalAlignment: Text.AlignHCenter
                    font: Theme.text
                }
            }
        }
    }
}
