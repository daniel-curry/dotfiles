import QtQuick
import Quickshell.Io

// No bar presence; brightness is controlled via keyboard keys. This only
// polls the current level and drives the OSD popup when it changes.
Item {
    id: root
    property int percent: 0
    property bool ready: false

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
}
