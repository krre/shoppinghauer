import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Dialogs
import "../../components"
import ".."

NamedPage {
    id: root
    property bool selectMode: false
    property var hideIds: []
    name: qsTr("Products")

    signal selected(var products)

    StackView.onActivated: load()

    toolBar: Row {
        StyledToolButton {
            icon.source: "qrc:/assets/icons/checks.svg"
            visible: selectMode

            onClicked: {
                const products = []

                for (let i = 0; i < productsModel.count; ++i) {
                    if (productsModel.get(i).checked) {
                        products.push(productsModel.get(i).id)
                    }
                }

                selected(products)
                popPage()
            }
        }

        StyledCheckBox {
            id: archive
            text: qsTr("Archive")
            onCheckedChanged: load()
        }

        PlusToolButton {
            onClicked: pushPage(productEditorPageComp)
        }
    }

    function load() {
        productsModel.clear()
        const products = archive.checked ? database.allProducts() : database.products()

        for (let params of products) {
            if (!selectMode || hideIds.indexOf(params.id) < 0) {
                productsModel.append({ id: params.id, name: params.name, is_archived: params.is_archived, checked: false })
            }
        }
    }

    Component {
        id: productEditorPageComp
        ProductEditorPage {}
    }

    MessageDialog {
        id: removeDialog
        text: qsTr("Do you want to remove product?")
        buttons: MessageDialog.Yes | MessageDialog.No

        onButtonClicked: function (button, role) {
            if (button === MessageDialog.No) return

            database.removeProduct(productsModel.get(contextMenu.index).id)
            productsModel.remove(contextMenu.index)
        }
    }

    MessageDialog {
        id: archiveDialog
        text: qsTr("Do you want move product to archive?")
        buttons: MessageDialog.Yes | MessageDialog.No

        onButtonClicked: function (button, role) {
            if (button === MessageDialog.No) return

            database.archiveProduct(productsModel.get(contextMenu.index).id, true)

            if (!archive.checked) {
                productsModel.remove(contextMenu.index)
            } else {
                productsModel.setProperty(contextMenu.index, "is_archived", 1)
            }
        }
    }

    MessageDialog {
        id: unarchiveDialog
        text: qsTr("Do you want return product from archive?")
        buttons: MessageDialog.Yes | MessageDialog.No

        onButtonClicked: function (button, role) {
            if (button === MessageDialog.No) return

            database.archiveProduct(productsModel.get(contextMenu.index).id, false)
            productsModel.setProperty(contextMenu.index, "is_archived", 0)
        }
    }

    Menu {
        id: contextMenu
        property int index: -1

        onAboutToShow: archiveItem.text = productsModel.get(contextMenu.index).is_archived ? qsTr("Return from archive") : qsTr("Move to Archive")

        MenuItem {
            text: qsTr("Edit")
            onClicked: pushPage(productEditorPageComp, { id: productsModel.get(contextMenu.index).id })
        }

        MenuItem {
            text: qsTr("Remove")
            onClicked: removeDialog.open()
        }

        MenuItem {
            id: archiveItem

            onClicked: {
                if (productsModel.get(contextMenu.index).is_archived) {
                    unarchiveDialog.open()
                } else {
                    archiveDialog.open()
                }
            }
        }
    }

    ListModel {
        id: productsModel
    }

    PageListView {
        anchors.fill: parent
        model: productsModel

        delegate: BorderDelegate {
            id: delegate

            RowLayout {
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.margins: 10

                CheckBox {
                    visible: selectMode
                    onCheckedChanged: productsModel.setProperty(index, "checked", checked)
                }

                Label  {
                    text: name
                }

                Item {
                    Layout.fillWidth: true
                }

                Image {
                    visible: is_archived
                    source:  "qrc:/assets/icons/archive.svg"
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
