import QtQuick
import QtQuick.Layouts
import Quickshell.Services.Mpris

RowLayout {
    id: root
    spacing: 6
    visible: activePlayer !== null

    readonly property var activePlayer: {
        const players = Mpris.players.values;
        return players.find(p => p.isPlaying) || players.find(p => p.trackTitle.length > 0) || null;
    }

    Text {
        text: "\uf001"
        color: Theme.foreground
        font.family: Theme.iconFontFamily
        font.pixelSize: Theme.fontSize
    }

    Text {
        Layout.maximumWidth: 480
        elide: Text.ElideRight
        text: root.activePlayer ? root.activePlayer.trackArtist + " - " + root.activePlayer.trackTitle : ""
        color: Theme.foreground
        font.family: Theme.fontFamily
        font.pixelSize: Theme.fontSize

        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            onClicked: root.activePlayer && root.activePlayer.togglePlaying()
            onWheel: (event) => {
                if (!root.activePlayer) return;
                if (event.angleDelta.y > 0) root.activePlayer.next();
                else if (event.angleDelta.y < 0) root.activePlayer.previous();
            }
        }
    }
}
