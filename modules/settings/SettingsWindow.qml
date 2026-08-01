import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Window
import "../../config"
import "./tabs"

ApplicationWindow {
  visible: SettingsState.open
  width: 640
  height: 480
  title: qsTr("Heaven Shell Settings")
  background: Rectangle { color: Theme.colorBg }
  onClosing: SettingsState.open = false

  // index of the currently selected tab
  property int currentTab: 0
  readonly property var tabs: ["Appearance", "Modules"]

  RowLayout {
    id: windowRoot
    anchors.fill: parent
    spacing: 0

    // background slightly darker than Theme.colorBg
    Rectangle {
        id: tabPanel
        Layout.preferredWidth: windowRoot.width * 0.2
        Layout.fillWidth: false
        Layout.fillHeight: true
        color: Qt.darker(Theme.colorBg, 1.2)

        ColumnLayout {
            anchors.fill: parent
            spacing: 0

            Repeater {
                model: tabs

                Button {
                    required property int index
                    required property string modelData

                    Layout.fillWidth: true
                    text: modelData
                    checkable: true
                    checked: currentTab === index
                    onClicked: currentTab = index

                    background: Rectangle {
                        color: checked ? Theme.colorTooltip : "transparent"
                    }
                    contentItem: Text {
                        text: modelData
                        font: Theme.text
                        color: checked ? Theme.colorBg : Theme.colorFg
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignHCenter
                    }
                }
            }

            // push the buttons to the top
            Item { Layout.fillHeight: true }
        }
    }

    StackLayout {
        id: content
        Layout.fillWidth: true
        Layout.fillHeight: true
        currentIndex: currentTab

        AppearanceTab {}
        ModuleTab {}
    }
  }
}
