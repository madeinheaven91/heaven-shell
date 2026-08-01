import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Services.Mpris

Singleton {
    id: service

    property bool hasPlayers: Mpris.players.values.length > 0
    // last player that started playing; stays selected while paused
    property var activePlayer: null
    property string artist: activePlayer ? (activePlayer.trackArtist || "") : ""
    property string title: activePlayer ? (activePlayer.trackTitle || "") : ""
    property string fullText: artist && title ? artist + " — " + title : title

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
                    service.activePlayer = modelData;
            }
        }
    }

    property var playerWatcher: Connections {
        target: Mpris.players
        function onValuesChanged() {
            if (Mpris.players.values.indexOf(service.activePlayer) === -1)
                service.activePlayer = service.fallbackPlayer();
        }
    }

    Component.onCompleted: activePlayer = fallbackPlayer()
}
