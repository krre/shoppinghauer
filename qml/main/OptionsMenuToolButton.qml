import QtQuick
import QtQuick.Controls
import "../components"

StyledToolButton {
    id: root
    property var menuItems: []

    action: Action {
        id: optionsMenuAction
        icon.source: "qrc:/assets/icons/dots-vertical.svg"
        onTriggered: optionsMenu.open()
    }

    onMenuItemsChanged: common.menuItems = (menuItems || []).concat(common.systemMenuItems)

    QtObject {
        id: common
        property var menuItems: []
        property var systemMenuItems: [
            {
                text: qsTr("About"),
                onTriggered: function() { aboutDialogComp.createObject(mainRoot) }
            }
        ]
    }

    Component {
        id: aboutDialogComp
        AboutDialog {}
    }

    Menu {
        id: optionsMenu
        transformOrigin: Menu.TopRight
        x: root.width - width

        Instantiator {
            model: common.menuItems

            MenuItem {
                text: modelData.text
                onTriggered: modelData.onTriggered()
            }

            onObjectAdded: function(index, object) { optionsMenu.insertItem(index, object) }
            onObjectRemoved: function (index, object) { optionsMenu.removeItem(object) }
        }
    }

    Shortcut {
        sequence: "Menu"
        onActivated: optionsMenuAction.trigger()
    }
}
