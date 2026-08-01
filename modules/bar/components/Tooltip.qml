import QtQuick
import Quickshell
import "../../../config"

PopupWindow {
    id: tooltip

    property Item targetItem
    property string text: ""

    anchor {
        item: tooltip.targetItem
        rect.x: tooltip.targetItem
                ? (tooltip.targetItem.width - tooltip.implicitWidth) / 2 : 0
        rect.y: tooltip.targetItem ? tooltip.targetItem.height + 8 : 0
    }

    implicitWidth: label.implicitWidth + 20
    implicitHeight: label.implicitHeight + 12
    color: "transparent"

    Rectangle {
        anchors.fill: parent
        radius: 8
        color: Qt.alpha(Theme.colorTooltip, Theme.tooltipOpacity)

        Text {
            id: label
            anchors.centerIn: parent
            text: tooltip.text
            color: Theme.colorBg
            font: Theme.text
        }
    }
}
