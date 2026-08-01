import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import "../components"
import "../../../services"
import "../../../config"

MouseArea {
    id: root
    implicitWidth: row.implicitWidth
    implicitHeight: row.implicitHeight
    acceptedButtons: Qt.LeftButton | Qt.RightButton
    cursorShape: Qt.PointingHandCursor
    onClicked: mouse => {
        if (mouse.button === Qt.LeftButton) {
            toggleMuteProcess.running = true;
        } else {
            pavucontrolProcess.running = true;
        }
    }

    RowLayout {
		id: row

        Text {
            text: icon();
            color: BarTheme.colorFg
            font: Theme.icon
        }
        Text {
            text: Number(service.volume * 100).toFixed(0) + "%"
            color: BarTheme.colorFg
            font: Theme.boldText
        }
    }

    VolumeService {
        id: service
    }

    Process {
        id: toggleMuteProcess
        command: ["wpctl", "set-mute", "@DEFAULT_AUDIO_SINK@", "toggle"]
        running: false
    }

    Process {
        id: pavucontrolProcess
        command: ["pavucontrol"]
        running: false
    }

    function icon() {
        if (service.isMuted) {
            return "\ueee8";
        } else {
            if (service.volume < 0.2) {
                return "\uf026";
            } else if (service.volume < 0.6) {
                return "\uf027";
            } else {
                return "\uf028";
            }
        }	
    }
}
