import QtQuick
import Quickshell
import "../../../config"
import "../../settings"

Text {
    id: settingsButton
    text: "\uf1de"
    color: BarTheme.colorFg
    font: Theme.icon

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: SettingsState.toggle()
    }
}
