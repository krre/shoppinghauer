import QtQuick 2.15
import "../../components"
import ".."

NamedPage {
    id: root
    name: qsTr("Products")

    toolBar: Row {
        PlusToolButton {}
    }
}
