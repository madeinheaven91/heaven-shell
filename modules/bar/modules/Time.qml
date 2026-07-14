import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import '../components'

Rectangle {
    id: timeRoot
    implicitWidth: timeBlock.implicitWidth
    implicitHeight: bar.totalHeight - 4
    color: "transparent"

    property string calOutput: ""
    property string highlightColor: "#C03030"

    SystemClock {
        id: clock
        precision: SystemClock.Seconds
    }

    Process {
        id: calProc
        command: ["cal", "-m"]
        running: true
        stdout: StdioCollector {
            onStreamFinished: timeRoot.calOutput = text.replace(/\s+$/, "")
        }
    }

    // highlight the current day
    function highlightCal(cal) {
        var lines = cal.split("\n");
        var now = clock.date;
        var today = now.getDate();
        var year = now.getFullYear();
        var month = now.getMonth();
        var out = [];

        for (var i = 0; i < lines.length; i++) {
            var line = lines[i];
            // first two lines are the month/year header and weekday names
            if (i < 2) {
                out.push(line);
                continue;
            }
            var res = "";
            var last = 0;
            var re = /\d+/g;
            var m;
            while ((m = re.exec(line)) !== null) {
                res += line.substring(last, m.index);
                var day = parseInt(m[0]);
                var dow = new Date(year, month, day).getDay();
                var frag = m[0];
                if (day === today)
                    frag = '<b><span style="background-color:' + timeRoot.highlightColor + '">' + frag + '</span></b>';
                else if (dow === 0 || dow === 6)
                    frag = '<font color=\"red\">' + frag + '</font>';
                res += frag;
                last = m.index + m[0].length;
            }
            res += line.substring(last);
            out.push(res);
        }

        return out.join("\n").split(" ").join("&nbsp;").replace(/\n/g, "<br/>");
    }

    Text {
        id: timeBlock
        anchors {
            verticalCenter: parent.verticalCenter
        }
        text: Qt.formatDateTime(clock.date, "dd.MM.yyyy | hh:mm")
        color: root.colorFg
        font { family: root.fontFamily; pixelSize: root.fontSize }
    }

    MouseArea {
        id: hoverArea
        anchors.fill: parent
        hoverEnabled: true
        onContainsMouseChanged: if (containsMouse) calProc.running = true

        Tooltip {
            target: hoverArea
            show: hoverArea.containsMouse
            horizontalAlignment: "center"

            Text {
                textFormat: Text.StyledText
                text: timeRoot.highlightCal(timeRoot.calOutput)
                color: root.colorFg
                font.family: root.fontFamily
                font.pixelSize: root.fontSize - 2
            }
        }
    }
}
