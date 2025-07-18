import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Shoppinghauer
import "main"
import "components"
import "pages/shoppinglists"

ApplicationWindow {
    id: mainRoot
    title: app.name
    width: 400
    height: 770
    visible: true

    Component.onCompleted: {
        x = (Screen.desktopAvailableWidth - width) / 2
        y = (Screen.desktopAvailableHeight - height) / 2

        database.init()
        stackView.push(shoppingListsPage)
    }

    header: ToolBar {
        RowLayout {
            anchors.fill: parent

            StyledToolButton {
                action: navigateAction
            }

            StyledLabel {
                id: title
                Layout.fillWidth: true
                horizontalAlignment: Qt.AlignLeft
                verticalAlignment: Qt.AlignVCenter
                text: stackView.currentItem && stackView.currentItem.name
                elide: Text.ElideRight
                font.bold: true
            }

            Row {
                data: stackView.currentItem ? stackView.currentItem.toolBar : []
            }

            OptionsMenuToolButton {
                id: optionsMenuButton
            }
        }
    }

    Database {
        id: database
    }

    Shortcut {
        sequences: ["Esc", "Back"]
        enabled: stackView.depth > 1
        onActivated: navigateAction.trigger()
    }

    Action {
        id: navigateAction
        icon.source: stackView.depth > 1 ? "qrc:/assets/icons/arrow-left.svg" : "qrc:/assets/icons/menu.svg"

        onTriggered: {
            if (stackView.depth > 1) {
                stackView.pop()
            } else {
                navigationMenu.open()
            }
        }
    }

    Component {
        id: shoppingListsPage
        ShoppingListsPage {}
    }

    NavigationMenu {
        id: navigationMenu
        height: parent.height
    }

    StackView {
        id: stackView
        anchors.fill: parent

        onCurrentItemChanged: {
            if (stackView.currentItem) {
                optionsMenuButton.menuItems = stackView.currentItem.menuItems
            } else {
                optionsMenuButton.menuItems = []
            }
        }
    }
}
