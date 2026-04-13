import QtQuick
import QtQuick.Controls
import QtQuick.Dialogs
import "../../components"
import ".."

NamedPage {
    id: root
    name: qsTr("Templates")

    StackView.onActivated: {
        templatesModel.clear()

        for (let params of database.templates()) {
            templatesModel.append({ id: params.id, name: params.name })
        }
    }

    toolBar: Row {
        PlusToolButton {
            onClicked: pushPage(templateEditorPageComp)
        }
    }

    Component {
        id: templateEditorPageComp

        TemplateEditorPage {}
    }

    Component {
        id: templateProductsPageComp

        TemplateProductsPage {}
    }

    MessageDialog {
        id: removeDialog
        text: qsTr("Do you want to remove template?")
        buttons: MessageDialog.Yes | MessageDialog.No

        onButtonClicked: function (button, role) {
            if (button === MessageDialog.No) return

            database.removeTemplate(templatesModel.get(contextMenu.index).id)
            templatesModel.remove(contextMenu.index)
        }
    }

    Menu {
        id: contextMenu
        property int index: -1

        MenuItem {
            text: qsTr("Edit")

            onClicked: pushPage(templateEditorPageComp, { id: templatesModel.get(contextMenu.index).id })
        }

        MenuItem {
            text: qsTr("Remove")

            onClicked: removeDialog.open()
        }
    }

    ListModel {
        id: templatesModel
    }

    PageListView {
        anchors.fill: parent
        model: templatesModel

        delegate: BorderDelegate {
            id: delegate

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
                gesturePolicy: TapHandler.ReleaseWithinBounds

                onTapped: pushPage(templateProductsPageComp, { templateId: templatesModel.get(index).id })

                onLongPressed: {
                    contextMenu.index = index
                    contextMenu.popup(delegate)
                }
            }
        }
    }
}
