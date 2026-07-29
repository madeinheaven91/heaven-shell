import QtQuick
import QtQuick.Layouts
import Quickshell
import "./modules"
import "./components"

PanelWindow {
    id: bar
	property int padding: 10
	property int borderWidth: 2
	property int totalHeight: 30

    anchors {
        top: true
        right: true
        left: true
    }
	margins {
		top: 4
		right: 4
		left: 4
	}
    implicitHeight: bar.totalHeight

    color: "transparent"

    Rectangle {
		id: statusBar

        color: root.colorBg
        anchors.fill: parent
        topRightRadius: root.borderRadius
        bottomRightRadius: root.borderRadius
        bottomLeftRadius: root.borderRadius
        topLeftRadius: root.borderRadius
		border.width: bar.borderWidth

        // left
        RowLayout {
            anchors {
                left: parent.left
                leftMargin: 25
                verticalCenter: parent.verticalCenter
            }
            spacing: 25

			Loader { active: true; sourceComponent: 
				Workspaces {}
			}
			Loader { active: true; sourceComponent: 
				Mpris {
					service: MprisService{}
				}
			}
        }

        // center
        RowLayout {
            anchors {
                horizontalCenter: parent.horizontalCenter
                verticalCenter: parent.verticalCenter
            }

            Loader { active: true; sourceComponent: Time {} }

        }

        // right
        RowLayout {
            anchors {
                verticalCenter: parent.verticalCenter
                right: parent.right
                rightMargin: 25
            }
            spacing: 25

            Loader { active: true; sourceComponent: Tray { window: bar } }
            Loader { active: true; sourceComponent: Volume { service: VolumeService {} } }
            Loader { active: true; sourceComponent: WifiComponent { service: WifiService {} } }
			// Text { text: "|"; font { pixelSize: root.fontSize; family: root.fontFamily } }
			
			// Loader { active: true; sourceComponent: Power {} }
            Loader { active: true; sourceComponent: Power {} }
            Loader { active: true; sourceComponent: Language {} }
        }
    }
}
