import QtQuick
import QtQuick.Controls
import "../../components"
import ".."

NamedPage {
    id: root
    name: qsTr("Shopping Lists")

    StackView.onActivated: {
        model.clear()

        for (let params of database.shoppingLists()) {
            model.append({ id: params.id, date: params.shopping_date, name: params.name })
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

    ListModel {
        id: model
    }

    ListView {
        anchors.fill: parent
        model: model
        spacing: 5

        delegate: Rectangle {
            width: ListView.view.width
            height: 50
            border.color: Material.primaryColor

            Column {
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.margins: 10

                Label {
                    text: name || qsTr("Noname")
                }

                Label {
                    text: (new Date(date)).toLocaleDateString()
                }
            }
        }
    }
}
