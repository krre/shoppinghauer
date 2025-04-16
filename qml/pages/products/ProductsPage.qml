import QtQuick
import "../../components"
import ".."

NamedPage {
    id: root
    name: qsTr("Products")

    toolBar: Row {
        PlusToolButton {
            onClicked: pushPage(productEditorPageComp)
        }
    }

    Component {
        id: productEditorPageComp
        ProductEditorPage {}
    }
}
