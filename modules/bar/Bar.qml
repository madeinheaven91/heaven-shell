import QtQuick
import QtQuick.Layouts
import QtQuick.Effects
import Quickshell
import "./modules"
import "../../config"

PanelWindow {
    id: bar

    readonly property int barHeight: 32

    anchors {
        top: true
        left: true
        right: true
    }
    // taller than the bar so the shadow has room to render below it;
    // exclusiveZone/mask keep the extra space from reserving area or eating clicks
    implicitHeight: barHeight + 60
    exclusiveZone: barHeight
    mask: Region {
        item: rect
    }
    color: "transparent"

    RectangularShadow {
        visible: Theme.barShadow
        anchors.fill: rect
        offset.x: 0
        offset.y: 0
        radius: rect.radius
        blur: 10
        spread: 5
        color: Qt.darker(rect.color, 1.6)
    }

    Rectangle {
        id: rect
        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
        }
        height: bar.barHeight
        color: BarTheme.colorBg

        // left
        RowLayout {
            anchors {
                left: parent.left
                leftMargin: 24
                verticalCenter: parent.verticalCenter
            }
            spacing: 24

            Text {
                text: ""
                color: BarTheme.colorFg
                font.family: Theme.iconFont
                font.pixelSize: Theme.bigIconSize
            }

            Workspaces {
                visible: Theme.workspacesModuleEnabled
            }
        }

        // center
        RowLayout {
            anchors.centerIn: parent

            Mpris {
                visible: Theme.mprisModuleEnabled && available
            }
        }

        // right
        RowLayout {
            anchors {
                right: parent.right
                rightMargin: 24
                verticalCenter: parent.verticalCenter
            }
            spacing: 24

            Tray {
                visible: Theme.trayModuleEnabled
            }
            Language {
                visible: Theme.langModuleEnabled
            }
            Battery {
                visible: Theme.batteryModuleEnabled && available
            }
            Wifi {
                visible: Theme.wifiModuleEnabled
            }
            Volume {
                visible: Theme.volumeModuleEnabled
            }
            Settings { }
            Time { }
        }
    }

}
