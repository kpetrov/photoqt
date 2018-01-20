import QtQuick 2.5
import "handlestuff.js" as Handle

Item {

    property string currentDirectory: ""
    onCurrentDirectoryChanged: {
        if(getanddostuff.doesThisExist(currentDirectory)) {
            Handle.loadDirectory()
            watcher.setCurrentDirectoryForChecking(currentDirectory)
            getanddostuff.setOpenFileLastLocation(openvariables.currentDirectory)
        } else
            currentDirectory = getanddostuff.getHomeDir()
    }

    property string currentFocusOn: "filesview"

    property int historypos: -1
    property var history: []
    property bool loadedFromHistory: false

    property var currentDirectoryFolders: []
    property var currentDirectoryFiles: []

    property int filesFileTypeSelection: 0
    onFilesFileTypeSelectionChanged:
        Handle.loadDirectoryFiles()

    property bool highlightingFromUserInput: false
    property bool textEditedFromHighlighting: false

    Component.onCompleted: {
    // We HAVE TO break the binding, otherwise switching off the openKeepLastLocation setting before navigating to any other folder will reset the loaded folder to home folder
        currentDirectory = currentDirectory
        currentFocusOn = "filesview"
    }

}
