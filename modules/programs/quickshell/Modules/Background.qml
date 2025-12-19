import QtQuick
import Qt.labs.platform
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland

Variants {
    model: Quickshell.screens
    PanelWindow {
        id: bgRoot
        required property var modelData
        screen: modelData

        anchors {
            top: true
            left: true
            right: true
            bottom: true
        }

        color: "transparent"

        Component.onCompleted: {
            if (this.WlrLayershell != null) {
                this.WlrLayershell.layer = WlrLayer.Background;
            }
        }

        Image {
            id: wallpaper
            opacity: 1
            x: 0
            y: 0
            source: "./Background/sunset-mountains.jpg"
            sourceSize {
                width: bgRoot.screen.width
                height: bgRoot.screen.height
            }
        }
    }
}
