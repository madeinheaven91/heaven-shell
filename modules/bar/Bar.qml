import QtQuick
import QtQuick.Layouts
import Quickshell
import "./modules"
import "../../config"

PanelWindow {
    id: bar

    anchors {
        top: true
        left: true
        right: true
    }
    implicitHeight: 32
    color: "transparent"

    Rectangle {
        anchors.fill: parent
        color: Qt.alpha(Theme.colorFg, Theme.barOpacity)

        // left
        RowLayout {
            anchors {
                left: parent.left
                leftMargin: 24
                verticalCenter: parent.verticalCenter
            }
            spacing: 24

            Text {
                text: "\uf313"
                color: Theme.colorFg
                font.family: Theme.iconFont
                font.pixelSize: Theme.bigIconSize
            }

            Workspaces {}
        }


        // center
        RowLayout {
            anchors.centerIn: parent

            Mpris {}
        }


        // right
        RowLayout {
            anchors {
                right: parent.right
                rightMargin: 24
                verticalCenter: parent.verticalCenter
            }
            spacing: 24

            Tray {}
            Language {}
            Battery {}
            Wifi {}
            Volume {}
            Settings {}
            Time {}
        }
    }
}
