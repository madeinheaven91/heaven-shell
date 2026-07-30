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
        color: Theme.colorBar

        // left
        RowLayout {
            anchors {
                left: parent.left
                leftMargin: 24
                verticalCenter: parent.verticalCenter
            }
            spacing: 24

            Text {
                text: "\uf179"
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
            Battery {}
            Wifi {}
            Volume {}
            Settings {}
            Time {}
        }
    }
}
