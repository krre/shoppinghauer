import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../../components"
import "../../components/style.js" as Style
import "../../components/utils.js" as Utils
import ".."

NamedPage {
    id: root
    property date selectedDate
    property int id: 0
    name: qsTr("Shopping List")

    Component.onCompleted: {
        if (id > 0) {
            const params = database.shoppingList(id)
            selectedDate = new Date(params.shopping_date)
            name.text = params.name
        } else {
            selectedDate = Utils.today()
        }
    }

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
            month: selectedDate.getMonth()
            year: selectedDate.getFullYear()

            delegate: Rectangle {
                property bool isSelected: model.day === root.selectedDate.getDate() && model.month === root.selectedDate.getMonth()
                width: 15
                height: 30
                color: {
                    if (isSelected) {
                        return "red"
                    }

                    const targetDate = new Date(model.year, model.month, model.day)

                    if (targetDate < Utils.today()) {
                        return Style.passedTimeColor
                    }

                    return "transparent"
                }

                Text {
                    anchors.centerIn: parent
                    text: model.day
                    color: isSelected ? "white" : "black"
                }
            }

            onClicked: (date) => selectedDate = date
        }

        Label {
            Layout.alignment: Qt.AlignHCenter
            text: selectedDate.toLocaleDateString()
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

            onClicked: {
                if (id > 0) {
                    database.updateShoppingList(id, selectedDate, name.text)
                } else if (selectedDate) {
                    database.insertShoppingList(selectedDate, name.text)
                }

                popPage()
            }
        }
    }
}
