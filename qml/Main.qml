import QtQuick
import QtQuick.Controls

Window {
    width: 400
    height: 770
    visible: true
    title: app.name

    Component.onCompleted: {
        x = (Screen.desktopAvailableWidth - width) / 2
        y = (Screen.desktopAvailableHeight - height) / 2
    }

    Action {
        id: quitAction
        shortcut: "Ctrl+Q"
        onTriggered: Qt.quit()
    }
}
