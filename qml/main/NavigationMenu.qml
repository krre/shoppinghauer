import QtQuick
import QtQuick.Controls
import QtQuick.Dialogs
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
            text: qsTr("Export")

            onClicked: {
                const path = database.exportFile()
                exportDialog.isSuccess = path !== ""
                exportDialog.open()
            }

            MessageDialog {
                id: exportDialog
                property bool isSuccess: false
                text: isSuccess ? qsTr("Export finished") : qsTr("Export error")
                buttons: MessageDialog.Ok
            }
        }

        ItemDelegate {
            width: parent.width
            text: qsTr("Import")

            onClicked: fileDialog.open()

            FileDialog {
                id: fileDialog
                title: qsTr("Select Database")
                nameFilters: [qsTr("Databases (*.db)"), qsTr("All files (*)")]
                onAccepted: {
                    const path = String(fileDialog.selectedFile).replace("file://", "")
                    const success = database.importFile(path)

                    if (success) {
                        root.close()
                        gotoShoppingLists()
                    } else {
                        importDialog.open()
                    }
                }
            }

            MessageDialog {
                id: importDialog
                text: qsTr("Import error")
                buttons: MessageDialog.Ok
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
