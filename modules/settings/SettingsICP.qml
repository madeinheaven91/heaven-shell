import QtQuick
import Quickshell
import Quickshell.Io

Scope {
    IpcHandler {
        target: "settings"

        function toggle(): void {
            SettingsState.toggle();
        }

        function open(): void {
            SettingsState.open = true;
        }

        function close(): void {
            SettingsState.open = false;
        }
    }
}
