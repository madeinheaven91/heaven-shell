import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.SystemTray
import Quickshell.Widgets
import "../components"

RowLayout {
    id: trayRow
    spacing: 8

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
                targetItem: hoverArea
                visible: hoverArea.containsMouse
                text: modelData.tooltipTitle !== "" ? modelData.tooltipTitle : modelData.title !== "" ? modelData.title : modelData.id
            }
        }
    }
}
