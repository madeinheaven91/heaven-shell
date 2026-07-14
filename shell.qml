import Quickshell
import Quickshell.Wayland
import QtQuick
import QtQuick.Layouts
import Niri 0.1
import "./modules/bar"
import "./modules/activate-linux"
import "./modules/window"

ShellRoot{
    id: root
	property string fontFamily: "CodeNewRoman Nerd Font"
	property int fontSize: 18

	property string colorBg: "#F4F4E6"
	property string colorFgInactive: "#979394"
	property string colorFg: "#171314"
	property int borderRadius: 12

	property bool showActivateLinux: true

    Niri {
        id: niri
        Component.onCompleted: connect()

        onConnected: console.info("Connected to niri")
        onErrorOccurred: function(error) {
            console.error("Niri error:", error)
        }
    }

	// LazyLoader{ 
	// 	active: root.showActivateLinux;
	// 	component: ActivateLinux{}
	// }
    LazyLoader{ active: true; component: Bar{} }
}
