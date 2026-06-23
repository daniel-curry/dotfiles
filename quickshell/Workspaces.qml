import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland
import Quickshell.Widgets

Item {
    id: root

    implicitWidth: wsRow.implicitWidth
    implicitHeight: wsRow.implicitHeight
    Layout.alignment: Qt.AlignVCenter

    property string activeSpecialName: ""

    readonly property int pillHeight: 22
    readonly property int iconSize: 16

    // Window classes whose lowercased name doesn't match their themed icon name.
    readonly property var iconOverrides: ({
        "code": "vscode",
        "code-url-handler": "vscode"
    })

    // Geometry of the currently focused regular workspace pill. The moving
    // indicator binds to these so it swipes between workspaces.
    property real indicatorX: 0
    property real indicatorWidth: 0
    readonly property bool hasActiveRegular: root.occupiedWorkspaces.some(w =>
        w.focused && !w.name.startsWith("special:"))

    Component.onCompleted: {
        Hyprland.refreshWorkspaces();
        Hyprland.refreshToplevels();
        initialMonitorSync.start();
    }

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
            } else if (event.name.startsWith("openwindow")
                    || event.name.startsWith("movewindow")
                    || event.name.startsWith("closewindow")) {
                // A new/moved window's class only arrives via an IPC refresh;
                // without this its icon falls back to the generic placeholder.
                Hyprland.refreshToplevels();
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

    function iconSource(cls) {
        const c = (cls || "").toLowerCase();
        const entry = DesktopEntries.heuristicLookup(cls || "");
        const name = (entry && entry.icon)
            ? entry.icon
            : (root.iconOverrides[c] || c || "application-x-executable");
        return Quickshell.iconPath(name, "application-x-executable");
    }

    // Single highlight that slides between regular workspaces.
    Rectangle {
        id: indicator
        anchors.verticalCenter: parent.verticalCenter
        height: root.pillHeight
        x: root.indicatorX
        width: root.indicatorWidth
        radius: height / 2
        color: Theme.accent
        opacity: root.hasActiveRegular ? 1.0 : 0.0

        Behavior on x { NumberAnimation { duration: 220; easing.type: Easing.OutCubic } }
        Behavior on width { NumberAnimation { duration: 220; easing.type: Easing.OutCubic } }
        Behavior on opacity { NumberAnimation { duration: 150; easing.type: Easing.InOutQuad } }
    }

    RowLayout {
        id: wsRow
        anchors.fill: parent
        spacing: 6

        Repeater {
            model: root.occupiedWorkspaces

            delegate: Item {
                id: wsItem
                required property var modelData

                readonly property bool isSpecial: modelData.name.startsWith("special:")
                readonly property bool isActiveRegular: modelData.focused && !isSpecial
                readonly property bool isActiveSpecial: isSpecial
                    && modelData.name === root.activeSpecialName
                    && root.activeSpecialName.length > 0
                readonly property bool highlighted: isActiveRegular || isActiveSpecial
                readonly property string wsLabel: isSpecial ? "S" : modelData.name

                readonly property var appClasses: modelData.toplevels.values
                    .map(t => t.lastIpcObject?.class || "")

                implicitWidth: pillContents.implicitWidth + 14
                implicitHeight: root.pillHeight
                Layout.alignment: Qt.AlignVCenter

                // The special workspace fades in/out (it overlays a regular one);
                // regular workspaces are tracked by the sliding indicator instead.
                opacity: isSpecial ? (isActiveSpecial || modelData.toplevels.values.length > 0 ? 1.0 : 0.0) : 1.0
                Behavior on opacity { NumberAnimation { duration: 180; easing.type: Easing.InOutQuad } }

                // Report geometry to the shared indicator while focused.
                function pushIndicator() {
                    if (isActiveRegular) {
                        root.indicatorX = x;
                        root.indicatorWidth = width;
                    }
                }
                onIsActiveRegularChanged: pushIndicator()
                onXChanged: pushIndicator()
                onWidthChanged: pushIndicator()
                Component.onCompleted: pushIndicator()

                // Fading pill for the special workspace only.
                Rectangle {
                    anchors.fill: parent
                    radius: height / 2
                    color: Theme.accent
                    visible: wsItem.isSpecial
                    opacity: wsItem.isActiveSpecial ? 1.0 : 0.0
                    Behavior on opacity { NumberAnimation { duration: 200; easing.type: Easing.InOutQuad } }
                }

                RowLayout {
                    id: pillContents
                    anchors.centerIn: parent
                    spacing: 5

                    Text {
                        text: wsItem.wsLabel
                        color: wsItem.highlighted ? Theme.background : Theme.foreground
                        font.family: Theme.fontFamily
                        font.pixelSize: Theme.fontSize
                        Layout.alignment: Qt.AlignVCenter
                        Behavior on color { ColorAnimation { duration: 150 } }
                    }

                    Repeater {
                        model: wsItem.appClasses

                        ClippingRectangle {
                            required property string modelData
                            color: "transparent"
                            radius: 4
                            implicitWidth: root.iconSize
                            implicitHeight: root.iconSize
                            Layout.alignment: Qt.AlignVCenter

                            IconImage {
                                anchors.fill: parent
                                source: root.iconSource(modelData)
                                asynchronous: true
                            }
                        }
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: modelData.activate()
                }
            }
        }
    }
}
