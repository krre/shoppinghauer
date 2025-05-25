function today() {
    const now = new Date();
    return new Date(now.getFullYear(), now.getMonth(), now.getDate());
}

function shoppingName(name) {
    return name || qsTr("Noname")
}
