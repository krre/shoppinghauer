import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Dialogs
import "../../components"
import ".."

NamedPage {
    id: root
    property int id: 0
    name: qsTr("Product")

    Component.onCompleted: {
        if (id > 0) {
            const params = database.product(id)
            name.text = params.name
        }
    }

    MessageDialog {
        id: duplicateDialog
        text: qsTr("Product already exists")
        buttons: MessageDialog.Ok
    }

    ColumnLayout {
        width: parent.width
        spacing: 10

        TextField {
            id: name
            Layout.preferredWidth: parent.width
            placeholderText: qsTr("Name")

            Component.onCompleted: forceActiveFocus()
        }

        OkButton {
            Layout.alignment: Qt.AlignRight
            enabled: name.text

            onClicked: {
                if (id > 0) {
                    database.updateProduct(id, name.text)
                } else {
                    database.insertProduct(name.text)
                }

                const CONSTRAINT_UNIQUE = "2067"

                if (database.lastErrorCode() === CONSTRAINT_UNIQUE) {
                    duplicateDialog.open()
                    return;
                }

                popPage()
            }
        }
    }
}
