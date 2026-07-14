import QtQuick
import Quickshell

PopupWindow {
    id: tooltip

    required property Item target
    property bool show: false
    property string text: ""
    property int gap: 4
    // fixed body width; 0 sizes to content
    property int fixedWidth: 0
    // "right", "center", "left" (relative to target)
    // "screen-right", "screen-center", "screen-left" (relative to screen)
    property string horizontalAlignment: "right"

    readonly property bool screenAligned: horizontalAlignment.startsWith("screen-")
    // children placed in the tooltip body, below the text (if any)
    default property alias content: contentColumn.data

    readonly property int horizontalAlignmentEdges: {
        if (horizontalAlignment === "left" || horizontalAlignment === "screen-left") return Edges.Bottom | Edges.Left
        if (horizontalAlignment === "center" || horizontalAlignment === "screen-center") return Edges.Bottom
        return Edges.Bottom | Edges.Right
    }

    // screen-* modes pin to a window edge, so the popup must expand inward;
    // item modes keep the expand-outward behavior
    readonly property int gravityEdges: {
        if (horizontalAlignment === "screen-left") return Edges.Bottom | Edges.Right
        if (horizontalAlignment === "screen-right") return Edges.Bottom | Edges.Left
        if (horizontalAlignment === "screen-center") return Edges.Bottom
        return horizontalAlignmentEdges | Edges.Bottom
    }

    visible: show
    anchor {
        item: tooltip.target
        edges: tooltip.horizontalAlignmentEdges
        gravity: tooltip.gravityEdges
    }
    implicitWidth: tooltipBox.width + tooltip.gap
    implicitHeight: tooltipBox.height + tooltip.gap
    color: "transparent"

    data: [
        // anchor rect spans the bar window's full height so the popup hangs
        // below the bar instead of the (vertically inset) widget; screen-*
        // modes also span the full width so edges pick a window edge
        Connections {
            target: tooltip.anchor
            function onAnchoring() {
                const pos = tooltip.target.mapToItem(null, 0, 0);
                tooltip.anchor.rect.x = tooltip.screenAligned ? -pos.x : 0;
                tooltip.anchor.rect.width = tooltip.screenAligned ? bar.width : tooltip.target.width;
                tooltip.anchor.rect.y = -pos.y;
                tooltip.anchor.rect.height = bar.height;
            }
        },
        Rectangle {
            id: tooltipBox
            y: tooltip.gap
            color: root.colorBg
            border.color: root.colorFg
            border.width: 2
            radius: root.borderRadius
            width: tooltip.fixedWidth > 0 ? tooltip.fixedWidth : contentColumn.implicitWidth + 16
            height: contentColumn.implicitHeight + 12

            Column {
                id: contentColumn
                anchors.centerIn: parent
                spacing: 6

                Text {
                    visible: tooltip.text !== ""
                    text: tooltip.text
                    color: root.colorFg
                    font.family: root.fontFamily
                    font.pixelSize: root.fontSize - 2
                }
            }
        }
    ]
}
