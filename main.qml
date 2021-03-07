import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.15
import QtQuick.Dialogs 1.3

import Notes 1.0

Window {
    id: window
    minimumHeight: 700
    minimumWidth: 950
    width: 1280
    height: 720
    visible: true
    title: qsTr("Notes")

    property string id: ""
    property string titleProperty:  ""
    property string descriptionProperty: ""
    property string colorProperty: ""
    property bool isDiffColor: false

    NotesDatabaseModel {
        id: notes
    }

    Button {
        id: addNoteButton
        text: "Criar uma nota..."

        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: 16

        background: Rectangle {
            implicitWidth: 120
            implicitHeight: 40
            radius: 8
            color: "#ddd"
        }

        onPressed: {
            dialog.open()
        }
    }

    Button {
        text: "change view"

        anchors.right: parent.right
        anchors.rightMargin: 16
        anchors.top: parent.top
        anchors.topMargin: 16

        background: Rectangle {
            implicitWidth: 120
            implicitHeight: 40
            radius: 8
            color: "#ddd"
        }

        onPressed: {
            if(gridView.state === "isGridView") {
                gridView.state = "isListView"
            } else {
                gridView.state = "isGridView"
            }
        }
    }

    Dialog {
        id: dialog
        visible: false
        title: "Nova nota"
        width: 500
        height: 330

        contentItem:Column {
            anchors.fill: parent
            spacing: 16
            anchors.topMargin: 16

            TextField {
                id: title
                placeholderText: "Título"
                maximumLength: 50
                width: parent.width * 0.8
                anchors.horizontalCenter: parent.horizontalCenter
            }

            TextField {
                id: description
                placeholderText: "Descrição"
                width: parent.width * 0.8
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Column {
                id: radio
                width: parent.width * 0.8
                anchors.horizontalCenter: parent.horizontalCenter

                RadioButton {
                    id: blue
                    text: "blue"
                }

                RadioButton {
                    id: red
                    text: "red"
                }

                RadioButton {
                    id: yellow
                    text: "yellow"
                }
            }

            Row{
                width: parent.width * 0.8
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: radio.bottom
                anchors.topMargin: 16

                Button {
                    text: "Salvar"
                    enabled: title.text !== "" && description.text !== "" ? true : false
                    anchors.left: parent.left
                    onPressed: {
                        const date = (new Date).toDateString()
                        let color
                        if(blue.checked) color = "blue"
                        else if(red.checked) color = "red"
                        else if(yellow.checked) color = "yellow"
                        else color = "gray"

                        notes.newRow(title.text, description.text, date, color)

                        title.clear()
                        description.clear()
                        dialog.close()
                    }
                }

                Button {
                    text: "Cancelar"
                    anchors.right: parent.right
                    onPressed: {
                        title.clear()
                        description.clear()
                        dialog.close()
                    }
                }
            }
        }
    }

    Dialog {
        id: edit
        visible: false
        title: "Nova nota"
        width: 500
        height: 330



        contentItem: Column {
            anchors.fill: parent
            spacing: 16
            anchors.topMargin: 16

            TextField {
                id: titleEdit
                placeholderText: "Título"
                maximumLength: 50
                width: parent.width * 0.8
                anchors.horizontalCenter: parent.horizontalCenter
            }

            TextField {
                id: descriptionEdit
                placeholderText: "Descrição"
                width: parent.width * 0.8
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Column {
                id: radioEdit
                width: parent.width * 0.8
                anchors.horizontalCenter: parent.horizontalCenter

                RadioButton {
                    id: blueEdit
                    text: "blue"
                }

                RadioButton {
                    id: redEdit
                    text: "red"
                }

                RadioButton {
                    id: yellowEdit
                    text: "yellow"
                }
            }

            Row {

                width: parent.width * 0.8
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: radioEdit.bottom
                anchors.topMargin: 16

                Button {
                    text: "Deletar"
                    anchors.left: parent.left
                    onPressed: {

                        notes.deleteRow(id)
                        edit.close()

                    }
                }

                Button {
                    text: "Fechar"
                    anchors.right: parent.right
                    onPressed: {

                        if(blueEdit.checked && (colorProperty !== "blue")) isDiffColor = true
                        else if(redEdit.checked && (colorProperty !== "red")) isDiffColor = true
                        else if(yellowEdit.checked && (colorProperty !== "yellow")) isDiffColor = true
                        else isDiffColor = false

                        const date = (new Date).toDateString()
                        let color
                        if(blueEdit.checked) color = "blue"
                        else if(redEdit.checked) color = "red"
                        else if(yellowEdit.checked) color = "yellow"
                        else color = "gray"

                        if((titleProperty !== titleEdit.text) || descriptionProperty !== descriptionEdit.text || isDiffColor){
                            notes.updateRow(id, titleEdit.text, descriptionEdit.text, date, color)

                            console.log(id, titleEdit.text, descriptionEdit.text, date, color)
                        }

                        edit.close()
                    }
                }
            }

        }
    }

    GridView {
        id: gridView

        visible: true
        state: "isGridView"
        states: [
            State {
                name: "isGridView"
                PropertyChanges {
                    target: gridView
                    visible: true
                }

                PropertyChanges {
                    target: listView
                    visible: false
                }
            },

            State {
                name: "isListView"
                PropertyChanges {
                    target: gridView
                    visible: false
                }

                PropertyChanges {
                    target: listView
                    visible: true
                }
            }

        ]

        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
            bottom: parent.bottom
            leftMargin: window.width * 0.095
            topMargin: 80
        }

        cellHeight: height / 3
        cellWidth: width / 6

        clip: true

        leftMargin: 45

        model: notes
        delegate: Button {
            id: item
            onPressed: {

                edit.open()

                titleEdit.text = model.title
                descriptionEdit.text = model.description

                switch(model.color){
                case "blue":
                    blueEdit.checked = true
                    break
                case "red":
                    redEdit.checked = true
                    break
                case "yellow":
                    yellowEdit.checked = true
                    break
                }

                id = model.id
                titleProperty = model.title
                descriptionProperty = model.description
                colorProperty = model.color

            }

            background: Rectangle {
                color: model.color
                implicitHeight: gridView.cellHeight * 0.9
                implicitWidth: gridView.cellWidth * 0.9
                radius: 8

                Column {
                    id: column
                    padding: 10

                    Text {
                        text: if (model.title.length < 15) return model.title + ""
                              else {
                                  let vartitle = ""
                                  let begin = 0
                                  let end = 14
                                  let i = 0
                                  do {
                                      vartitle += model.title.slice(begin, end) + "\n"
                                      begin += 15
                                      end += 15
                                      i++;
                                  }while(i < 2)
                                  return vartitle + "..."
                              }
                        font.bold: true
                    }

                    Text {
                        text: model.createdin + "\n"
                    }

                    Text {
                        text: if (model.description.length < 15) return model.description
                              else {
                                  let vardescription = ""
                                  let begin = 0
                                  let end = 14
                                  let i = 0
                                  do {
                                      vardescription += model.description.slice(begin, end) + "\n"
                                      begin += 15
                                      end += 15
                                      i++;
                                  }while(i < 4)
                                  return vardescription + "..."
                              }
                    }
                }
            }
        }
    }

    ListView {
        id: listView

        visible: false

        model: notes

        width: window.width
        height: window.height * 0.85
        anchors.top: addNoteButton.bottom
        anchors.bottom: window.bottom
        anchors.topMargin: 25
        leftMargin: width * 0.1

        spacing: 16
        clip: true

        delegate: Button {

            onPressed: {

                edit.open()

                titleEdit.text = model.title
                descriptionEdit.text = model.description

                switch(model.color){
                case "blue":
                    blueEdit.checked = true
                    break
                case "red":
                    redEdit.checked = true
                    break
                case "yellow":
                    yellowEdit.checked = true
                    break
                }

                id = model.id
                titleProperty = model.title
                descriptionProperty = model.description
                colorProperty = model.color
            }

            background: Rectangle {
                color: model.color
                implicitHeight: window.height / 4
                implicitWidth: listView.width * 0.8
                radius: 8

                Column {
                    padding: 10

                    Text {
                        text: model.title
                        font.bold: true
                    }

                    Text {
                        text: model.createdin + "\n"
                    }

                    Text {
                        text: if (model.description.length < 100) return model.description
                              else {
                                  let vardescription = ""
                                  let begin = 0
                                  let end = 89
                                  let i = 0
                                  do {
                                      vardescription += model.description.slice(begin, end) + "\n"
                                      begin += 90
                                      end += 90
                                      i++;
                                  }while(i < 5)
                                  return vardescription + "..."
                              }
                    }
                }
            }
        }
    }
}
