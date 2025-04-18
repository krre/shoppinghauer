import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../../components"
import ".."

NamedPage {
    id: root
    property date selected
    name: qsTr("Shopping List")

    ColumnLayout {
        width: parent.width
        spacing: 10

        DayOfWeekRow {
            Layout.fillWidth: true
            locale: grid.locale
        }

        MonthGrid {
            id: grid
            Layout.fillWidth: true
            Layout.fillHeight: true
            month: (new Date).getMonth()
            year: (new Date).getFullYear()

            delegate: Text {
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                color: model.day === root.selected.getDate() && model.month === root.selected.getMonth() ? "red" : "black"
                text: model.day
            }

            onClicked: (date) => selected = date
        }

        Label {
            Layout.alignment: Qt.AlignHCenter
            text: Qt.formatDate(selected, "dd MMM yyyy")
            font.bold: true
        }

        TextField {
            id: name
            Layout.preferredWidth: parent.width
            placeholderText: qsTr("Name")

            Component.onCompleted: forceActiveFocus()
        }

        OkButton {
            Layout.alignment: Qt.AlignRight
            onClicked: popPage()
        }
    }
}
