import QtQuick 2.0
import Sailfish.Silica 1.0
import QtQuick.LocalStorage 2.0
import "../js/db.js" as DB
import "../js/functions.js" as Func
import "../components"

Dialog {
    id: page
    property string iconpack
    SilicaFlickable {
        id: flickable
        anchors.fill: parent
        contentHeight: column.height
        width: parent.width
        Column {
            id: column
            width: parent.width
            DialogHeader {
                acceptText: qsTr("Yes")
                cancelText: qsTr("No")
            }
            Label {
                width: parent.width - Theme.paddingLarge * 2
                x: Theme.paddingLarge
                text: qsTr("Do you want to restore icon pack?<br>If you restore, the app may stop responding for a while and your homescreen will be restarted, which will result in closing all of your open apps.")
                textFormat: Text.RichText
                wrapMode: Text.Wrap
            }
        }
    }
}
