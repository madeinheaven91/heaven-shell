import Quickshell
import Quickshell.Io
import QtQuick
import "./modules/bar"
import "./modules/settings"

ShellRoot {
    id: root

    Bar {}

    SettingsWindow {}
    SettingsICP {}
}
