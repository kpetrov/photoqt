
function analyseEvent(event) {

    var combostring = getModifiers(event)

    if(event.key == Qt.Key_Escape)
        combostring += "Escape"
    else if(event.key == Qt.Key_Right)
        combostring += "Right"
    else if(event.key == Qt.Key_Left)
        combostring += "Left"
    else if(event.key == Qt.Key_Up)
        combostring += "Up"
    else if(event.key == Qt.Key_Down)
        combostring += "Down"
    else if(event.key == Qt.Key_Space)
        combostring += "Space"
    else if(event.key == Qt.Key_Delete)
        combostring += "Delete"
    else if(event.key == Qt.Key_Home)
        combostring += "Home"
    else if(event.key == Qt.Key_End)
        combostring += "End"
    else if(event.key == Qt.Key_PageUp)
        combostring += "Page Up"
    else if(event.key == Qt.Key_PageDown)
        combostring += "Page Down"
    else if(event.key == Qt.Key_Insert)
        combostring += "Insert"
    else if(event.key == Qt.Key_Tab || event.key == Qt.Key_Backtab)
        combostring += "Tab"
    else if(event.key == Qt.Key_Return)
        combostring += "Return"
    else if(event.key == Qt.Key_Enter)
        combostring += "Enter"
    else if(event.key < 10000000)
        combostring += shortcutshandler.convertKeycodeToString(event.key)

    return combostring

}

function getModifiers(event) {

    var modstring = ""

    if(event.modifiers & Qt.ControlModifier)
        modstring += "Ctrl+"
    if(event.modifiers & Qt.AltModifier)
        modstring += "Alt+"
    if(event.modifiers & Qt.ShiftModifier)
        modstring += "Shift+"
    if(event.modifiers & Qt.MetaModifier)
        modstring += "Meta+"
    if(event.modifiers & Qt.KeypadModifier)
        modstring += "Keypad+"

    return modstring

}