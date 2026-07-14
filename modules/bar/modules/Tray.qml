import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.SystemTray
import Quickshell.Widgets
import "../components"

Rectangle {
	property var window

	implicitWidth: trayRow.implicitWidth
	implicitHeight: bar.totalHeight - 4
	color: "transparent"

	RowLayout {
		id: trayRow
        anchors {
            verticalCenter: parent.verticalCenter
			right: parent.right
        }

		Repeater {
			model: SystemTray.items

			MouseArea {
				id: hoverArea
				implicitWidth: 20
				implicitHeight: 20
				acceptedButtons: Qt.LeftButton | Qt.RightButton
				cursorShape: Qt.PointingHandCursor
				hoverEnabled: true
				onClicked: event => {
					if (event.button === Qt.LeftButton) {
						modelData.activate();
					} else if (modelData.hasMenu) {
						menuAnchor.open();
					} else {
						modelData.secondaryActivate();
					}
				}

				IconImage {
					anchors.fill: parent
					source: modelData.icon
				}

				QsMenuAnchor {
					id: menuAnchor
					menu: modelData.menu
					anchor.item: hoverArea
					anchor.edges: Edges.Bottom
					anchor.gravity: Edges.Bottom
				}

				Tooltip {
					target: hoverArea
					show: hoverArea.containsMouse
					horizontalAlignment: "center"
					text: modelData.tooltipTitle !== "" ? modelData.tooltipTitle
						: modelData.title !== "" ? modelData.title
						: modelData.id
				}
			}
		}
	}
}
