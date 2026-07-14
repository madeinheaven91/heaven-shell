import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.SystemTray

Rectangle {
	property var window

	RowLayout {
        anchors {
            verticalCenter: parent.verticalCenter
			right: parent.right
        }
		Repeater {
			model: SystemTray.items
			Image {
				width: 20
				height: 20
				sourceSize.width: width;
				sourceSize.height: height
				fillMode: Image.PreserveAspectFit
				source: modelData.icon
				MouseArea {
					anchors.fill: parent
					acceptedButtons: Qt.LeftButton | Qt.RightButton
					cursorShape: Qt.PointingHandCursor
					onClicked: mouse => {
						if (mouse.button === Qt.LeftButton) {
							modelData.activate()
						} else {
							// FIXME
							modelData.display(window, 0, 0)
						}
					}
				}
			}
		}
	}
}
