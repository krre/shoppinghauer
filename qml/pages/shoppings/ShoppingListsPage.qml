import QtQuick
import QtQuick.Controls
import QtQuick.Dialogs
import "../../components"
import ".."

NamedPage {
    id: root
    name: qsTr("Shopping Lists")

    StackView.onActivated: {
        model.clear()

        for (let params of database.shoppingLists()) {
            model.append({ id: params.id, date: params.shopping_date, name: params.name })
        }
    }

    toolBar: Row {
        PlusToolButton {
            onClicked: pushPage(shoppingListEditorPageComp)
        }
    }

    Component {
        id: shoppingListEditorPageComp
        ShoppingListEditorPage {}
    }

    MessageDialog {
        id: removeDialog
        text: qsTr("Do you want to remove shopping list?")
        buttons: MessageDialog.Yes | MessageDialog.No

        onButtonClicked: function (button, role) {
            if (button === MessageDialog.No) return

            database.removeShoppingList(model.get(contextMenu.index).id)
            model.remove(contextMenu.index)
        }
    }

    Menu {
        id: contextMenu
        property int index: -1

        MenuItem {
            text: qsTr("Remove")
            onClicked: removeDialog.open()
        }
    }

    ListModel {
        id: model
    }

    ListView {
        anchors.fill: parent
        model: model
        spacing: 5

        delegate: Rectangle {
            id: delegate
            width: ListView.view.width
            height: 50
            border.color: Material.primaryColor

            Column {
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.margins: 10

                Label {
                    text: name || qsTr("Noname")
                }

                Label {
                    text: (new Date(date)).toLocaleDateString()
                }
            }

            TapHandler {
                id: tapHandler
                gesturePolicy: TapHandler.ReleaseWithinBounds

                onLongPressed: {
                    contextMenu.index = index
                    contextMenu.popup(delegate)
                }
            }
        }
    }
}
