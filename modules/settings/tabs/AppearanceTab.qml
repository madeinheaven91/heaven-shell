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
        // "text" | "color" | "slider" | "combobox" | "checkbox"
        readonly property string type: modelData.type
        // for combobox: array of { value, label }
        readonly property var items: modelData.items ?? []

        readonly property bool isText: type === "text"
        readonly property bool isColor: type === "color"
        readonly property bool isSlider: type === "slider"
        readonly property bool isCombobox: type === "combobox"
        readonly property bool isCheckbox: type === "checkbox"

        Layout.fillWidth: true
        spacing: 8

        Text {
            text: row.label
            font: Theme.text
            color: Theme.colorFg
            Layout.preferredWidth: 100
        }

        // color swatch (colors only)
        Rectangle {
            visible: row.isColor
            width: 24
            height: 24
            radius: 4
            border.width: 1
            border.color: Theme.colorFg
            color: row.isSlider ? "transparent" : Theme[row.key]
        }

        // color value (colors only)
        TextField {
            visible: row.isColor || row.isText
            Layout.fillWidth: true
            text: row.isSlider ? "" : Theme[row.key]
            font: Theme.text
            color: Theme.colorFg
            onEditingFinished: if (!row.isSlider)
                Theme[row.key] = text
        }

        // opacity slider (opacity only)
        Slider {
            visible: row.isSlider
            Layout.fillWidth: true
            from: 0
            to: 1
            value: row.isSlider ? Theme[row.key] : 0
            onMoved: Theme[row.key] = value
        }

        // opacity readout (opacity only)
        Text {
            visible: row.isSlider
            text: row.isSlider ? Number(Theme[row.key]).toFixed(2) : ""
            font: Theme.text
            color: Theme.colorFg
            Layout.preferredWidth: 40
            horizontalAlignment: Text.AlignRight
        }

        // combobox (combobox only)
        // TODO: set dropdown item font to Theme.text
        ComboBox {
            visible: row.isCombobox
            Layout.fillWidth: true
            model: row.items
            textRole: "label"
            valueRole: "value"
            font: Theme.text
            onActivated: Theme[row.key] = currentValue
            Component.onCompleted: if (row.isCombobox)
                currentIndex = -1
                // FIXME: doesnt work properly rn
                // currentIndex = indexOfValue(Theme[row.key])
        }

        // checkbox (checkbox only)
        CheckBox {
            visible: row.isCheckbox
            checked: row.isCheckbox ? Theme[row.key] : false
            onToggled: Theme[row.key] = checked
        }
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 16
        spacing: 12

        Text {
            text: "General"
            font: Theme.boldText
            color: Theme.colorFg
        }

        Repeater {
            model: [
                {
                    key: "colorBg",
                    label: "Background",
                    "type": "color"
                },
                {
                    key: "colorFg",
                    label: "Foreground",
                    "type": "color"
                },
                {
                    key: "colorPanic",
                    label: "Panic",
                    "type": "color"
                },
                {
                    key: "textFont",
                    label: "Text Font",
                    "type": "text"
                },
                {
                    key: "iconFont",
                    label: "Icon Font",
                    "type": "text"
                },
            ]
            SettingRow {}
        }

        Text {
            text: "Tooltips"
            font: Theme.boldText
            color: Theme.colorFg
        }

        Repeater {
            model: [
                {
                    key: "colorTooltip",
                    label: "Color",
                    "type": "color"
                },
                {
                    key: "tooltipOpacity",
                    label: "Opacity",
                    "type": "slider"
                },
            ]
            SettingRow {}
        }

        Text {
            text: "Bar"
            font: Theme.boldText
            color: Theme.colorFg
        }

        Repeater {
            model: [
                {
                    key: "barStyle",
                    label: "Style",
                    "type": "combobox",
                    items: [
                        {
                            value: "transparent",
                            label: "Transparent"
                        },
                        {
                            value: "solid",
                            label: "Solid"
                        }
                    ]
                },
                {
                    key: "barOpacity",
                    label: "Opacity",
                    "type": "slider"
                },
                {
                    key: "barShadow",
                    label: "Shadow",
                    "type": "checkbox"
                },
            ]
            SettingRow {}
        }

        Item {
            Layout.fillHeight: true
        }
    }
}
