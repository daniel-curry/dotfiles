import QtQuick
import Quickshell.Io

Text {
    id: root
    property int percent: 0
    property bool ready: false

    text: ""
    color: Theme.foreground
    font.family: Theme.iconFontFamily
    font.pixelSize: Theme.fontSize

    function refresh() {
        getProc.running = true;
    }

    onPercentChanged: if (ready) OsdService.brightness(percent / 100)

    Process {
        id: getProc
        command: ["brightnessctl", "-m", "info"]
        stdout: StdioCollector {
            onStreamFinished: {
                // device,class,current,percent%,max
                const fields = this.text.trim().split(",");
                if (fields.length >= 4) {
                    root.percent = parseInt(fields[3], 10) || 0;
                }
            }
        }
    }

    Process {
        id: setProc
        onExited: root.refresh()
    }

    Timer {
        interval: 5000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: root.refresh()
    }

    // Skip the OSD popup for the initial value pickup on startup.
    Timer {
        interval: 800
        running: true
        onTriggered: root.ready = true
    }

    MouseArea {
        anchors.fill: parent
        onWheel: (event) => {
            setProc.command = event.angleDelta.y > 0
                ? ["brightnessctl", "s", "+10%", "--min-value=5"]
                : ["brightnessctl", "s", "10%-", "--min-value=5"];
            setProc.running = true;
        }
    }
}
