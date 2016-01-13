import QtQuick 2.0
import Sailfish.Silica 1.0
import QtQuick.LocalStorage 2.0
import "../js/db.js" as DB
import "../js/functions.js" as Func
import "../components"
import "../js/console.js" as Console


Page {
    id: page
    property string active_iconpack: "none" // holds name of active icon pack
    property string active_fontpack: "none"
    property int active_id: -1 // index of active item, needed for unassigning active property from previously active icon pack
    property int active_id_fonts: -1
    property var labels

    SilicaFlickable {
        anchors.fill: parent
        contentHeight: column.height

        PullDownMenu {

            MenuItem {
                text: qsTr("About")
                onClicked: {
                    pageStack.push("About.qml");
                }
            }

            MenuItem {
                text: qsTr("Restore")
                enabled: active_iconpack != "none" || active_fontpack != "none"
                signal accepted(string type)
                onClicked: {
                    var dialog = pageStack.push("Restore.qml",{icons_active: active_id > -1, fonts_active: active_id_fonts > -1}); // pushes Restore dialog
                    dialog.accepted.connect(function() { // runs if dialog is accepted
                        console.log(!dialog.fonts && !dialog.icons);
                        console.log(dialog.fonts);
                        console.log(dialog.icons);
                        if(!dialog.fonts && !dialog.icons) {
                            return false;
                        }
                        if(active_id > -1) { // if id is larger than -1 then there was some active iconpack before this one
                            listview.itemAt(active_id).active = false; // this means that here is the active property of old active iconpack set to false
                        }
                        if(active_id_fonts > -1) {
                            listview.itemAt(active_id_fonts).active = false;
                        }

                        active_iconpack = "none"; // sets active_iconpack to false for the app
                        active_fontpack = "none";
                        active_id = -1; // sets active_id to -1 (which means there's no active icon pack)
                        active_id_fonts = -1;
                        iconpack.restore(dialog.icons,dialog.fonts);
                        var type;
                        if(dialog.fonts && dialog.icons) {
                            type = "both";
                        } else if(dialog.icons) {
                            type = "icons";
                        } else if(dialog.fonts) {
                            type = "fonts";
                        }
                        accepted(type);
                    });
                }
                onAccepted: {
                    DB.open().transaction(function(tx){
                        if(type == "both") {
                            tx.executeSql("UPDATE active_iconpack SET active='none'");
                        } else {
                            tx.executeSql("UPDATE active_iconpack SET active='none' WHERE type='"+type+"'");
                        }

                        iconpack.restart_homescreen();
                    });
                }
            }
        }

        Column {
            id: column
            width: page.width
            spacing: Theme.paddingLarge

            PageHeader {
                title: qsTr("Themes")
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
                    signal accepted(string type, string text)
                    text: iconpack.getName(m_text)
                    active: m_active
                    onClicked: {
                        infotext.visible = false;
                        if(!active || true) {
                            var opts = {
                                iconpack: m_text
                            };

                            if(active_id == m_index) {
                                opts.input_icons = false;
                            }

                            if(active_id_fonts == m_index) {
                                opts.input_fonts = false;
                            }

                            var dialog = pageStack.push("Confirm.qml",opts);
                            dialog.accepted.connect(function() {
                                if(!dialog.fonts && !dialog.icons) {
                                    return false;
                                }

                                if(active_id > -1) {
                                    listview.itemAt(active_id).active = false;
                                }
                                if(active_id_fonts > -1) {
                                    listview.itemAt(active_id_fonts).active = false;
                                }

                                var homescreen = false;
                                if(dialog.icons || dialog.fonts) {
                                    active = true;
                                }

                                if(dialog.icons) {

                                    active_iconpack = m_text;
                                    active_id = m_index;

                                    iconpack.apply_icons(m_text, homescreen);
                                }
                                if(dialog.fonts) {
                                    active_fontpack = m_text;
                                    active_id_fonts = m_index;
                                    var font = {};
                                    font.android = dialog.font_active_android;
                                    font.android_light = dialog.font_active_android_light;
                                    font.sailfish = dialog.font_active_sailfish;
                                    font.sailfish_light = dialog.font_active_sailfish_light;

                                    Console.log(font);

                                    console.log("Fonts applying, "+(homescreen?"restarting homescreen":"not restarting homescreen"));

                                    iconpack.apply_fonts(m_text, font.android, font.android_light, font.sailfish, font.sailfish_light);
                                }

                                var type = "";
                                if(dialog.fonts && dialog.icons) {
                                    type = "both";
                                } else if(dialog.icons) {
                                    type = "icons";
                                } else if(dialog.fonts) {
                                    type = "fonts";
                                }
                                console.log("Type: "+type);
                                accepted(type, m_text);
                            });
                        } else {
                            infotext.text = qsTr("This icon pack is already active.");
                            infotext.visible = true;
                            hideinfotext.running = true;
                        }
                    }
                    Component.onCompleted: {
                        if(active_id == m_index || active_id_fonts == m_index) {
                            text += " (";

                            if(active_id == m_index && active_id_fonts == m_index) {
                                text += labels.icons + " & "+labels.fonts
                            } else if(active_id == m_index) {
                                text += labels.icons;
                            } else if(active_id_fonts == m_index) {
                                text += labels.fonts;
                            }

                            text += ")";
                        }
                    }

                    onAccepted: {
                        DB.open().transaction(function(tx){
                            if(type == "both") {
                                tx.executeSql("UPDATE active_iconpack SET active='"+text+"'");
                            } else {
                                tx.executeSql("UPDATE active_iconpack SET active='"+text+"' WHERE type='"+type+"'");
                            }

                            iconpack.restart_homescreen();
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
                labels = {};
                labels.icons = qsTr("icons");
                labels.fonts = qsTr("fonts");
                DB.open().transaction(function(tx) {
                    tx.executeSql("CREATE TABLE IF NOT EXISTS active_iconpack (active TEXT, type TEXT)"); // creates table which holds current active iconpack
                    tx.executeSql("CREATE TABLE IF NOT EXISTS firstrun (firstrun INT)"); // creates table which holds whether it's the first time user runs this app
                    var res = tx.executeSql("SELECT * FROM active_iconpack");
                    if(res.rows.length) { // if there is any active icon pack,
                        if(res.rows.length < 2) {
                            var t = res.rows.item(0).type;
                            var v = res.rows.item(0).active;
                            if(t == "icons" || t == "") {
                                active_iconpack = v;
                            } else if(t == "fonts") {
                                active_fontpack = v;
                            } else if(t == "both") {
                                active_fontpack = v;
                                active_iconpack = v;
                            }
                        } else {
                            for(var i = 0; i < res.rows.length; i++) {
                                var t = res.rows.item(i).type;
                                var v = res.rows.item(i).active;
                                if(t == "fonts") {
                                    active_fontpack = v;
                                } else if(t == "icons" || t == "") {
                                    active_iconpack = v;
                                }
                            }
                        }
                    } else {
                        tx.executeSql("INSERT INTO active_iconpack (active,type) VALUES ('none','fonts')"); // else insert an empty value to the table
                        tx.executeSql("INSERT INTO active_iconpack (active,type) VALUES ('none','icons')");
                    }

                    var res2 = tx.executeSql("SELECT * FROM firstrun"); // checks if app is run for first time
                    if(res2.rows.length < 4) { // it's first time running this app
                        if(!res2.rows.length) { // first run
                            tx.executeSql("INSERT INTO firstrun (firstrun) VALUES (1)");
                        }
                        if(res2.rows.length < 2) { // hides icon
                            tx.executeSql("INSERT INTO firstrun (firstrun) VALUES (2)");
                            iconpack.hideIcon(); // hides icon of original app, so user doesn't have to have two same apps on homescreen
                        }

                        if(res2.rows.length < 3) { // alters table to include multiple values
                            var r = tx.executeSql("PRAGMA table_info(active_iconpack)");
                            if(typeof r.rows.item(1) == "undefined") {
                                tx.executeSql("ALTER TABLE active_iconpack ADD type TEXT");
                            }
                            tx.executeSql("INSERT INTO firstrun (firstrun) VALUES (3)");
                        }

                        if(res2.rows.length < 4) {
                            if(res.rows.length) {
                                var t = res.rows.item(0).type;
                                console.log(t);
                                if(typeof t == "undefined") {
                                    console.log("assigned empty type");
                                    t = "";
                                }

                                if(t == "") {
                                    tx.executeSql("UPDATE active_iconpack SET type='icons'");
                                }

                                t = t == "icons" || t == ""?"fonts":"icons";
                                console.log(t);
                                tx.executeSql("INSERT INTO active_iconpack (active,type) VALUES ('none','"+t+"')");
                            }
                            tx.executeSql("INSERT INTO firstrun (firstrun) VALUES (4)");
                        }
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
                        if(packs[i] == active_fontpack) {
                            active_id_fonts = i;
                            active = true;
                        }

                        lmodel.append({m_text: packs[i], m_active: active, m_index: i});
                    }
                });
            }
        }
    }
}


