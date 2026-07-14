import QtQuick
import QtQuick.Layouts
import Quickshell

Rectangle {
	id: workspaceLayout
    implicitWidth: innerRow.implicitWidth
    implicitHeight: bar.totalHeight - 4
	color: root.colorBg

	RowLayout {
		id: innerRow
		spacing: 10
        anchors {
            verticalCenter: parent.verticalCenter
			centerIn: parent
        }

		Repeater {
			model: niri.workspaces

			Text {
				property var ws: niri.workspaces.values.find(w => w.id === index)
				property bool isActive: model.isActive
				text: index
				color: isActive ? root.colorFg : root.colorFgInactive
				font { 
					family: root.fontFamily
					pixelSize: root.fontSize
				}

				MouseArea {
					anchors.fill: parent
		            cursorShape: Qt.PointingHandCursor
		            onClicked: niri.focusWorkspaceById(model.id)
				}
			}
		}
	}
}
