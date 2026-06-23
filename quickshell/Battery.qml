import QtQuick
import QtQuick.Layouts
import Quickshell.Services.UPower

RowLayout {
    spacing: 4

    readonly property var device: UPower.displayDevice

    visible: device !== null && device.isLaptopBattery

    Text {
        text: device ? Math.round(device.percentage) + "%" : ""
        color: Theme.foreground
        font.family: Theme.fontFamily
        font.pixelSize: Theme.fontSize
    }

    Text {
        text: device && device.state === UPowerDeviceState.Charging ? "\uf0e7" : "\uf244"
        color: Theme.foreground
        font.family: Theme.iconFontFamily
        font.pixelSize: Theme.fontSize
    }
}
