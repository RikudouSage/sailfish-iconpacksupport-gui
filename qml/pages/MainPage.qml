import QtQuick 2.0
import Sailfish.Silica 1.0
import QtQuick.LocalStorage 2.0
import "../js/db.js" as DB
import "../js/functions.js" as Func
import "../components"


Page {
    id: page
    property string active_iconpack: "none"
    property int active_id: -1

    SilicaFlickable {
        anchors.fill: parent
        contentHeight: column.height

        PullDownMenu {
            MenuItem {
                text: qsTr("Restore")
                signal rejected(string orig)
                onClicked: {
                    DB.open().transaction(function(tx) {
                        var dialog = pageStack.push("Restore.qml");
                        var orig = active_iconpack;
                        tx.executeSql("UPDATE active_iconpack SET active='none'");
                        dialog.accepted.connect(function() {
                            if(active_id > -1) {
                                listview.itemAt(active_id).active = false;
                            }
                            active_iconpack = "none";
                            active_id = -1;
                            iconpack.restore();
                        });
                        dialog.rejected.connect(function() {
                            rejected(orig);
                        });
                    });
                }
                onRejected: {
                    DB.open().transaction(function(tx) {
                        tx.executeSql("UPDATE active_iconpack SET active='"+orig+"'");
                    });

                }
            }
        }

        Column {
            id: column
            width: page.width
            spacing: Theme.paddingLarge

            PageHeader {
                title: qsTr("Icon pack support")
                //title: iconpack.whoami()
            }

            ListModel {
                id: lmodel
            }

            Label {
                id: infotext
                text: qsTr("Loading...")
                x: Theme.paddingLarge
                width: page.width - Theme.paddingLarge * 2
                wrapMode: Text.Wrap
            }

            Repeater {
                id: listview
                model: lmodel
                Button {
                    width: page.width - 2 * Theme.paddingLarge
                    x: Theme.paddingLarge
                    signal rejected(string orig)
                    text: m_text
                    active: m_active
                    onClicked: {
                        infotext.visible = false;
                        if(!active) {
                            DB.open().transaction(function(tx) {
                                var dialog = pageStack.push("Confirm.qml",{iconpack: m_text});
                                var orig = active_iconpack;
                                tx.executeSql("UPDATE active_iconpack SET active='"+m_text+"'");
                                dialog.accepted.connect(function() {

                                    if(active_id > -1) {
                                        listview.itemAt(active_id).active = false;
                                    }
                                    active = true;
                                    active_iconpack = m_text;
                                    active_id = m_index;
                                    iconpack.apply(m_text);
                                });
                            });
                        } else {
                            infotext.text = qsTr("This icon pack is already active.");
                            infotext.visible = true;
                            hideinfotext.running = true;
                        }
                    }
                    onRejected: {
                        DB.open().transaction(function(tx) {
                            tx.executeSql("UPDATE active_iconpack SET active='"+orig+"'");
                        });
                    }
                }
            }

            Timer {
                id: hideinfotext
                running: false
                interval: 5000
                onTriggered: {
                    hideinfotext.running = false;
                    infotext.visible = false;
                }
            }

            Component.onCompleted: {
                DB.open().transaction(function(tx) {
                    tx.executeSql("CREATE TABLE IF NOT EXISTS active_iconpack (active TEXT)");
                    tx.executeSql("CREATE TABLE IF NOT EXISTS firstrun (firstrun INT)");
                    var res = tx.executeSql("SELECT * FROM active_iconpack");
                    if(res.rows.length) {
                        active_iconpack = res.rows.item(0).active;
                    } else {
                        tx.executeSql("INSERT INTO active_iconpack (active) VALUES ('none')");
                    }

                    var res2 = tx.executeSql("SELECT * FROM firstrun");
                    if(!res2.rows.length) { // it's first time running this app
                        tx.executeSql("INSERT INTO firstrun (firstrun) VALUES (1)");
                        iconpack.hideIcon();
                    }

                    var packs = Func.getIconPacks();

                    if(packs.length) {
                        infotext.visible = false;
                    } else {
                        infotext.text = qsTr("It looks like you don't have any icon pack installed :(");
                    }

                    for(var i = 0; i < packs.length; i++) {
                        var active = false;
                        if(packs[i] == active_iconpack) {
                            active_id = i;
                            active = true;
                        }

                        lmodel.append({m_text: packs[i], m_active: active, m_index: i});
                    }
                });
            }
        }
    }
}


