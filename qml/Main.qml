import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "main"
import "dialogs"

ApplicationWindow {
    id: root
    title: app.name
    width: 400
    height: 770
    visible: true

    Component.onCompleted: {
        x = (Screen.desktopAvailableWidth - width) / 2
        y = (Screen.desktopAvailableHeight - height) / 2
    }

    header: ToolBar {
        RowLayout {
            anchors.fill: parent

            Item {
                Layout.fillWidth: true
            }

            MenuToolButton {}
        }
    }

    Action {
        id: quitAction
        shortcut: "Ctrl+Q"
        onTriggered: Qt.quit()
    }

    StackView {
        id: stackView
        anchors.fill: parent
    }
}
