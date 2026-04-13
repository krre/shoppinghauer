import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Dialogs
import "../../components"
import ".."

NamedPage {
    id: root
    property int id: 0
    name: qsTr("Template")

    Component.onCompleted: {
        if (id > 0) {
            const params = database.templateRecord(id)
            name.text = params.name
        }
    }

    MessageDialog {
        id: duplicateDialog
        text: qsTr("Template already exists")
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

            onClicked: {
                if (!name.text) {
                    popPage()
                    return
                }

                if (id > 0) {
                    database.updateTemplate(id, name.text)
                } else {
                    database.insertTemplate(name.text)
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
