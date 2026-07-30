import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: service

    property bool typing: false
    property bool isEnabled: false
    property string connectedSSID: ""
    property ListModel networks: ListModel {}
    
    // Connection state tracking
    property string connectingSSID: ""
    property string connectionError: ""
    property bool isEthernetConnected: false
    property string ipAddress: ""
    property string gateway: ""
    // active physical interface (ethernet preferred over wifi)
    property string activeDevice: ""
    // bytes per second on activeDevice
    property real downloadSpeed: 0
    property real uploadSpeed: 0

    // interface changed: old byte counters are meaningless, drop the baseline
    onActiveDeviceChanged: _lastSampleTime = 0
    property var _scanResults: []
    property var _knownList: []
    property real _rxAcc: 0
    property real _txAcc: 0
    property real _lastRx: 0
    property real _lastTx: 0
    property real _lastSampleTime: 0

    Process {
        id: netSpeedProcess
        command: ["cat", "/proc/net/dev"]
        onStarted: {
            service._rxAcc = 0;
            service._txAcc = 0;
        }
        stdout: SplitParser {
            onRead: data => {
                const line = data.trim();
                const colonIdx = line.indexOf(':');
                if (colonIdx === -1)
                    return;
                const iface = line.substring(0, colonIdx).trim();
                if (service.activeDevice === "") {
                    // device not known yet, fall back to everything but lo
                    if (iface === 'lo')
                        return;
                } else if (iface !== service.activeDevice) {
                    return;
                }
                const fields = line.substring(colonIdx + 1).trim().split(/\s+/);
                service._rxAcc += parseInt(fields[0]) || 0;
                service._txAcc += parseInt(fields[8]) || 0;
            }
        }
        onExited: {
            const now = Date.now();
            if (service._lastSampleTime > 0) {
                const dt = (now - service._lastSampleTime) / 1000;
                if (dt > 0) {
                    service.downloadSpeed = Math.max(0, (service._rxAcc - service._lastRx) / dt);
                    service.uploadSpeed = Math.max(0, (service._txAcc - service._lastTx) / dt);
                }
            }
            service._lastRx = service._rxAcc;
            service._lastTx = service._txAcc;
            service._lastSampleTime = now;
        }
    }

    Timer {
        interval: 2000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: netSpeedProcess.running = true
    }

    Process {
        id: ipProcess
        command: ["nmcli", "-t", "-f", "IP4.ADDRESS,IP4.GATEWAY", "device", "show"]
        property bool _ipFound: false
        property bool _gatewayFound: false
        onStarted: {
            _ipFound = false;
            _gatewayFound = false;
        }
        stdout: SplitParser {
            onRead: data => {
                // lines look like "IP4.ADDRESS[1]:192.168.1.5/24" or "IP4.GATEWAY:10.0.0.1"
                const line = data.trim();
                const colonIdx = line.indexOf(':');
                if (colonIdx === -1)
                    return;
                const field = line.substring(0, colonIdx);
                const value = line.substring(colonIdx + 1).trim();
                if (value === "")
                    return;
                if (!ipProcess._ipFound && field.startsWith("IP4.ADDRESS")) {
                    service.ipAddress = value.split('/')[0];
                    ipProcess._ipFound = true;
                } else if (!ipProcess._gatewayFound && field === "IP4.GATEWAY") {
                    service.gateway = value;
                    ipProcess._gatewayFound = true;
                }
            }
        }
        onExited: {
            if (!ipProcess._ipFound)
                service.ipAddress = "";
            if (!ipProcess._gatewayFound)
                service.gateway = "";
        }
    }

    Process {
        id: connectionProcess
        stdout: SplitParser {
            onRead: data => console.log("[Connect Out]: " + data)
        }
        stderr: SplitParser {
            onRead: data => {
                console.log("[Connect Err]: " + data)
                // Capture errors
                if (data.includes("Secrets were required") || 
                    data.includes("802-11-wireless-security.psk") ||
                    data.includes("Error:")) {
                    service.connectionError = "invalid";
                }
            }
        }
        onExited: {
            console.log("Connection attempt finished. Exit code: " + exitCode);
            
            if (exitCode !== 0) {
                console.log("Connection failed");
                if (service.connectionError === "") {
                    service.connectionError = "failed";
                }
            }
            
            settleTimer.start();
        }
    }

    Timer {
        id: settleTimer
        interval: 1000
        repeat: false
        onTriggered: {
            service.update();
            if (service.connectedSSID === service.connectingSSID) {
                service.connectingSSID = "";
                service.connectionError = "";
            } else if (service.connectingSSID !== "") {
                service.connectingSSID = "";
            }
        }
    }

    Process {
        id: statusProcess
        command: ["nmcli", "radio", "wifi"]
        stdout: SplitParser {
            onRead: data => service.isEnabled = data.trim() === "enabled"
        }
    }

    Process {
        id: connectedProcess
        command: ["nmcli", "-t", "-f", "active,ssid", "dev", "wifi"]
        stdout: SplitParser {
            onRead: data => {
                const lines = data.split('\n');
                for (const line of lines) {
                    if (line.startsWith('yes:')) {
                        service.connectedSSID = line.substring(4).trim();
                        break;
                    }
                }
            }
        }
    }

    Process {
        id: ethernetProcess
        command: ["nmcli", "-t", "-f", "DEVICE,TYPE,STATE", "device"]
        property string _ethernetDevice: ""
        property string _wifiDevice: ""
        onStarted: {
            _ethernetDevice = "";
            _wifiDevice = "";
        }
        stdout: SplitParser {
            onRead: data => {
                const parts = data.trim().split(':');
                if (parts.length < 3)
                    return;
                const device = parts[0];
                const type = parts[1];
                const state = parts[2];
                if (state !== 'connected')
                    return;
                if (type === 'ethernet' && ethernetProcess._ethernetDevice === "")
                    ethernetProcess._ethernetDevice = device;
                else if (type === 'wifi' && ethernetProcess._wifiDevice === "")
                    ethernetProcess._wifiDevice = device;
            }
        }
        onExited: {
            service.isEthernetConnected = ethernetProcess._ethernetDevice !== "";
            service.activeDevice = ethernetProcess._ethernetDevice !== ""
                ? ethernetProcess._ethernetDevice
                : ethernetProcess._wifiDevice;
        }
    }

    Process {
        id: knownProcess
        command: ["nmcli", "-t", "-f", "NAME", "connection", "show"]
        onStarted: service._knownList = []
        stdout: SplitParser {
            onRead: data => {
                const lines = data.split('\n');
                for (const line of lines) {
                    if (line.trim() !== "")
                        service._knownList.push(line.trim());
                }
            }
        }
        onExited: scanProcess.running = true
    }

    Process {
        id: scanProcess
        command: ["nmcli", "-t", "-f", "SSID,SIGNAL,SECURITY", "dev", "wifi", "list"]
        onStarted: service._scanResults = []

        stdout: SplitParser {
            onRead: data => {
                const lines = data.split('\n');
                for (const line of lines) {
                    if (!line || line.trim() === '')
                        continue;
                    const lastColon = line.lastIndexOf(':');
                    const secondLastColon = line.lastIndexOf(':', lastColon - 1);
                    if (lastColon === -1 || secondLastColon === -1)
                        continue;
                    const ssid = line.substring(0, secondLastColon).replace(/\\:/g, ':');
                    const signal = parseInt(line.substring(secondLastColon + 1, lastColon)) || 0;
                    const security = line.substring(lastColon + 1);

                    if (ssid && ssid !== '--') {
                        const isKnown = service._knownList.includes(ssid);

                        service._scanResults.push({
                            ssid: ssid,
                            signal: signal,
                            secured: security.length > 0 && security !== "",
                            isKnown: isKnown
                        });
                    }
                }
            }
        }
        onExited: {
            const uniqueResults = [];
            const seenSSIDs = new Set();

            for (const item of service._scanResults) {
                if (!seenSSIDs.has(item.ssid)) {
                    seenSSIDs.add(item.ssid);
                    uniqueResults.push(item);
                }
            }

            for (const newItem of uniqueResults) {
                let foundIndex = -1;
                for (let i = 0; i < networks.count; i++) {
                    if (networks.get(i).ssid === newItem.ssid) {
                        foundIndex = i;
                        break;
                    }
                }
                if (foundIndex !== -1)
                    networks.set(foundIndex, newItem);
                else
                    networks.append(newItem);
            }

            for (let i = networks.count - 1; i >= 0; i--) {
                const oldSSID = networks.get(i).ssid;
                if (!seenSSIDs.has(oldSSID))
                    networks.remove(i);
            }
        }
    }

    Timer {
        interval: 10000
        running: true
        repeat: true
        onTriggered: service.update()
    }

    Timer {
        id: delayedUpdate
        interval: 2000
        onTriggered: service.update()
    }

    Component.onCompleted: update()

    function update() {
        if (typing)
            return;
        if (connectionProcess.running)
            return;

        statusProcess.running = true;
        connectedProcess.running = true;
        ethernetProcess.running = true;
        ipProcess.running = true;

        if (isEnabled) {
            knownProcess.running = true;
        } else {
            networks.clear();
            service.connectedSSID = "";
        }
    }

    function toggleRadio() {
        var cmd = isEnabled ? "off" : "on";
        Quickshell.execDetached(["nmcli", "radio", "wifi", cmd]);
        delayedUpdate.start();
    }

    function connect(ssid, password) {
        console.log("=== CONNECTING ===");
        
        // Set connecting state
        service.connectingSSID = ssid;
        service.connectionError = "";
        
        var cmd = ["nmcli", "dev", "wifi", "connect", ssid];
        if (password && password !== "")
            cmd.push("password", password);

        connectionProcess.command = cmd;
        connectionProcess.running = true;
    }

    function disconnect() {
        if (service.connectedSSID) {
            Quickshell.execDetached(["nmcli", "connection", "down", service.connectedSSID]);
            delayedUpdate.start();
        }
    }
    
    function clearError(ssid) {
        service.connectionError = "";
    }
}
