import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../../components"
import "../../components/style/style.js" as Style
import "../../components/utils.js" as Utils
import ".."

NamedPage {
    id: root
    property date selectedDate: {
        if (id > 0) {
            const params = database.shoppingList(id)
            name.text = params.name
            return new Date(params.shopping_date)
        } else {
            return Utils.today()
        }
    }

    Component.onCompleted: {
        const index = calendarModel.indexOf(selectedDate.getFullYear(), selectedDate.getMonth())
        listView.positionViewAtIndex(index, ListView.Visible)
        listView.currentIndex = index
    }

    property int id: 0
    name: qsTr("Shopping List")

    Loader {
        id: delegateLoader
        sourceComponent: delegateComponent
        visible: false
    }

    Component {
        id: delegateComponent

        Column {
            width: listView.width

            Label {
                anchors.horizontalCenter: parent.horizontalCenter
                font.bold: true
                text: grid.title
            }

            DayOfWeekRow {
                width: parent.width
                locale: grid.locale

                delegate: Label {
                    text: shortName
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter

                    required property string shortName
                }

            }

            MonthGrid {
                id: grid
                width: parent.width
                month: model ? model.month : 0
                year: model ? model.year : 0

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

                    Label {
                        anchors.centerIn: parent
                        text: model.day
                        color: isSelected ? "white" : Material.foreground
                    }
                }

                onClicked: (date) => selectedDate = date
            }
        }
    }

    ColumnLayout {
        width: parent.width
        spacing: 10

        ListView {
            id: listView
            property int delegateHeight: 0
            Layout.fillWidth: true
            Layout.preferredHeight: delegateLoader.item ? delegateLoader.item.implicitHeight : 100
            snapMode: ListView.SnapOneItem
            orientation: ListView.Horizontal
            highlightRangeMode: ListView.StrictlyEnforceRange

            model: CalendarModel {
                id: calendarModel

                from: {
                    const date = new Date()
                    date.setMonth(date.getMonth() - 6)
                    return date
                }

                to: {
                    const date = new Date()
                    date.setMonth(date.getMonth() + 6)
                    return date
                }
            }

            delegate: delegateComponent
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
