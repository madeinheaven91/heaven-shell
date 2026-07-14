import QtQuick
import QtQuick.Layouts
import Quickshell
import "../components"

Rectangle {
	id: wifiRoot
    implicitWidth: inner.implicitWidth
    implicitHeight: bar.totalHeight - 4
	
	property var service
	property bool showSpeed: false
	color: "transparent"

	// newt named colors mapped to the bar palette via the terminal theme:
	// lightgray ~ colorBg, black ~ colorFg, gray ~ colorFgInactive
	readonly property string nmtuiColors: [
		"root=lightgray,black",
		"roottext=gray,black",
		"helpline=gray,black",
		"shadow=,black",
		"window=black,lightgray",
		"border=black,lightgray",
		"title=blue,lightgray",
		"label=black,lightgray",
		"textbox=black,lightgray",
		"acttextbox=lightgray,black",
		"listbox=black,lightgray",
		"actlistbox=lightgray,black",
		"sellistbox=black,lightgray",
		"actsellistbox=green,black",
		"checkbox=black,lightgray",
		"actcheckbox=lightgray,black",
		"button=lightgray,black",
		"actbutton=black,gray",
		"compactbutton=black,lightgray",
		"entry=black,gray",
		"disentry=gray,lightgray"
	].join(";")

	function formatSpeed(bytesPerSec) {
        let bitsPerSec = bytesPerSec * 8
		if (bitsPerSec < 1024)
			return bitsPerSec.toFixed(0) + " b/s"
		if (bitsPerSec < 1024 * 1024)
			return (bitsPerSec / 1024).toFixed(1) + " Kb/s"
		return (bitsPerSec / (1024 * 1024)).toFixed(1) + " Mb/s"
	}

    Rectangle {
        implicitWidth: inner.implicitWidth
        implicitHeight: bar.totalHeight - 4
        color: "transparent"

        Text {
            id: inner
            anchors {
                verticalCenter: parent.verticalCenter
                right: parent.right
            }

            font { family: root.fontFamily; pixelSize: root.fontSize }
            text: {
                var icon = service.isEthernetConnected ? "󰈀" : "󰖩"
                if (wifiRoot.showSpeed)
                    return icon + "  rx " + formatSpeed(service.downloadSpeed) + " tx " + formatSpeed(service.uploadSpeed)
                return icon + " " + (service.connectedSSID !== "" ? service.connectedSSID
                    : service.isEthernetConnected ? "Ethernet" : "not connected")
            }
        }

        MouseArea {
            id: hoverArea
            anchors.fill: parent
            hoverEnabled: true
            acceptedButtons: Qt.LeftButton | Qt.RightButton
            onClicked: mouse => {
                if (mouse.button === Qt.LeftButton)
                    wifiRoot.showSpeed = !wifiRoot.showSpeed
                else
                    Quickshell.execDetached(["sh", "-c",
                        "NEWT_COLORS='" + wifiRoot.nmtuiColors + "' alacritty --class qs-nmtui -e nmtui"])
            }

            Tooltip {
                target: hoverArea
                show: hoverArea.containsMouse
                horizontalAlignment: "center"
                text: {
                    var lines = []
                    if (service.connectedSSID !== "")
                        lines.push("Network: " + service.connectedSSID)
                    else if (service.isEthernetConnected)
                        lines.push("Network: Ethernet")
                    else
                        lines.push("Not connected")
                    if (service.ipAddress !== "")
                        lines.push("IP: " + service.ipAddress)
                    if (service.gateway !== "")
                        lines.push("Gateway: " + service.gateway)
                    return lines.join("\n")
                }
            }
        }
    }
}
