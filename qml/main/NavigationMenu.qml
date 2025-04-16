import QtQuick
import QtQuick.Controls
import "../pages/shoppings"
import "../pages/products"

Drawer {
    id: root

    Column {
        anchors.fill: parent

        ItemDelegate {
            width: parent.width
            text: qsTr("Shoppings")

            onClicked: {
                stackView.clear()
                stackView.push(shoppingsPageComp)
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
        id: shoppingsPageComp
        ShoppingsPage {}
    }

    Component {
        id: productsPageComp
        ProductsPage {}
    }
}
