import QtQuick
import Quickshell.Services.Mpris

QtObject {
    id: mprisService

    property bool hasPlayers: Mpris.players.values.length > 0
    // last player that started playing; stays selected while paused
    property var activePlayer: null
    property string artist: activePlayer ? (activePlayer.trackArtist || "") : ""
    property string title: activePlayer ? (activePlayer.trackTitle || "") : ""
    property string fullText: artist && title ? artist + " - " + title : title

    function fallbackPlayer() {
        var players = Mpris.players.values;
        var pausedPlayer = null;

        for (var i = 0; i < players.length; i++) {
            if (players[i].isPlaying)
                return players[i];
            if (!pausedPlayer && players[i].playbackState === MprisPlaybackState.Paused)
                pausedPlayer = players[i];
        }

        return pausedPlayer || (players.length > 0 ? players[0] : null);
    }

    // whichever player starts playing becomes the active one
    property var stateWatchers: Instantiator {
        model: Mpris.players
        delegate: Connections {
            target: modelData
            function onPlaybackStateChanged() {
                if (modelData.isPlaying)
                    mprisService.activePlayer = modelData;
            }
        }
    }

    property var playerWatcher: Connections {
        target: Mpris.players
        function onValuesChanged() {
            if (Mpris.players.values.indexOf(mprisService.activePlayer) === -1)
                mprisService.activePlayer = mprisService.fallbackPlayer();
        }
    }

    Component.onCompleted: activePlayer = fallbackPlayer()
}
