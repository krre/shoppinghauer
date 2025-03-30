import QtQuick

Window {
    width: 400
    height: 770
    visible: true
    title: qsTr("Shoppinghauer")

    Component.onCompleted: {
        x = (Screen.desktopAvailableWidth - width) / 2
        y = (Screen.desktopAvailableHeight - height) / 2
    }
}
