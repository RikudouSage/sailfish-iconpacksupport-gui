import QtQuick 2.0
import Sailfish.Silica 1.0

Item {
    width: parent.width
    height: label.height
    property alias text: label.text
    Label {
        Placeholder { height: 50; }
        id: label
        x: Theme.paddingLarge
        width: parent.width - 2 * Theme.paddingLarge
        font.pixelSize: Theme.fontSizeMedium
        font.bold: true
        color: Theme.highlightColor
    }
}
