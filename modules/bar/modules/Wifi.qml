import QtQuick
import QtQuick.Layouts
import Quickshell
import "../components"
import "../../../services"
import "../../../config"

Rectangle {
    id: wifiRoot
    property bool showSpeed: false
    readonly property var service: wifiService

    implicitWidth: row.implicitWidth
    implicitHeight: row.implicitHeight
    color: "transparent"

    WifiService {
        id: wifiService
    }

    // newt named colors mapped to the bar palette via the terminal theme:
    // lightgray ~ colorBg, black ~ colorFg, gray ~ colorFgInactive
    readonly property string nmtuiColors: ["root=lightgray,black", "roottext=gray,black", "helpline=gray,black", "shadow=,black", "window=black,lightgray", "border=black,lightgray", "title=blue,lightgray", "label=black,lightgray", "textbox=black,lightgray", "acttextbox=lightgray,black", "listbox=black,lightgray", "actlistbox=lightgray,black", "sellistbox=black,lightgray", "actsellistbox=green,black", "checkbox=black,lightgray", "actcheckbox=lightgray,black", "button=lightgray,black", "actbutton=black,gray", "compactbutton=black,lightgray", "entry=black,gray", "disentry=gray,lightgray"].join(";")

    function formatSpeed(bytesPerSec) {
        let bitsPerSec = bytesPerSec * 8;
        if (bitsPerSec < 1024)
            return bitsPerSec.toFixed(0) + " b/s";
        if (bitsPerSec < 1024 * 1024)
            return (bitsPerSec / 1024).toFixed(1) + " Kb/s";
        return (bitsPerSec / (1024 * 1024)).toFixed(1) + " Mb/s";
    }

    RowLayout {
        id: row

        Text {
            font: Theme.icon
            text: {
                wifiService.isEthernetConnected ? "\udb80\ude00" : "\uf1eb";
            }
            visible: !showSpeed
        }

        RowLayout {
            id: speedRow
            visible: showSpeed
            spacing: 8
            Text {
                id: duIcon
                font: Theme.icon
                text: "\uf0ec"
                rotation: 90
            }
            ColumnLayout {
                spacing: -4
                Text {
                    id: uploadSpeedText
                    font: Qt.font({
                        family: Theme.textFont,
                        pixelSize: 12
                    })
                    color: Theme.colorFg
                    text: wifiRoot.formatSpeed(wifiService.uploadSpeed)
                }
                Text {
                    id: downloadSpeedText
                    font: Qt.font({
                        family: Theme.textFont,
                        pixelSize: 12
                    })
                    color: Theme.colorFg
                    text: wifiRoot.formatSpeed(wifiService.downloadSpeed)
                }
            }
        }
    }

    MouseArea {
        id: hoverArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        onClicked: mouse => {
            if (mouse.button === Qt.LeftButton)
                wifiRoot.showSpeed = !wifiRoot.showSpeed;
            else
                Quickshell.execDetached(["sh", "-c", "NEWT_COLORS='" + wifiRoot.nmtuiColors + "' alacritty --class qs-nmtui -e nmtui"]);
        }
    }

    Tooltip {
        targetItem: wifiRoot
        visible: hoverArea.containsMouse
        text: {
            var lines = [];
            if (wifiService.connectedSSID !== "")
                lines.push("Network: " + wifiService.connectedSSID);
            else if (wifiService.isEthernetConnected)
                lines.push("Network: Ethernet");
            else
                lines.push("Not connected");
            if (wifiService.ipAddress !== "")
                lines.push("IP: " + wifiService.ipAddress);
            if (wifiService.gateway !== "")
                lines.push("Gateway: " + wifiService.gateway);
            return lines.join("\n");
        }
    }
}
