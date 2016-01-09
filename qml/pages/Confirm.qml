import QtQuick 2.0
import Sailfish.Silica 1.0
import QtQuick.LocalStorage 2.0
import "../js/db.js" as DB
import "../js/functions.js" as Func
import "../components"


/*
 This is a dialog, which just tells user what will happen, if user clicks Yes, MainPage.qml handles it and takes action
 */
Dialog {
    id: page
    property string iconpack
    property string name: ip.getName(iconpack)
    property var capabilities: Func.getCapabilities();
    property bool fonts: capabilities.fonts
    property bool icons: capabilities.icons
    SilicaFlickable {
        id: flickable
        anchors.fill: parent
        contentHeight: column.height
        width: parent.width
        Column {
            id: column
            width: parent.width
            DialogHeader {
                id: header
                acceptText: qsTr("Yes")
                cancelText: qsTr("No")
            }
            Label {
                width: parent.width - Theme.paddingLarge * 2
                x: Theme.paddingLarge
                text: qsTr("Do you want to apply <b>%1</b> icon pack?<br>If you apply it, the app may stop responding for a while and your homescreen will be restarted, which will result in closing all of your open apps.").arg(name)
                textFormat: Text.RichText
                wrapMode: Text.Wrap
            }
            IconTextSwitch {
                id: include_icons
                automaticCheck: true
                text: qsTr("Install icons from theme")
                checked: true
                enabled: capabilities.icons
                onClicked: {
                    icons = include_icons.checked
                    if(!include_fonts.checked && !include_icons.checked) {
                        header.acceptText = qsTr("No");
                    } else {
                        header.acceptText = qsTr("Yes");
                    }
                }
            }

            IconTextSwitch {
                id: include_fonts
                automaticCheck: true
                text: qsTr("Install fonts from theme")
                checked: true
                enabled: capabilities.fonts
                onClicked: {
                    fonts = include_fonts.checked
                    if(!include_fonts.checked && !include_icons.checked) {
                        header.acceptText = qsTr("No");
                    } else {
                        header.acceptText = qsTr("Yes");
                    }
                }
            }
            Component.onCompleted: {
                if(!capabilities.fonts) {
                    include_fonts.checked = false;
                }
                if(!capabilities.icons) {
                    include_icons.checked = false;
                }
            }
        }
    }
}
