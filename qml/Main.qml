import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "main"

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

            ToolButton {
                Material.foreground: "#f0f0f0"
                action: navigateAction
            }

            Item {
                Layout.fillWidth: true
            }

            OptionsMenuToolButton {}
        }
    }

    Shortcut {
        sequences: ["Esc", "Back"]
        enabled: stackView.depth > 1
        onActivated: navigateAction.trigger()
    }

    Action {
        id: navigateAction
        text: stackView.depth > 1 ? "Back" : "Menu"

        onTriggered: {
            if (stackView.depth > 1) {
                stackView.pop()
            } else {
                navigationMenu.open()
            }
        }
    }

    NavigationMenu {
        id: navigationMenu
        height: parent.height
    }

    StackView {
        id: stackView
        anchors.fill: parent
    }
}
