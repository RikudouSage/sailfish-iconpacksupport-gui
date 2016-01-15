import QtQuick 2.0
import Sailfish.Silica 1.0
import QtQuick.LocalStorage 2.0
import "../js/db.js" as DB
import "../js/functions.js" as Func
import "../components"
import "../js/console.js" as Console

Dialog {
    property var removed
    property string icons
    property string fonts
    id: page
    SilicaFlickable {
        id: flickable
        width: parent.width
        contentHeight: column.height
        Column {
            id: column
            width: parent.width
            DialogHeader {
                acceptText: qsTr("Uninstall")
                cancelText: qsTr("Cancel")
            }

            ListModel {
                id: lmodel
            }

            Repeater {
                model: lmodel
                IconTextSwitch {
                    automaticCheck: true
                    text: m_label
                    checked: false
                    visible: !m_active
                    onClicked: {
                        if(checked) {
                            removed.push(m_index);
                        } else {
                            var i = removed.indexOf(m_index);
                            removed.splice(i,1);
                        }
                        Console.log(removed);
                    }
                    Component.onCompleted: {
                        Console.log("Completed");
                    }
                }
            }
        }
    }
    Component.onCompleted: {
        removed = [];
        var packs = Func.getIconPacks();
        for(var i in packs) {
            var active = false;
            if(packs[i] == icons) {
                active = true;
            }
            if(packs[i] == fonts) {
                active = true;
            }

            lmodel.append({m_text: packs[i], m_active: active, m_index: i, m_label: ip.getName(packs[i])});
        }
    }
}
