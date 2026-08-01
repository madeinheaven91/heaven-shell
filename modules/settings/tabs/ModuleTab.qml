import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../../../config"

Item {
    // one editable row for a single theme property.
    // modelData is expected to be { key: <Theme property>, label: <display text> }
    component SettingRow: RowLayout {
        id: row
        required property var modelData
        readonly property string key: modelData.key
        readonly property string label: modelData.label

        Layout.fillWidth: true
        spacing: 8

        Text {
            text: row.label
            font: Theme.text
            color: Theme.colorFg
            Layout.preferredWidth: 100
        }

        // checkbox (checkbox only)
        CheckBox {
            checked: Theme[row.key]
            onToggled: Theme[row.key] = checked
        }
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 16
        spacing: 12

        Text {
            text: "Left section"
            font: Theme.boldText
            color: Theme.colorFg
        }

        Repeater {
            model: [
                { key: "workspacesModuleEnabled", label: "Workspaces" },
            ]
            SettingRow {}
        }

        Text {
            text: "Center section"
            font: Theme.boldText
            color: Theme.colorFg
        }

        Repeater {
            model: [
                { key: "mprisModuleEnabled", label: "Mpris player" },
            ]
            SettingRow {}
        }

        Text {
            text: "Right section"
            font: Theme.boldText
            color: Theme.colorFg
        }

        Repeater {
            model: [
                { key: "trayModuleEnabled", label: "System Tray" },
                { key: "langModuleEnabled", label: "Language" },
                { key: "batteryModuleEnabled", label: "Battery" },
                { key: "wifiModuleEnabled", label: "WiFi" },
                { key: "volumeModuleEnabled", label: "Volume" },
            ]
            SettingRow {}
        }

        Item {
            Layout.fillHeight: true
        }
    }
}
