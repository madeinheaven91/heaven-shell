import QtQuick
import Quickshell
import "../../../config"

Text {
    id: timeText
    text: Qt.formatDateTime(clock.date, "ddd d MMM  hh:mm")
    color: Theme.colorFg
    font: Theme.boldText

    SystemClock {
        id: clock
        precision: SystemClock.Minutes
    }
}
