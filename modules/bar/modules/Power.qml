import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.UPower
import "../components"

Rectangle {
    implicitWidth: powerDisplay.implicitWidth
    implicitHeight: bar.totalHeight - 4
    color: "transparent"

    function batteryIcon(value) {
        let result = "";
        if (value < 0.2) {
            result = "";
        } else if (value < 0.4) {
            result = "";
        } else if (value < 0.6) {
            result = "";
        } else if (value < 0.8) {
            result = "";
        } else {
            result = "";
        }
        return result
    }
    function formatTime(seconds) {
        if (seconds <= 0) return "calculating..."
        var h = Math.floor(seconds / 3600)
        var m = Math.floor((seconds % 3600) / 60)
        if (h > 0) return h + "h " + m + "m"
        return m + "m"
    }

    Text {
        id: powerDisplay
        anchors.verticalCenter: parent.verticalCenter
        text: (UPower.displayDevice.percentage * 100).toFixed() + "% " + batteryIcon(UPower.displayDevice.percentage)
        color: root.colorFg
        font.family: root.fontFamily
        font.pixelSize: root.fontSize
    }

    MouseArea {
        id: hoverArea
        anchors.fill: parent
        hoverEnabled: true

        Tooltip {
            target: hoverArea
            show: hoverArea.containsMouse
            text: {
                var dev = UPower.displayDevice
                var lines = []
                if (dev.state === UPowerDeviceState.Charging) {
                    lines.push("Charging")
                    lines.push("Time to full: " + formatTime(dev.timeToFull))
                } else if (dev.state === UPowerDeviceState.Discharging) {
                    lines.push("Discharging")
                    lines.push("Time remaining: " + formatTime(dev.timeToEmpty))
                } else if (dev.state === UPowerDeviceState.FullyCharged) {
                    lines.push("Fully charged")
                } else {
                    lines.push("Status unknown")
                }
                return lines.join("\n")
            }
        }
    }
}
