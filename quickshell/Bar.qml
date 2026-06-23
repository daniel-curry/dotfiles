import QtQuick
import QtQuick.Layouts

Item {
    id: root

    Rectangle {
        anchors.fill: parent
        color: Theme.background
    }

    RowLayout {
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.leftMargin: Theme.barPadding
        spacing: Theme.moduleSpacing

        MediaPlayer {}
    }

    RowLayout {
        anchors.centerIn: parent
        spacing: Theme.moduleSpacing

        Clock {}
    }

    RowLayout {
        anchors.verticalCenter: parent.verticalCenter
        anchors.right: parent.right
        anchors.rightMargin: Theme.barPadding
        spacing: Theme.moduleSpacing

        Workspaces {}

        RowLayout {
            spacing: Theme.iconSpacing

            NetworkIndicator {}
            Battery {}
            Backlight {}
            Volume {}
        }
    }
}
