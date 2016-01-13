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
    property var fonts: capabilities.fonts
    property bool icons: capabilities.icons
    property string font_active_sailfish
    property string font_active_sailfish_light
    property string font_active_android
    property string font_active_android_light

    // these properties are handed from MainPage, at default state they copy the capabilities, but when changed, they overwrite capabilities
    property bool input_fonts: capabilities.fonts
    property bool input_icons: capabilities.icons
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
                text: qsTr("Do you want to apply <b>%1</b> theme pack?<br>If you apply it, the app may stop responding for a while and your homescreen will be restarted, which will result in closing all of your open apps.").arg(name)
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

            Column {
                id: fontsettings
                width: parent.width
                visible: include_fonts.checked && include_fonts.enabled

                Placeholder { }

                PageHeader {
                    title: qsTr("Font options")
                }

                ListModel { // weight model, sailfish
                    id: wmodels
                }

                ListModel { // weight model, sailfish light
                    id: wmodelsl
                }

                ListModel { // weight model, android
                    id: wmodela
                }

                ListModel { // weight model, android light
                    id: wmodelal
                }

                FLabel {
                    text: qsTr("Sailfish regular font weight")
                }
                Repeater {
                    id: views
                    model: wmodels
                    IconTextSwitch {
                        automaticCheck: true
                        text: w_name
                        checked: w_checked
                        onClicked: {
                            var count = wmodels.count;
                            for(var i = 0; i < count; i++) {
                                views.itemAt(i).checked = false;
                            }
                            checked = true;
                            font_active_sailfish = text;
                        }
                    }
                }

                Placeholder { }
                FLabel {
                    text: qsTr("Sailfish light font weight")
                }
                Repeater {
                    id: viewsl
                    model: wmodelsl
                    IconTextSwitch {
                        automaticCheck: true
                        text: w_name
                        checked: w_checked
                        onClicked: {
                            var count = wmodelsl.count;
                            for(var i = 0; i < count; i++) {
                                viewsl.itemAt(i).checked = false;
                            }
                            checked = true;
                            font_active_sailfish_light = text;
                        }
                    }
                }

                Placeholder { }
                FLabel {
                    text: qsTr("Android regular font weight")
                }
                Repeater {
                    id: viewa
                    model: wmodela
                    IconTextSwitch {
                        automaticCheck: true
                        text: w_name
                        checked: w_checked
                        onClicked: {
                            var count = wmodela.count;
                            for(var i = 0; i < count; i++) {
                                viewa.itemAt(i).checked = false;
                            }
                            checked = true;
                            font_active_android = text;
                        }
                    }
                }

                Placeholder { }
                FLabel {
                    text: qsTr("Android light font weight")
                }
                Repeater {
                    id: viewal
                    model: wmodelal
                    IconTextSwitch {
                        automaticCheck: true
                        text: w_name
                        checked: w_checked
                        onClicked: {
                            var count = wmodelal.count;
                            for(var i = 0; i < count; i++) {
                                viewal.itemAt(i).checked = false;
                            }
                            checked = true;
                            font_active_android_light = text;
                        }
                    }
                }

                Placeholder { }

                Component.onCompleted:  {
                    var weights = Func.getWeights();
                    for(var i in weights) {
                        var w_checked = i == 0;
                        var w_name = weights[i];
                        if(i == 0) {
                            font_active_android = w_name;
                            font_active_android_light = w_name;
                            font_active_sailfish = w_name;
                            font_active_sailfish_light = w_name;
                        }

                        wmodela.append({w_checked: w_checked, w_name: w_name});
                        wmodelal.append({w_checked: w_checked, w_name: w_name});
                        wmodels.append({w_checked: w_checked, w_name: w_name});
                        wmodelsl.append({w_checked: w_checked, w_name: w_name});
                    }
                }
            }

            Component.onCompleted: {

                if(capabilities.fonts != input_fonts) {
                    console.log("Fonts capabilities changed");
                    capabilities.fonts = input_fonts;
                    include_fonts.enabled = capabilities.fonts;
                }

                if(capabilities.icons != input_icons) {
                    console.log("Icons capabilities changed");
                    capabilities.icons = input_icons;
                    include_icons.enabled = capabilities.icons;
                }

                console.log("Fonts: "+capabilities.fonts);
                console.log("Icons: "+capabilities.icons);

                if(!capabilities.fonts) {
                    fonts = false;
                    include_fonts.checked = false;
                }
                if(!capabilities.icons) {
                    icons = false;
                    include_icons.checked = false;
                }

                if(!include_fonts.checked && !include_icons.checked) {
                    header.acceptText = qsTr("No");
                } else {
                    header.acceptText = qsTr("Yes");
                }
            }
        }
    }
}
