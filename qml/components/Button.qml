import QtQuick 2.0
import Sailfish.Silica 1.0
import Sailfish.Silica.private 1.0

MouseArea {
    id: button

    property bool down: pressed && containsMouse && !DragFilter.canceled
    property alias text: buttonText.text
    property bool _showPress: down || pressTimer.running
    property color color: Theme.primaryColor
    property color highlightColor: Theme.highlightColor
    property color highlightBackgroundColor: Theme.highlightBackgroundColor
    property real preferredWidth: Theme.buttonWidthSmall
    property bool active: false

    onPressedChanged: {
        if (pressed) {
            pressTimer.start()
        }
    }
    onCanceled: {
        button.DragFilter.end()
        pressTimer.stop()
    }
    onActiveChanged: {
        if(active) {
            rect.color = Theme.rgba(button.highlightBackgroundColor,0.5);
        } else {
            rect.color = _showPress ? Theme.rgba(button.highlightBackgroundColor, Theme.highlightBackgroundOpacity) : Theme.rgba(button.color, 0.2);
        }
    }

    onPressed: button.DragFilter.begin(mouse.x, mouse.y)
    onPreventStealingChanged: if (preventStealing) button.DragFilter.end()

    height: Theme.itemSizeExtraSmall
    implicitWidth: Math.max(preferredWidth, buttonText.width+Theme.paddingMedium)

    Rectangle {
        id: rect
        anchors {
            fill: parent
            topMargin: (button.height-Theme.itemSizeExtraSmall)/2
            bottomMargin: anchors.topMargin
        }
        radius: Theme.paddingSmall
        color: _showPress ? Theme.rgba(button.highlightBackgroundColor, Theme.highlightBackgroundOpacity)
                          : Theme.rgba(button.color, 0.2)

        opacity: button.enabled ? 1.0 : 0.4

        Label {
            id: buttonText
            anchors.centerIn: parent
            color: _showPress ? button.highlightColor : button.color
        }
        Component.onCompleted: {
            if(active) {
                rect.color = Theme.rgba(button.highlightBackgroundColor,0.5);
            }
        }
    }

    Timer {
        id: pressTimer
        interval: 64
    }
}
