import QtQuick 2.0
import Sailfish.Silica 1.0
import "../components"

Page {
    id: page
    SilicaFlickable {
        id: flickable
        anchors.fill: parent
        contentHeight: column.height

        Column {
            id: column
            width: parent.width
            PageHeader {
                title: qsTr("About")
            }
            Label {
                x: Theme.paddingLarge
                width: parent.width - 2 * Theme.paddingLarge
                wrapMode: Text.Wrap
                textFormat: Text.RichText
                text: qsTr("This app is a GUI for theme pack support by <b>fravaccaro</b>. The core functionality is implemented by him in separate app - this app just calls the core functions from more user friendly interface. If you have problems with core funcionality (fonts or icons not applying etc.), contact him via button below.<br><br>If you have problem with the GUI, you can contact me in comments on OpenRepos (via button below).")
            }

            Placeholder { }

            Button {
                x: Theme.paddingLarge
                width: parent.width - 2 * Theme.paddingLarge
                text: qsTr("Contact fravaccaro")
                onClicked: {
                    Qt.openUrlExternally("https://openrepos.net/content/fravaccaro/theme-pack-support-sailfish-os")
                }
            }

            Placeholder { }

            Button {
                y: Theme.paddingLarge
                x: Theme.paddingLarge
                width: parent.width - 2 * Theme.paddingLarge
                text: qsTr("Contact me")
                onClicked: {
                    Qt.openUrlExternally("https://openrepos.net/content/rikudousennin/gui-theme-pack-support-sailfish-os")
                }
            }

            PageHeader {
                title: qsTr("Translators")
            }
            Label {
                x: Theme.paddingLarge
                width: parent.width - Theme.paddingLarge * 2
                wrapMode: Text.Wrap
                text: qsTr("Swedish")+": eson\n"+qsTr("Finnish")+": Vivaldo\n"+qsTr("Czech")+": Rikudou_Sennin"
            }

            Placeholder { }
        }
    }
}
