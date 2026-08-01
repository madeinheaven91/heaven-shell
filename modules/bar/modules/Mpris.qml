import QtQuick
import QtQuick.Layouts
import Quickshell
import "../../../services"
import "../../../config"

MouseArea {
    id: mprisRoot
    implicitWidth: inner.implicitWidth
    implicitHeight: inner.implicitHeight
    property int charLimit: 64
    readonly property var player: mprisService.activePlayer
    // true when something is actually playing; Bar combines this with the
    // theme toggle to decide visibility
    readonly property bool available: player !== null && inner.text !== ""
    hoverEnabled: true
    cursorShape: Qt.PointingHandCursor
    onClicked: if (mprisRoot.player)
        mprisRoot.player.togglePlaying()

    // keep the popup open while hovering either the bar text or the popup,
    // with a grace period to move the mouse between them
    property bool hovered: mprisRoot.containsMouse || popupHover.hovered
    onHoveredChanged: {
        if (hovered) {
            hideTimer.stop();
            popup.visible = true;
        } else {
            hideTimer.restart();
        }
    }

    Text {
        id: inner
        anchors.centerIn: parent
        font: Theme.text
        color: mprisRoot.player && mprisRoot.player.isPlaying ? BarTheme.colorFg : Qt.alpha(BarTheme.colorFg, 0.5)
        text: {
            var t = mprisService.title;
            if (t.length > mprisRoot.charLimit)
                t = t.substring(0, mprisRoot.charLimit) + "...";
            return t;
        }
    }

    PopupWindow {
        id: popup
        color: "transparent"

        anchor {
            item: mprisRoot
            rect.x: (mprisRoot.width - popup.implicitWidth) / 2
            rect.y: mprisRoot.height + 8
        }

        implicitWidth: 400
        implicitHeight: content.implicitHeight + 20

        Rectangle {
            anchors.fill: parent
            radius: 8
            color: Theme.tooltipAlpha

            HoverHandler {
                id: popupHover
            }

            ColumnLayout {
                id: content
                anchors.centerIn: parent
                width: parent.width - 20
                spacing: 4

                Text {
                    Layout.alignment: Qt.AlignHCenter
                    Layout.maximumWidth: popup.implicitWidth - 20
                    elide: Text.ElideRight
                    text: mprisRoot.player ? (mprisRoot.player.trackTitle || "Unknown") : ""
                    color: "#ffffff"
                    font {
                        family: Theme.textFont
                        pixelSize: Theme.textSize
                        bold: true
                    }
                }

                Text {
                    visible: text !== ""
                    Layout.alignment: Qt.AlignHCenter
                    Layout.maximumWidth: popup.implicitWidth - 20
                    elide: Text.ElideRight
                    text: mprisRoot.player ? (mprisRoot.player.trackArtist || "") : ""
                    color: Qt.alpha("#ffffff", 0.6)
                    font {
                        family: Theme.textFont
                        pixelSize: Theme.textSize - 4
                    }
                }

                Text {
                    Layout.alignment: Qt.AlignHCenter
                    text: mprisRoot.player ? mprisRoot.formatTime(mprisRoot.player.position) + " / " + mprisRoot.formatTime(mprisRoot.player.length) : ""
                    color: "#ffffff"
                    font {
                        family: Theme.textFont
                        pixelSize: Theme.textSize - 4
                    }
                }

                RowLayout {
                    Layout.alignment: Qt.AlignHCenter
                    spacing: 20

                    Text {
                        text: "󰒮"
                        color: mprisRoot.player && mprisRoot.player.canGoPrevious ? "#ffffff" : Qt.alpha("#ffffff", 0.4)
                        font: Theme.icon
                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: if (mprisRoot.player)
                                mprisRoot.player.previous()
                        }
                    }

                    Text {
                        text: mprisRoot.player && mprisRoot.player.isPlaying ? "󰏤" : "󰐊"
                        color: "#ffffff"
                        font: Theme.icon
                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: if (mprisRoot.player)
                                mprisRoot.player.togglePlaying()
                        }
                    }

                    Text {
                        text: "󰒭"
                        color: mprisRoot.player && mprisRoot.player.canGoNext ? "#ffffff" : Qt.alpha("#ffffff", 0.4)
                        font: Theme.icon
                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: if (mprisRoot.player)
                                mprisRoot.player.next()
                        }
                    }
                }
            }
        }
    }

    MprisService {
        id: mprisService
    }

    Timer {
        id: hideTimer
        interval: 300
        onTriggered: popup.visible = false
    }

    // player.position only updates on seek; poke it while the popup is visible
    Timer {
        running: popup.visible && mprisRoot.player !== null && mprisRoot.player.isPlaying
        interval: 1000
        repeat: true
        triggeredOnStart: true
        onTriggered: mprisRoot.player.positionChanged()
    }

    function formatTime(seconds) {
        if (seconds === undefined || isNaN(seconds) || seconds < 0)
            return "0:00";
        var m = Math.floor(seconds / 60);
        var s = Math.floor(seconds % 60);
        return m + ":" + (s < 10 ? "0" : "") + s;
    }
}
