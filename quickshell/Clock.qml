import QtQuick
import Quickshell

Text {
    SystemClock {
        id: clock
        precision: SystemClock.Minutes
    }

    text: Qt.formatDateTime(clock.date, "hh:mm AP - dddd, MMMM d")
    color: Theme.foreground
    font.bold: true
    font.family: Theme.fontFamily
    font.pixelSize: Theme.fontSize
}
