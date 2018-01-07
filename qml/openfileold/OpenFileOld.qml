import QtQuick 2.4
import QtQuick.Controls 1.3
import QtQuick.Controls.Styles 1.3
import QtQuick.Layouts 1.1
import Qt.labs.folderlistmodel 2.1

import "../elements/"
import "../loadfile.js" as Load

Rectangle {

    id: openfile_top

    visible: opacity!=0
    opacity: 0
    onOpacityChanged: {
        if(opacity > 0 && loadThisDirAfterOpen != "") {
            loadCurrentDirectory(loadThisDirAfterOpen)
            loadThisDirAfterOpen = ""
        }
    }

    color: "#88000000"

    width: mainwindow.width
    height: mainwindow.height

    property string currentInFocus: "folders"

    property string items_path: ""
    property string dir_path: settings.openKeepLastLocation ? getanddostuff.getOpenFileLastLocation() : getanddostuff.getHomeDir()

    property var hovered: []


    property bool type_preview: tweaks.isHoverPreviewEnabled

    property string loadThisDirAfterOpen: ""

    property string currentlyLoadedDir: ""

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
    }


    // Bread crumb navigation
    BreadCrumbs {
        id: breadcrumbs
    }

    // Seperating Line
    Rectangle {
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: breadcrumbs.bottom
        height: 1
        color: "white"
    }


    // Main view
    SplitView {

        id: splitview

        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.top: breadcrumbs.bottom
        anchors.bottomMargin: 50
        orientation: Qt.Horizontal

        // The user places at the left
        UserPlaces {
            id: userplaces
            onFocusOnFolders:
                currentInFocus = "folders"
            onFocusOnFilesView:
                currentInFocus = "filesview"
            onMoveOneLevelUp:
                folders.moveOneLevelUp()
        }


        Folders {
            id: folders
            onFocusOnFilesView:
                currentInFocus = "filesview"
            onFocusOnUserPlaces:
                currentInFocus = "userplaces"
        }


        Rectangle {
            Layout.minimumWidth: 200
            Layout.fillWidth: true
            color: "#00000000"

            Rectangle {

                color: "#00000000"

                anchors.fill: parent
                anchors.bottomMargin: edit_rect.height

                FilesView {
                    id: filesview
                    anchors.fill: parent
                }

            }

            Rectangle {
                anchors.left: parent.left
                anchors.right: parent.right
                height: 1
                anchors.top: edit_rect.top
                color: "white"
            }

            EditFiles {

                id: edit_rect
                enabled: false
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.bottom: parent.bottom

                onFilenameEdit:
                    filesview.focusOnFile(filename)
                onAccepted:
                    filesview.loadCurrentlyHighlightedImage()
                onFocusOnNextItem:
                    filesview.focusOnNextItem()
                onFocusOnPrevItem:
                    filesview.focusOnPrevItem()
                onMoveFocusFiveUp:
                    filesview.moveFocusFiveUp()
                onMoveFocusFiveDown:
                    filesview.moveFocusFiveDown()
                onFocusOnFirstItem:
                    filesview.focusOnFirstItem()
                onFocusOnLastItem:
                    filesview.focusOnLastItem()
                onMoveOneLevelUp:
                    folders.moveOneLevelUp()
                onFocusOnFolderView:
                    currentInFocus = "folders"
                onFocusOnUserPlaces:
                    currentInFocus = "userplaces"
                onGoBackHistory:
                    breadcrumbs.goBackInHistory()
                onGoForwardsHistory:
                    breadcrumbs.goForwardsInHistory()
            }

        }

    }

    Rectangle {
        width: parent.width
        anchors.top: splitview.bottom
        height: 1
        color: "white"
    }

    Tweaks {
        id: tweaks
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        height: 50
        onDisplayIcons:
            filesview.displayIcons()
        onDisplayList:
            filesview.displayList()
        onUpdateShowHidden:
            openfile_top.loadCurrentDirectory(openfile_top.currentlyLoadedDir)
    }

    PropertyAnimation {
        id: hideOpenAni
        target: openfile_top
        property: "opacity"
        to: 0
        duration: settings.myWidgetAnimated ? 250 : 0
        onStarted:
            variables.guiBlocked = false
        onStopped:
            edit_rect.enabled = false
    }

    PropertyAnimation {
        id: showOpenAni
        target: openfile_top
        property: "opacity"
        to: 1
        duration: settings.myWidgetAnimated ? 250 : 0
        onStarted: {
            variables.guiBlocked = true
            if(settings.openDefaultView === "list")
                tweaks.displayList()
            else if(settings.openDefaultView === "icons")
                tweaks.displayIcons()
            if(variables.currentFile !== "" && loadThisDirAfterOpen != "") {
                edit_rect.setEditText(variables.currentFile)
                if(variables.currentDir !== currentlyLoadedDir)
                    loadCurrentDirectory(variables.currentDir)
            }
        }
        onStopped: {
            edit_rect.enabled = true
            filesview.focusOnFile(getanddostuff.removePathFromFilename(variables.currentFile))
            openshortcuts.display()
        }
    }


    ShortcutNotifier {
        id: openshortcuts
        area: "openfile"

        onClosed: {
            edit_rect.focusOnInput()
        }

    }

    // Connect to show/hide signals to take appropriate actions
    Connections {
        target: call
        onOpenfileoldShow:
            show();
        onShortcut: {
            if(!openfile_top.visible) return
            if(sh == "Escape")
                hide()
        }
    }


    Component.onCompleted: {

        // We needto do that here, as it seems to be not possible to compose a string in the dict definition
        // (i.e., when defining the property, inside the {})
        //: This is used in the context of the 'Open File' element with its three panes
        openshortcuts.shortcuts[str_keys.get("alt") + " + " + str_keys.get("left") + "/" + str_keys.get("right")] = qsTr("Move focus between Places/Folders/Fileview")
        //: This is used in the context of the 'Open File' element
        openshortcuts.shortcuts[str_keys.get("up") + "/" + str_keys.get("down")] = qsTr("Go up/down an entry")
        //: This is used in the context of the 'Open File' element
        openshortcuts.shortcuts[str_keys.get("page up") + "/" +str_keys.get("page down")] = qsTr("Move 5 entries up/down")
        //: This is used in the context of the 'Open File' element
        openshortcuts.shortcuts[str_keys.get("ctrl") + " + " + str_keys.get("up") + "/" + str_keys.get("down")] = qsTr("Move to the first/last entry")
        //: This is used in the context of the 'Open File' element
        openshortcuts.shortcuts[str_keys.get("alt") + " + " + str_keys.get("up")] = qsTr("Go one folder level up")
        //: This is used in the context of the 'Open File' element
        openshortcuts.shortcuts[str_keys.get("ctrl") + " + B/F"] = qsTr("Go backwards/forwards in history");
        //: This is used in the context of the 'Open File' element
        openshortcuts.shortcuts[str_keys.get("enter") + "/" + str_keys.get("return")] = qsTr("Load the currently highlighted item")
        //: This is used in the context of the 'Open File' element
        openshortcuts.shortcuts[str_keys.get("ctrl") + " + +/-"] = qsTr("Zoom files in/out")
        //: This is used in the context of the 'Open File' element
        openshortcuts.shortcuts[str_keys.get("ctrl") + " + H " + qsTr("or") + " " + str_keys.get("alt") + " + ."] = qsTr("Show/Hide hidden files/folders")
        //: This is used in the context of the 'Open File' element
        openshortcuts.shortcuts[str_keys.get("escape")] = qsTr("Cancel")

        userplaces.loadUserPlaces()
        loadCurrentDirectory(dir_path)

        edit_rect.focusOnInput()

    }

    function show() {
        verboseMessage("OpenFile::show()", opacity + " to 1")
        showOpenAni.start();
    }

    function hide() {

        if(openshortcuts.visible)
            openshortcuts.reject()
        else {
            verboseMessage("OpenFile::hide()", opacity + " to 0")
            hideOpenAni.start();
        }

    }

    function loadCurrentDirectory(path) {

        verboseMessage("OpenFile::loadCurrentDirectory()", path)

        setOverrideCursor()

        currentlyLoadedDir = path

        breadcrumbs.loadDirectory(path)
        folders.loadDirectory(path)
        filesview.loadDirectory(path)

        restoreOverrideCursor()

    }

    function reloadUserPlaces() {
        verboseMessage("OpenFile::reloadUserPlaces()", "")
        userplaces.loadUserPlaces()
    }

    function openFile(filename, filter) {

        Load.loadFile(filename, filter)

    }

}