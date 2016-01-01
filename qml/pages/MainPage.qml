import QtQuick 2.0
import Sailfish.Silica 1.0
import QtQuick.LocalStorage 2.0
import "../js/db.js" as DB
import "../js/functions.js" as Func
import "../components"


Page {
    id: page
    property string active_iconpack: "none" // holds name of active icon pack
    property int active_id: -1 // index of active item, needed for unassigning active property from previously active icon pack

    SilicaFlickable {
        anchors.fill: parent
        contentHeight: column.height

        PullDownMenu {
            MenuItem {
                text: qsTr("Restore")
                signal rejected(string orig) // signal that gets called when user rejects dialog
                onClicked: {
                    DB.open().transaction(function(tx) {
                        var dialog = pageStack.push("Restore.qml"); // pushes Restore dialog
                        var orig = active_iconpack; // sets orig property to old active iconpack for restoring in case user rejected dialog
                        tx.executeSql("UPDATE active_iconpack SET active='none'"); // sets active_iconpack in db to none
                        dialog.accepted.connect(function() { // runs if dialog is accepted
                            if(active_id > -1) { // if id is larger than -1 then there was some active iconpack before this one
                                listview.itemAt(active_id).active = false; // this means that here is the active property of old active iconpack set to false
                            }
                            active_iconpack = "none"; // sets active_iconpack to false for the app
                            active_id = -1; // sets active_id to -1 (which means there's no active icon pack)
                            iconpack.restore(); // calls c++ function that runs original app and restores icon pack
                        });
                        dialog.rejected.connect(function() {
                            rejected(orig); // if rejected, send rejected signal, so this app can set the active iconpack to previously used icon pack
                        });
                    });
                }
                onRejected: { // hanled rejected signal
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

            Label { // this Label is used for info messages, which are Loading at beginning and info that user cannot set icon pack as active, if it is already active
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
                            DB.open().transaction(function(tx) { // works pretty much the same as Restore option in pulldown menu
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

            Timer { // this timer is started if info message is shown and hides the info message after five seconds
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
                    tx.executeSql("CREATE TABLE IF NOT EXISTS active_iconpack (active TEXT)"); // creates table which holds current active iconpack
                    tx.executeSql("CREATE TABLE IF NOT EXISTS firstrun (firstrun INT)"); // creates table which holds whether it's the first time user runs this app
                    var res = tx.executeSql("SELECT * FROM active_iconpack");
                    if(res.rows.length) { // if there is any active icon pack,
                        active_iconpack = res.rows.item(0).active; // assign it to property
                    } else {
                        tx.executeSql("INSERT INTO active_iconpack (active) VALUES ('none')"); // else insert an empty value to the table
                    }

                    var res2 = tx.executeSql("SELECT * FROM firstrun"); // checks if app is run for first time
                    if(!res2.rows.length) { // it's first time running this app
                        tx.executeSql("INSERT INTO firstrun (firstrun) VALUES (1)");
                        iconpack.hideIcon(); // hides icon of original app, so user doesn't have to have two same apps on homescreen
                    }

                    var packs = Func.getIconPacks(); //gets list of icon packs

                    if(packs.length) { // if there are any, hide the text "Loading..."
                        infotext.visible = false;
                    } else { // else show this string
                        infotext.text = qsTr("It looks like you don't have any icon pack installed :(");
                    }

                    for(var i = 0; i < packs.length; i++) { // if there are any texts, add them to lmodel, which is used by Repeater and will show all of the iconpacks as buttons
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


