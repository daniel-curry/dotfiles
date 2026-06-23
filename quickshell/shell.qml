import QtQuick
import Quickshell

ShellRoot {
    Osd {}

    Variants {
        model: Quickshell.screens

        PanelWindow {
            required property var modelData
            screen: modelData

            anchors {
                top: true
                left: true
                right: true
            }

            implicitHeight: 34
            color: "#000000"

            Bar {
                anchors.fill: parent
            }
        }
    }
}
