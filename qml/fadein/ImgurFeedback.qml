import QtQuick 2.3
import QtQuick.Controls 1.2

import "../elements"

Rectangle {

    id: feedback_top
    anchors.fill: parent
    color: "#88000000"

    property bool someerror: false

    visible: opacity!=0
    opacity: 0
    Behavior on opacity { NumberAnimation { duration: 300; } }
    onOpacityChanged: {
        if(opacity == 1) {
            blurAllBackgroundElements()
            blocked = true
        } else {
            unblurAllBackgroundElements()
            blocked = false
        }
    }

    property int progress: 0
    property bool anonymous: false
    property string accountname: ""

    // Catch all mouse events
    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        acceptedButtons: Qt.LeftButton | Qt.RightButton
    }

    Rectangle {

        opacity: (error.visible||report.visible||obtainingImageUrlDeleteHash.visible) ? 0 : 1
        Behavior on opacity { NumberAnimation { duration: 300; } }
        visible: opacity!=0

        color: "transparent"
        width: parent.width
        height: childrenRect.height

        y: (parent.height-height)/2

        Column {

            spacing: 20

            Text {
                horizontalAlignment: Text.AlignHCenter
                width: feedback_top.width
                wrapMode: Text.WordWrap
                text: "Uploading image to imgur.com" + (anonymous ? " anonymously" : " account '" + accountname + "'")
                color: "white"
                font.pointSize: 40
                font.bold: true
            }

            Text {
                horizontalAlignment: Text.AlignHCenter
                width: feedback_top.width
                wrapMode: Text.WordWrap
                text: getanddostuff.removePathFromFilename(thumbnailBar.currentFile, false)
                color: "white"
                font.pointSize: 30
                font.italic: true
                font.bold: true
            }

            Rectangle {
                color: "transparent"
                width: 1
                height: 1
            }

            CustomProgressBar {
                id: progressbar
                x: (feedback_top.width-width)/2
            }

            CustomButton {
                x: (parent.width-width)/2
                text: "Cancel upload"
                fontsize: 30
                onClickedButton:
                    hide()
            }

        }

    }

    Rectangle {

        id: obtainingImageUrlDeleteHash

        property int code: 0

        opacity: 0
        Behavior on opacity { NumberAnimation { duration: 300; } }
        visible: opacity!=0

        color: "#00000000"
        anchors.fill: parent

        Rectangle {

            color: "transparent"
            width: childrenRect.width
            height: childrenRect.height
            x: (parent.width-width)/2
            y: (parent.height-height)/2

            Column {

                spacing: 10

                Text {
                    id: obtaintext1
                    width: feedback_top.width-200
                    horizontalAlignment: Text.AlignHCenter
                    text: "Obtaining image url"
                    color: "white"
                    font.pointSize: 40
                    font.bold: true
                }

                Text {
                    x: (obtaintext1.width-width)/2
                    property int counter: 0
                    text: counter==0 ? "." :
                         (counter==1 ? ".." :
                         (counter==2 ? "..." :
                         (counter==3 ? "...." :
                         (counter==4 ? "....." :
                         (counter==5 ? "......" :
                         (counter==6 ? "......." :
                         (counter==7 ? "........" :
                         (counter==8 ? "........." :
                         (counter==9 ? ".........." : "..........")))))))))
                    color: "white"
                    font.pointSize: 40
                    font.bold: true
                    Timer {
                        running: obtainingImageUrlDeleteHash.opacity!=0
                        repeat: true
                        interval: 100
                        onTriggered: parent.counter = (parent.counter+1)%10
                    }
                }

                Text {
                    id: obtaintext2
                    width: feedback_top.width-200
                    horizontalAlignment: Text.AlignHCenter
                    text: "Please wait!"
                    color: "white"
                    font.pointSize: 40
                    font.bold: true
                }

                Rectangle {
                    color: "transparent"
                    width: 1
                    height: 10
                }

                CustomButton {
                    x: (parent.width-width)/2
                    text: "I don't want to know it!"
                    fontsize: 25
                    onClickedButton:
                        hide()
                }

            }

        }

    }

    Rectangle {

        id: error

        property int code: 0

        opacity: 0
        Behavior on opacity { NumberAnimation { duration: 300; } }
        visible: opacity!=0

        color: "#00000000"
        anchors.fill: parent

        Rectangle {

            color: "transparent"
            width: parent.width
            height: childrenRect.height
            y: (parent.height-height)/2

            Column {

                spacing: 40

                Text {
                    x: 50
                    width: feedback_top.width-100
                    color: "red"
                    font.pointSize: 40
                    font.bold: true
                    wrapMode: Text.WordWrap
                    text: "An Error occured while uploading image!" + "\n" + "Error code: " + error.code
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }

                CustomButton {
                    x: (parent.width-width)/2
                    text: "Oh, man... Well, go back!"
                    fontsize: 30
                    onClickedButton:
                        hide()
                }
            }
        }
    }

    Rectangle {

        id: report

        opacity: 0
        Behavior on opacity { NumberAnimation { duration: 300; } }
        visible: opacity!=0

        color: "#00000000"
        anchors.fill: parent

        Rectangle {

            color: "transparent"
            width: parent.width
            height: childrenRect.height
            y: (parent.height-height)/2

            Column {

                spacing: 40

                Text {
                    x: 50
                    width: feedback_top.width-100
                    color: "white"
                    font.pointSize: 40
                    wrapMode: Text.WordWrap
                    font.bold: true
                    text: "Image successfully uploaded!"
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }

                Rectangle {

                    color: "transparent"
                    width: childrenRect.width
                    height: childrenRect.height
                    x: (parent.width-width)/2

                    Row {

                        spacing: 10

                        Text {
                            color: "white"
                            font.pointSize: 15
                            font.bold: true
                            text: "Image URL: "
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                        }
                        CustomLineEdit {
                            id: imageurl
                            width: 400
                            text: ""
                        }
                        CustomButton {
                            fontsize: 12
                            y: (parent.height-height)/2
                            text: "visit link"
                            onClickedButton: getanddostuff.openLink(imageurl.text)
                        }

                    }

                }

                Rectangle {

                    color: "transparent"
                    width: childrenRect.width
                    height: childrenRect.height
                    x: (parent.width-width)/2

                    Row {

                        spacing: 10

                        Text {
                            color: "white"
                            font.pointSize: 15
                            font.bold: true
                            text: "Delete URL: "
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                        }
                        CustomLineEdit {
                            id: deleteurl
                            width: 400
                            text: ""
                        }
                        CustomButton {
                            fontsize: 12
                            y: (parent.height-height)/2
                            text: "visit link"
                            onClickedButton: getanddostuff.openLink(deleteurl.text)
                        }

                    }

                }

                CustomButton {
                    x: (parent.width-width)/2
                    text: "Got it!"
                    fontsize: 30
                    onClickedButton:
                        hide()
                }
            }
        }
    }

    Connections {
        target: shareonline_imgur
        onImgurUploadProgress: {
            progressbar.setProgress(perc*100)
            error.opacity = 0
            report.opacity = 0
            obtainingImageUrlDeleteHash.opacity = 0
            if(perc == 1)
                obtainingImageUrlDeleteHash.opacity = 1
        }
        onFinished: {
            error.opacity = 0
            report.opacity = (feedback_top.someerror ? 0 : 1)
            obtainingImageUrlDeleteHash.opacity = 0
        }
        onImgurUploadError: {
            error.code = err
            error.opacity = 1
            report.opacity = 0
            obtainingImageUrlDeleteHash.opacity = 0
            feedback_top.someerror = true
        }

        onImgurImageUrl: {
            imageurl.text = url
            imageurl.selectAll()
            verboseMessage("ImgurFeedback::onImgurImageUrl", url)
        }

        onImgurDeleteHash: {
            deleteurl.text = "http://imgur.com/delete/" + url
            verboseMessage("ImgurFeedback::onImgurDeleteHash", url)
        }

    }

    function show(anonym) {

        anonymous = anonym
        error.opacity = 0
        report.opacity = 0
        obtainingImageUrlDeleteHash.opacity = 0
        feedback_top.someerror = false
        progressbar.setProgress(0)

        if(!anonymous) {
            var ret = shareonline_imgur.authAccount()
            if(ret !== 0) {
                console.log("Imgur authentication failed!!")
                hide()
                return
            }
            accountname = shareonline_imgur.getAccountUsername()
            shareonline_imgur.upload(thumbnailBar.currentFile)
        } else {
            accountname = ""
            shareonline_imgur.anonymousUpload(thumbnailBar.currentFile)
        }
        opacity = 1

    }


    function hide() {
        error.opacity = 0
        report.opacity = 0
        obtainingImageUrlDeleteHash.opacity = 0
        shareonline_imgur.abort()
        opacity = 0
    }

}