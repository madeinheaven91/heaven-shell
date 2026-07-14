import QtQuick
import QtQuick.Layouts
import "../components"

Rectangle {
	id: mprisRoot
	property var service
	property int charLimit: 30
	readonly property var player: service.activePlayer

	implicitWidth: inner.implicitWidth
	implicitHeight: bar.totalHeight - 4
	color: "transparent"
	visible: player !== null && inner.text !== ""

	function formatTime(seconds) {
		if (seconds === undefined || isNaN(seconds) || seconds < 0)
			return "0:00";
		var m = Math.floor(seconds / 60);
		var s = Math.floor(seconds % 60);
		return m + ":" + (s < 10 ? "0" : "") + s;
	}

	Text {
		id: inner
		anchors.verticalCenter: parent.verticalCenter
		font { family: root.fontFamily; pixelSize: root.fontSize }
		color: mprisRoot.player && mprisRoot.player.isPlaying ? root.colorFg : root.colorFgInactive
		text: {
			var t = service.fullText;
			if (t.length > mprisRoot.charLimit)
				t = t.substring(0, mprisRoot.charLimit) + "...";
			return t;
		}
	}

	MouseArea {
		id: hoverArea
		anchors.fill: parent
		hoverEnabled: true
		cursorShape: Qt.PointingHandCursor
		onClicked: if (mprisRoot.player) mprisRoot.player.togglePlaying()
	}

	// keep the popup open while hovering either the bar text or the popup,
	// with a grace period to move the mouse between them
	property bool hovered: hoverArea.containsMouse || popupHover.hovered
	onHoveredChanged: {
		if (hovered) {
			hideTimer.stop();
			popup.show = true;
		} else {
			hideTimer.restart();
		}
	}

	Timer {
		id: hideTimer
		interval: 300
		onTriggered: popup.show = false
	}

	// player.position only updates on seek; poke it while the popup is visible
	Timer {
		running: popup.show && mprisRoot.player !== null && mprisRoot.player.isPlaying
		interval: 1000
		repeat: true
		triggeredOnStart: true
		onTriggered: mprisRoot.player.positionChanged()
	}

	Tooltip {
		id: popup
		target: mprisRoot
		horizontalAlignment: "screen-left"
		fixedWidth: 400

		ColumnLayout {
			spacing: 4

			HoverHandler { id: popupHover }

			Text {
				Layout.alignment: Qt.AlignHCenter
				Layout.maximumWidth: popup.fixedWidth - 20
				elide: Text.ElideRight
				text: mprisRoot.player ? (mprisRoot.player.trackTitle || "Unknown") : ""
				color: root.colorFg
				font { family: root.fontFamily; pixelSize: root.fontSize - 2; bold: true }
			}

			Text {
				visible: text !== ""
				Layout.alignment: Qt.AlignHCenter
				Layout.maximumWidth: popup.fixedWidth - 20
				elide: Text.ElideRight
				text: mprisRoot.player ? (mprisRoot.player.trackArtist || "") : ""
				color: root.colorFgInactive
				font { family: root.fontFamily; pixelSize: root.fontSize - 4 }
			}

			Text {
				Layout.alignment: Qt.AlignHCenter
				text: mprisRoot.player
					? mprisRoot.formatTime(mprisRoot.player.position) + " / " + mprisRoot.formatTime(mprisRoot.player.length)
					: ""
				color: root.colorFg
				font { family: root.fontFamily; pixelSize: root.fontSize - 4 }
			}

			RowLayout {
				Layout.alignment: Qt.AlignHCenter
				spacing: 20

				Text {
					text: "󰒮"
					color: mprisRoot.player && mprisRoot.player.canGoPrevious ? root.colorFg : root.colorFgInactive
					font { family: root.fontFamily; pixelSize: root.fontSize }
					MouseArea {
						anchors.fill: parent
						cursorShape: Qt.PointingHandCursor
						onClicked: mprisRoot.player.previous()
					}
				}

				Text {
					text: mprisRoot.player && mprisRoot.player.isPlaying ? "󰏤" : "󰐊"
					color: root.colorFg
					font { family: root.fontFamily; pixelSize: root.fontSize }
					MouseArea {
						anchors.fill: parent
						cursorShape: Qt.PointingHandCursor
						onClicked: mprisRoot.player.togglePlaying()
					}
				}

				Text {
					text: "󰒭"
					color: mprisRoot.player && mprisRoot.player.canGoNext ? root.colorFg : root.colorFgInactive
					font { family: root.fontFamily; pixelSize: root.fontSize }
					MouseArea {
						anchors.fill: parent
						cursorShape: Qt.PointingHandCursor
						onClicked: mprisRoot.player.next()
					}
				}
			}
		}
	}
}
