import QtQuick
import QtQuick.Controls
import QtQuick.Dialogs
import "../../components"
import ".."

NamedPage {
    id: root
    property bool selectMode: false
    name: qsTr("Products")

    signal selected(var products)

    StackView.onActivated: {
        productsModel.clear()

        for (let params of database.products()) {
            productsModel.append({ id: params.id, name: params.name, checked: false })
        }
    }

    toolBar: Row {
        PlusToolButton {
            onClicked: pushPage(productEditorPageComp)
        }

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

    Menu {
        id: contextMenu
        property int index: -1

        MenuItem {
            text: qsTr("Edit")

            onClicked: pushPage(productEditorPageComp, { id: productsModel.get(contextMenu.index).id })
        }

        MenuItem {
            text: qsTr("Remove")

            onClicked: removeDialog.open()
        }
    }

    ListModel {
        id: productsModel
    }

    ListView {
        anchors.fill: parent
        model: productsModel
        spacing: 5
        clip: true

        delegate: BorderDelegate {
            id: delegate

            Row {
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.margins: 10

                CheckBox {
                    anchors.verticalCenter: parent.verticalCenter
                    visible: selectMode

                    onCheckedChanged: productsModel.setProperty(index, "checked", checked)
                }

                Label  {
                    anchors.verticalCenter: parent.verticalCenter
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
