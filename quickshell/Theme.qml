pragma Singleton
import QtQuick

QtObject {
    readonly property color background: "#000000"
    readonly property color foreground: "#ffffff"
    readonly property color accent: "#c9545d"
    readonly property color disconnected: "#f53c3c"
    readonly property color charging: "#7ec96a"
    readonly property color osdBackground: "#101010"
    readonly property color osdTrack: "#333333"

    readonly property string fontFamily: "JetBrains Mono"
    readonly property string iconFontFamily: "Symbols Nerd Font"
    readonly property int fontSize: 13

    readonly property int moduleSpacing: 14
    readonly property int iconSpacing: 6
    readonly property int barPadding: 10
}
