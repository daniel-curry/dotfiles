import QtQuick
import QtQuick.Layouts
import Quickshell.Hyprland

RowLayout {
    id: root
    spacing: 16

    property string activeSpecialName: ""

    Component.onCompleted: {
        Hyprland.refreshWorkspaces();
        Hyprland.refreshToplevels();
        initialMonitorSync.start();
    }

    // refreshMonitors() races with the workspace/toplevel refreshes above if fired
    // in the same tick, so it's deliberately deferred and kept separate.
    Timer {
        id: initialMonitorSync
        interval: 300
        onTriggered: {
            Hyprland.refreshMonitors();
            const m = Hyprland.focusedMonitor;
            if (m?.lastIpcObject?.specialWorkspace) {
                root.activeSpecialName = m.lastIpcObject.specialWorkspace.name;
            }
        }
    }

    Connections {
        target: Hyprland
        function onRawEvent(event) {
            if (event.name === "activespecial") {
                root.activeSpecialName = event.parse(2)[0];
            }
        }
    }

    readonly property var occupiedWorkspaces: {
        const ws = Hyprland.workspaces.values.filter(w =>
            w.toplevels.values.length > 0 || w.focused || w.name === root.activeSpecialName);
        ws.sort((a, b) => {
            const ai = parseInt(a.name, 10);
            const bi = parseInt(b.name, 10);
            if (isNaN(ai) && isNaN(bi)) return a.name.localeCompare(b.name);
            if (isNaN(ai)) return 1;
            if (isNaN(bi)) return -1;
            return ai - bi;
        });
        return ws;
    }

    Repeater {
        model: root.occupiedWorkspaces

        delegate: Text {
            required property var modelData
            readonly property bool isActive: modelData.focused
                || (modelData.name === root.activeSpecialName && modelData.name.length > 0)

            text: {
                const label = modelData.name === "special:magic" ? "S" : modelData.name;
                const apps = modelData.toplevels.values
                    .map(t => t.lastIpcObject?.class || t.title)
                    .join(", ");
                return label + (apps.length ? ": " + apps : "");
            }

            color: isActive ? Theme.accent : Theme.foreground
            font.bold: isActive
            font.family: Theme.fontFamily
            font.pixelSize: Theme.fontSize

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: modelData.activate()
            }
        }
    }
}
