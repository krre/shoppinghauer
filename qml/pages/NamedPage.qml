import QtQuick
import QtQuick.Controls

Page {
    required property string name
    default property alias data: content.data
    property var toolBar: []

    function pushPage(item, properties, operation) {
        return StackView.view.push(item, properties, operation)
    }

    function popPage() {
        return StackView.view.pop()
    }

    Item {
        id: content
        anchors.fill: parent
        anchors.margins: 10
    }
}
