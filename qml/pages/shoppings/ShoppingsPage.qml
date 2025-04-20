import QtQuick
import QtQuick.Controls
import QtQuick.Dialogs
import "../../components"
import ".."

NamedPage {
    id: root
    property int shoppingListId: 0
    name: qsTr("Shoppings")

    StackView.onActivated: {
        shoppingsModel.clear()

        for (let params of database.shoppings(shoppingListId)) {
            shoppingsModel.append({ id: params.id, name: params.name, count: params.count })
        }
    }

    toolBar: Row {
        PlusToolButton {
        }
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

    ListView {
        anchors.fill: parent
        model: shoppingsModel
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
