import QtQuick 2.15
import "../../components"
import ".."

NamedPage {
    id: root
    name: qsTr("Shopping Lists")

    toolBar: Row {
        PlusToolButton {
            onClicked: pushPage(shoppingListEditorPageComp)
        }
    }

    Component {
        id: shoppingListEditorPageComp
        ShoppingListEditorPage {}
    }
}
