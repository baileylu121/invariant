import Quickshell
import QtQuick.Layouts
import Quickshell.Io
import QtQuick
import Niri 0.1

Scope {
    id: root

    Niri {
        id: niri
        Component.onCompleted: connect()

        onConnected: console.info("Connected to niri")
        onErrorOccurred: function (error) {
            console.error("Niri error:", error);
        }
    }

    PanelWindow {
        color: theme.window

        anchors {
            top: true
            left: true
            bottom: true
        }

        implicitWidth: 30

        ColumnLayout {
            anchors.centerIn: parent
            spacing: 5
            Repeater {
                model: niri.workspaces

                Rectangle {
                    visible: index < 11
                    width: 15
                    height: 15
                    radius: 10
                    color: model.isActive ? theme.text : theme.light
                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: niri.focusWorkspaceById(model.id)
                    }
                }
            }
        }
    }
}
