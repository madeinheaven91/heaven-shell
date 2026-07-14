import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.UPower

Rectangle {
    implicitWidth: powerDisplay.implicitWidth
    implicitHeight: bar.totalHeight - 4
	color: "transparent"

	// batteryIcon takes UPower.displayDevice.percentage
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

    Text {
        id: powerDisplay
        anchors {
            verticalCenter: parent.verticalCenter
        }
		text: (UPower.displayDevice.percentage * 100).toFixed() + "% " + batteryIcon(UPower.displayDevice.percentage)
        color: root.colorFg
        font.family: root.fontFamily
        font.pixelSize: root.fontSize
    }
}
