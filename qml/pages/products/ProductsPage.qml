import QtQuick
import QtQuick.Controls
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
        }
    }
}
