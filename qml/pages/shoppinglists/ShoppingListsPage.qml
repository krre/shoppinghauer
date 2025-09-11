import QtQuick
import QtQuick.Controls
import QtQuick.Dialogs
import "../shoppings"
import "../../components"
import "../../components/style/style.js" as Style
import "../../components/utils.js" as Utils
import ".."

NamedPage {
    id: root
    name: qsTr("Shopping Lists")

    StackView.onActivated: {
        shoppingListsModel.clear()

        for (let params of database.shoppingLists()) {
            shoppingListsModel.append({ id: params.id, date: params.shopping_date, name: params.name })
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

    Component {
        id: shoppingsPageComp
        ShoppingsPage {}
    }

    MessageDialog {
        id: removeDialog
        text: qsTr("Do you want to remove shopping list?")
        buttons: MessageDialog.Yes | MessageDialog.No

        onButtonClicked: function (button, role) {
            if (button === MessageDialog.No) return

            database.removeShoppingList(shoppingListsModel.get(contextMenu.index).id)
            shoppingListsModel.remove(contextMenu.index)
        }
    }

    Menu {
        id: contextMenu
        property int index: -1

        MenuItem {
            text: qsTr("Edit")

            onClicked: pushPage(shoppingListEditorPageComp, { id: shoppingListsModel.get(contextMenu.index).id })
        }

        MenuItem {
            text: qsTr("Remove")

            onClicked: removeDialog.open()
        }
    }

    ListModel {
        id: shoppingListsModel
    }

    PageListView {
        anchors.fill: parent
        model: shoppingListsModel

        delegate: BorderDelegate {
            id: delegate
            color: new Date(date) < Utils.today() ? Style.passedTimeColor : Material.backgroundColor

            Column {
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.margins: 10

                Label {
                    text: Utils.shoppingName(name)
                    font.bold: true
                }

                Label {
                    text: (new Date(date)).toLocaleDateString()
                }
            }

            TapHandler {
                id: tapHandler
                gesturePolicy: TapHandler.ReleaseWithinBounds

                onTapped: pushPage(shoppingsPageComp, { shoppingListId: shoppingListsModel.get(index).id })

                onLongPressed: {
                    contextMenu.index = index
                    contextMenu.popup(delegate)
                }
            }
        }
    }
}
