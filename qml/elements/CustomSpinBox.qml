import QtQuick 2.4
import QtQuick.Controls 1.3
import QtQuick.Controls.Styles 1.3

SpinBox {

    id: ele_top

    signal ctrlTab()
    signal ctrlShiftTab()

    signal accepted()
    signal rejected()

    font.pixelSize: height/2
    menu: null
    enabled: visible

    style: SpinBoxStyle{
        background: Rectangle {
            implicitWidth: 50
            implicitHeight: 25
            color: control.enabled ? colour.element_bg_color : colour.element_bg_color_disabled
            Behavior on color { ColorAnimation { duration: 150; } }
            border.color: control.enabled ? colour.element_border_color : colour.element_border_color_disabled
            Behavior on border.color { ColorAnimation { duration: 150; } }
            radius: variables.global_item_radius
        }
        textColor: control.enabled ? colour.text : colour.text_disabled
        Behavior on textColor { ColorAnimation { duration: 150; } }

        selectionColor: control.enabled ? colour.text_selection_color : colour.text_selection_color_disabled
        Behavior on selectionColor { ColorAnimation { duration: 150; } }

        selectedTextColor: colour.text_selected
        decrementControl: Text {
            color: control.enabled ? colour.text : colour.text_disabled
            Behavior on color { ColorAnimation { duration: 150; } }
            y: -height/3
            x: -2
            font.pixelSize: control.height*2/3
            text: "-"
        }
        incrementControl: Text {
            color: control.enabled ? colour.text : colour.text_disabled
            Behavior on color { ColorAnimation { duration: 150; } }
            y: -height/3
            x: width/25
            font.pixelSize: control.height*2/3
            text: "+"
        }

    }

    ToolTip {
        hoverEnabled: true
        text: parent.value + "" + parent.suffix
        cursorShape: Qt.IBeamCursor
        propagateComposedEvents: true
        onPressed: {
            mouse.accepted = false
            variables.textEntryRequired = true
        }
        onReleased: mouse.accepted = false
    }

    onVisibleChanged: {
        if(variables.textEntryRequired && !visible)
            variables.textEntryRequired = false;
    }

    Keys.onPressed: {

        shortcuts.analyseKeyEvent(event)

        if(event.key == Qt.Key_Tab || event.key == Qt.Key_Backtab) {
            if(event.key === Qt.Key_Enter || event.key === Qt.Key_Return) {

                ele_top.accepted()
                event.accepted = true

            } else if(event.key === Qt.Key_Escape) {

                ele_top.rejected()
                event.accepted = true

            } else if(event.modifiers & Qt.ControlModifier && event.modifiers & Qt.ShiftModifier) {
                ele_top.ctrlShiftTab()
                event.accepted = true
            } else if(event.modifiers & Qt.ControlModifier) {
                ele_top.ctrlTab()
                event.accepted = true
            }
        }

    }

}
