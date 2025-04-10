import QtQuick
import QtQuick.Controls
import "../dialogs"

ToolButton {
    Material.foreground: "#f0f0f0"

    action: Action {
        id: optionsMenuAction
        icon.source: "qrc:/assets/icons/dots-vertical.svg"
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
