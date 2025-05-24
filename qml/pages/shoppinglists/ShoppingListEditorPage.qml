import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../../components"
import ".."

NamedPage {
    id: root
    property date selected
    property int id: 0
    name: qsTr("Shopping List")

    Component.onCompleted: {
        if (id > 0) {
            const params = database.shoppingList(id)
            selected = new Date(params.shopping_date)
            name.text = params.name
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
            month: (new Date).getMonth()
            year: (new Date).getFullYear()

            delegate: Rectangle {
                property bool isSelected: model.day === root.selected.getDate() && model.month === root.selected.getMonth()
                width: 15
                height: 30
                color: {
                    if (isSelected) {
                        return "red"
                    }

                    const now = new Date();
                    const today = new Date(now.getFullYear(), now.getMonth(), now.getDate());
                    const targetDate = new Date(model.year, model.month, model.day)

                    if (targetDate < today) {
                        return "lightblue"
                    }

                    return "transparent"
                }

                Text {
                    anchors.centerIn: parent
                    text: model.day
                    color: isSelected ? "white" : "black"
                }
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

            onClicked: {
                if (id > 0) {
                    database.updateShoppingList(id, selected, name.text)
                } else if (selected) {
                    database.insertShoppingList(selected, name.text)
                }

                popPage()
            }
        }
    }
}
