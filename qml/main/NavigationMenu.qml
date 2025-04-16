import QtQuick
import QtQuick.Controls
import "../pages/shoppings"

Drawer {
    id: root

    Column {
        anchors.fill: parent

        ItemDelegate {
            width: parent.width
            text: qsTr("Shoppings")
            onClicked: {
                stackView.clear()
                stackView.push(shoppingsPageComp)
                root.close()
                root.close()
            }
        }

        ItemDelegate {
            width: parent.width
            text: qsTr("Exit")

            action: Action {
                shortcut: "Ctrl+Q"
                onTriggered: Qt.quit()
            }
        }
    }

    Component {
        id: shoppingsPageComp
        ShoppingsPage {}
    }
}
