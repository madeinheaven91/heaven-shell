import QtQuick
import QtQuick.Layouts
import Quickshell

Rectangle {
    SystemClock {
        id: clock
        precision: SystemClock.Seconds
    }
    Text {
        id: timeBlock
        anchors {
            verticalCenter: parent.verticalCenter
        }
        text: Qt.formatDateTime(clock.date, "dd.MM.yyyy | hh:mm")
        color: root.colorFg
		font { family: root.fontFamily; pixelSize: root.fontSize }
        Component.onCompleted: {
            parent.width = timeBlock.contentWidth
        }
    }
}
