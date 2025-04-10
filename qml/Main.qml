import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
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

            ToolButton {
                Material.foreground: "#f0f0f0"
                action: Action {
                    id: optionsMenuAction
                    text: qsTr("Menu")
                    onTriggered: optionsMenu.open()
                }

                Menu {
                    id: optionsMenu
                    x: parent.width - width
                    transformOrigin: Menu.TopRight

                    Action {
                        text: qsTr("About")
                        onTriggered: aboutDialogComp.createObject(root)
                    }
                }

                Shortcut {
                    sequence: "Menu"
                    onActivated: optionsMenuAction.trigger()
                }

                Component {
                    id: aboutDialogComp
                    AboutDialog {}
                }
            }
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
