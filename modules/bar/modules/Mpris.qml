import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Services.Mpris

Text {
	id: mprisRoot
	property var service
	property int charLimit: 30

	anchors {
		verticalCenter: parent.verticalCenter
	}
	font { family: root.fontFamily; pixelSize: root.fontSize }

	color: service.activePlayer.isPlaying ? root.colorFg : root.colorFgInactive
	text: calcText()

	MouseArea {
		anchors.fill: parent
		cursorShape: Qt.PointingHandCursor
		onClicked: mprisToggle.running = true
	}

	Process {
		id: mprisToggle
		command: ["playerctl", "play-pause"]
		running: false
	}

	function calcText() {
		if (service.activePlayer.isPlaying) {
			var text = service.artist + " — " + service.title;
			if (text.length > charLimit) {
                text = text.substring(0, charLimit) + "...";
			}	
			return text;
		} 	
	}	
}
