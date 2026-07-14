import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Services.UPower

Rectangle {
	property var service

    implicitWidth: inner.implicitWidth
    implicitHeight: bar.totalHeight - 4
	color: "transparent"

    Text {
		id: inner
        anchors {
            verticalCenter: parent.verticalCenter
        }
        color: root.colorFg
        font.family: root.fontFamily
        font.pixelSize: root.fontSize

		text: text()

		MouseArea {
			anchors.fill: parent
			acceptedButtons: Qt.LeftButton | Qt.RightButton
			cursorShape: Qt.PointingHandCursor
			onClicked: mouse => {
				if (mouse.button === Qt.LeftButton) {
					toggleMuteProcess.running = true;
				} else {
					pavucontrolProcess.running = true;
				}
			}
		}

		function text() {
			var icon = ""
			var volume = ""
			if (service.isMuted) {
				icon = "󰝟";
			} else {
				if (service.volume < 0.2) {
					icon = "󰕿";
				} else if (service.volume < 0.6) {
					icon = "󰖀";
				} else {
					icon = "󰕾";
				}
			}	
			return icon + " " + Number(service.volume * 100).toFixed(0) + "%";
		}

		Process {
			id: toggleMuteProcess
			command: ["wpctl", "set-mute", "@DEFAULT_AUDIO_SINK@", "toggle"]
			running: false
		}

		Process {
			id: pavucontrolProcess
			command: ["pavucontrol"]
			running: false
		}
    }
}
