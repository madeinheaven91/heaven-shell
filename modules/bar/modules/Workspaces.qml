import QtQuick
import QtQuick.Layouts
import Niri
import "../../../config"

RowLayout {
    id: workspacesRoot
    spacing: 6

    Niri {
        id: niri
        Component.onCompleted: connect()
    }

    Repeater {
        model: niri.workspaces

        delegate: Rectangle {
            id: ws
            required property var model

            implicitWidth: model.isFocused ? 22 : 8
            implicitHeight: 8
            radius: height / 2
            color: model.isFocused
                   ? Theme.colorFg
                   : (model.isActive ? Qt.alpha(Theme.colorFg, 0.55)
                                     : Qt.alpha(Theme.colorFg, 0.25))

            Behavior on implicitWidth {
                NumberAnimation { duration: 150; easing.type: Easing.OutCubic }
            }

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: niri.focusWorkspaceById(ws.model.id)
            }
        }
    }
}
