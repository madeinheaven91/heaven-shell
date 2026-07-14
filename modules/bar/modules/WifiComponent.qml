import QtQuick
import QtQuick.Layouts
import Quickshell

Rectangle {
	id: wifiRoot
    implicitWidth: inner.implicitWidth
    implicitHeight: bar.totalHeight - 4
	
	property var service
	color: "transparent"

	Text {
		id: inner
        anchors {
            verticalCenter: parent.verticalCenter
			right: parent.right
        }
		font { family: root.fontFamily; pixelSize: root.fontSize }
		text: (service.isEthernetConnected ? "󰈀" : "󰖩") + " " + service.connectedSSID
	}
}
