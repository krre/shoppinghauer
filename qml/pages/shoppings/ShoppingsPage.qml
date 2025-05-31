import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Dialogs
import "../products"
import "../shoppinglists"
import "../../components"
import "../../components/utils.js" as Utils
import ".."

NamedPage {
    id: root
    property int shoppingListId: 0
    name: qsTr("Shoppings")

    StackView.onActivated: {
        const shoppingListParams = database.shoppingList(shoppingListId)

        const name = Utils.shoppingName(shoppingListParams.name)
        const date = new Date(shoppingListParams.shopping_date).toLocaleDateString()
        shoppingListName.text = String("<b>%1</b> - %2").arg(name).arg(date)

        shoppingsModel.clear()

        for (let params of database.shoppings(shoppingListId)) {
            shoppingsModel.append({ id: params.id, name: params.name, product_id: params.product_id, count: params.count })
        }
    }

    toolBar: Row {
        PlusToolButton {
            onClicked: {
                const hideIds = []

                for (let i = 0; i < shoppingsModel.count; i++) {
                    hideIds.push(shoppingsModel.get(i).product_id)
                }

                const productsPage = pushPage(productsPageComp, { "selectMode": true, "hideIds": hideIds })

                productsPage.selected.connect(function(products) {
                    database.insertShoppings(shoppingListId, products)
                })
            }
        }

        EditToolButton {
            onClicked: pushPage(shoppingListEditorPageComp, { id: shoppingListId })
        }
    }

    Component {
        id: productsPageComp
        ProductsPage {}
    }

    Component {
        id: shoppingListEditorPageComp
        ShoppingListEditorPage {}
    }

    MessageDialog {
        id: removeDialog
        text: qsTr("Do you want to remove shopping?")
        buttons: MessageDialog.Yes | MessageDialog.No

        onButtonClicked: function (button, role) {
            if (button === MessageDialog.No) return

            database.removeShopping(shoppingsModel.get(contextMenu.index).id)
            shoppingsModel.remove(contextMenu.index)
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
        id: shoppingsModel
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: 10

        Label {
            id: shoppingListName
        }

        PageListView {
            Layout.preferredWidth: parent.width
            Layout.fillHeight: true
            model: shoppingsModel

            delegate: BorderDelegate {
                id: delegate

                Column {
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.margins: 10

                    Label {
                        text: name
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
}
