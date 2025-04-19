import QtQuick
import QtQuick.Controls
import "../pages/shoppinglists"
import "../pages/products"

Drawer {
    id: root

    Column {
        anchors.fill: parent

        ItemDelegate {
            width: parent.width
            text: qsTr("Shopping Lists")

            onClicked: {
                stackView.clear()
                stackView.push(shoppingListsPageComp)
                root.close()
            }
        }

        ItemDelegate {
            width: parent.width
            text: qsTr("Products")

            onClicked: {
                stackView.push(productsPageComp)
                root.close()
            }
        }

        ItemDelegate {
            width: parent.width
            text: qsTr("Exit")

            action: Action {
                shortcut: "Ctrl+Q"
                onTriggered: Qt.quit()
            }
        }
    }

    Component {
        id: shoppingListsPageComp
        ShoppingListsPage {}
    }

    Component {
        id: productsPageComp
        ProductsPage {}
    }
}
