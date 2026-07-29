import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io

Rectangle {
    id: langRoot
    implicitWidth: kbDisplay.implicitWidth
    implicitHeight: bar.totalHeight - 4
    color: "transparent"

    property var layoutNames: []
    property int layoutIdx: 0
    property bool capsOn: false
    property string shortName: (layoutNames[layoutIdx] || "").substring(0, 2)

    Text {
        id: kbDisplay
        anchors.verticalCenter: parent.verticalCenter
        text: langRoot.capsOn ? langRoot.shortName.toUpperCase() : langRoot.shortName.toLowerCase()
        color: root.colorFg
        font.family: root.fontFamily
        font.pixelSize: root.fontSize
    }

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
