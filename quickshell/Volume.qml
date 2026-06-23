import QtQuick
import Quickshell.Io
import Quickshell.Services.Pipewire

Text {
    id: root

    readonly property var sink: Pipewire.defaultAudioSink
    readonly property real currentVolume: sink && sink.audio ? sink.audio.volume : 0
    readonly property bool currentMuted: sink && sink.audio ? sink.audio.muted : false
    property bool ready: false

    PwObjectTracker {
        objects: [root.sink]
    }

    // Skip the OSD popup for the initial value pickup on startup.
    Timer {
        interval: 500
        running: true
        onTriggered: root.ready = true
    }

    onCurrentVolumeChanged: if (ready) OsdService.volume(currentVolume, currentMuted)
    onCurrentMutedChanged: if (ready) OsdService.volume(currentVolume, currentMuted)

    text: sink && sink.audio ? "" : ""
    color: Theme.foreground
    font.family: Theme.iconFontFamily
    font.pixelSize: Theme.fontSize

    Process {
        id: pavucontrolProc
        command: ["pavucontrol"]
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: pavucontrolProc.running = true
        onWheel: (event) => {
            if (!root.sink || !root.sink.audio) return;
            const delta = event.angleDelta.y > 0 ? 0.05 : -0.05;
            root.sink.audio.volume = Math.max(0, Math.min(1.5, root.sink.audio.volume + delta));
        }
    }
}
