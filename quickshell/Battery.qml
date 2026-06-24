import QtQuick
import QtQuick.Layouts
import Quickshell.Services.UPower

RowLayout {
    spacing: 4

    readonly property var device: UPower.displayDevice

    // Key the glyph color off AC presence rather than the battery's per-device
    // state, which briefly churns through PendingCharge/Unknown on plug-in.
    readonly property bool charging: !UPower.onBattery
    readonly property color glyphColor: charging ? Theme.charging : Theme.foreground

    // Font Awesome battery-empty (\uf244) .. battery-full (\uf240), descending codepoints
    readonly property string batteryIcon: {
        if (!device)
            return "";
        var p = device.percentage;
        if (p >= 0.875)
            return "\uf240";
        if (p >= 0.625)
            return "\uf241";
        if (p >= 0.375)
            return "\uf242";
        if (p >= 0.125)
            return "\uf243";
        return "\uf244";
    }

    visible: device !== null && device.isLaptopBattery

    Text {
        text: device ? Math.round(device.percentage * 100) + "%" : ""
        color: Theme.foreground
        font.family: Theme.fontFamily
        font.pixelSize: Theme.fontSize
    }

    Text {
        text: batteryIcon
        color: glyphColor
        font.family: Theme.iconFontFamily
        font.pixelSize: Theme.fontSize
    }
}
