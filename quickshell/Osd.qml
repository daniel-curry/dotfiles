import QtQuick
import QtQuick.Layouts
import Quickshell

PanelWindow {
    id: osd
    visible: false
    color: "transparent"
    focusable: false

    implicitWidth: 220
    implicitHeight: 90

    property real value: 0
    property string glyph: ""

    function present(iconGlyph, v) {
        glyph = iconGlyph;
        value = Math.max(0, Math.min(1, v));
        visible = true;
        hideTimer.restart();
        card.opacity = 1;
    }

    Connections {
        target: OsdService
        function onVolume(value, muted) {
            osd.present(muted ? "" : (value > 0.5 ? "" : ""), value);
        }
        function onBrightness(value) {
            osd.present("", value);
        }
    }

    Timer {
        id: hideTimer
        interval: 600
        onTriggered: card.opacity = 0
    }

    Rectangle {
        id: card
        anchors.fill: parent
        radius: 18
        color: Theme.osdBackground
        opacity: 0

        Behavior on opacity {
            NumberAnimation { duration: 220; easing.type: Easing.OutCubic }
        }

        onOpacityChanged: if (opacity === 0) osd.visible = false

        ColumnLayout {
            anchors.centerIn: parent
            spacing: 12

            Text {
                Layout.alignment: Qt.AlignHCenter
                text: osd.glyph
                color: Theme.foreground
                font.family: Theme.iconFontFamily
                font.pixelSize: 30
            }

            Rectangle {
                Layout.preferredWidth: 150
                Layout.preferredHeight: 6
                Layout.alignment: Qt.AlignHCenter
                radius: 3
                color: Theme.osdTrack

                Rectangle {
                    width: parent.width * osd.value
                    height: parent.height
                    radius: 3
                    color: Theme.accent

                    Behavior on width {
                        NumberAnimation { duration: 150; easing.type: Easing.OutCubic }
                    }
                }
            }
        }
    }
}
