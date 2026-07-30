import QtQuick 2.7 
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0
import QtQuick.Window 2.2
import "../../config"
import "."

ApplicationWindow {
  visible: SettingsState.open
  width: 640
  height: 480
  title: qsTr("Heaven Shell Settings")
  background: Rectangle { color: Theme.colorBg }
  onClosing: SettingsState.open = false

  Text {
      text: "TODO"
      anchors.centerIn: parent
      color: Theme.colorFg
      font.pixelSize: 64
  }
}
