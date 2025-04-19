import QtQuick
import QtQuick.Controls
import QtQuick.Dialogs
import "../../components"
import ".."

NamedPage {
    id: root
    name: qsTr("Products")

    StackView.onActivated: {
        model.clear()

        for (let params of database.products()) {
            model.append({ id: params.id, name: params.name })
        }
    }

    toolBar: Row {
        PlusToolButton {
            onClicked: pushPage(productEditorPageComp)
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

            database.removeProduct(model.get(contextMenu.index).id)
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
