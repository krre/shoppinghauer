import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Dialogs
import "../products"
import "../../components"
import ".."

NamedPage {
    id: root
    property int templateId: 0
    name: qsTr("Template products")

    StackView.onActivated: {
        templateName.text = String("<b>%1</b>").arg(database.templateRecord(templateId).name)
        templateProductsModel.clear()

        // for (let params of database.templateProducts(templateId)) {
        //     templateProductsModel.append({ id: params.id, name: params.name, product_id: params.product_id })
        // }
    }

    toolBar: Row {
        PlusToolButton {
            onClicked: {
                const hideIds = []

                for (let i = 0; i < templateProductsModel.count; i++) {
                    hideIds.push(templateProductsModel.get(i).product_id)
                }

                const productsPage = pushPage(productsPageComp, { "selectMode": true, "hideIds": hideIds })

                productsPage.selected.connect(function(products) {
                //     database.insertTemplateProducts(templateId, products)
                })
            }
        }
    }

    Component {
        id: productsPageComp
        ProductsPage {}
    }

    MessageDialog {
        id: removeDialog
        text: qsTr("Do you want to remove product?")
        buttons: MessageDialog.Yes | MessageDialog.No

        onButtonClicked: function (button, role) {
            if (button === MessageDialog.No) return

            // database.removeTemplateProduct(templateProductsModel.get(contextMenu.index).id)
            templateProductsModel.remove(contextMenu.index)
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
        id: templateProductsModel
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: 10

        Label {
            id: templateName
        }

        PageListView {
            Layout.preferredWidth: parent.width
            Layout.fillHeight: true
            model: templateProductsModel

            delegate: BorderDelegate {
                id: delegate

                RowLayout {
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.margins: 10

                    Label {
                        text: name
                    }
                }

                TapHandler {
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
