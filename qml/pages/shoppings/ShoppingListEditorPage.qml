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
                property bool isSelected: model.day === root.selected.getDate() && model.month === root.selected.getMonth()
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                color: isSelected ? "red" : "black"
                font.bold: isSelected ? true : false
                font.pointSize: grid.font.pointSize + 3
                text: model.day
            }

            onClicked: (date) => selected = date
        }

        Label {
            Layout.alignment: Qt.AlignHCenter
            text: selected.toLocaleDateString()
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
