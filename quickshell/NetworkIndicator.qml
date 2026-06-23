import QtQuick
import Quickshell.Networking

Text {
    readonly property var activeDevice: Networking.devices.values.find(d => d.connected) || null

    text: activeDevice ? (activeDevice.type === NetworkDevice.Wifi ? "\uf1eb" : "\uf0e8") : "\uf1eb"
    color: activeDevice ? Theme.foreground : Theme.disconnected
    font.family: Theme.iconFontFamily
    font.pixelSize: Theme.fontSize
}
