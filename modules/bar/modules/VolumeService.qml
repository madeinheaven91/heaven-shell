import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root
    
    property bool monitorEnabled: true
    property real volume: 0.0
	property bool isMuted: false
    
    function setVolume(newVolume) {
        var clampedVolume = Math.max(0, Math.min(1, newVolume))
        clampedVolume = Math.round(clampedVolume * 100) / 100
        
        setVolumeProcess.command = ["wpctl", "set-volume", "@DEFAULT_AUDIO_SINK@", clampedVolume.toString()]
        setVolumeProcess.running = true
    }

    
    Process {
        id: setVolumeProcess
    }
    
	Process {
		id: getVolumeProcess
		command: ["wpctl", "get-volume", "@DEFAULT_AUDIO_SINK@"]
		running: true

		stdout: SplitParser {
			onRead: line => {
				var parts = line.trim().split(/\s+/)
				var vol = parseFloat(parts[1])
				if (!isNaN(vol)) {
					root.volume = Math.round(vol * 100) / 100
				}
				root.isMuted = line.includes("MUTED")
			}
		}
	}
    
    Process {
        id: monitor
        running: root.monitorEnabled
        command: ["pw-mon"]
        
        stdout: SplitParser {
            onRead: line => {
                if (line.includes("changed") || line.includes("Props")) {
                    if (root.monitorEnabled) {
                        getVolumeProcess.running = true
                        getIsMutedProcess.running = true
                    }
                }
            }
        }
    }
}
