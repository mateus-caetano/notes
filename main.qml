import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.15
import QtQuick.Dialogs 1.3

Window {
    id: window
    minimumHeight: 700
    minimumWidth: 950
    width: 1280
    height: 720
    visible: true
    title: qsTr("Notes")

    ListModel {
        id: notes
        ListElement {
            title: "nota 1"
            description: "Antes de começar um processo de estudo, é importante definir qual o objetivo principal com isso para poder extrair desse processo as informações mais relevantes para mim"
            date: "03/02/2021"
        }

        ListElement {
            title: "nota 2"
            description: "this is a note"
            date: "04/02/2021"
        }

        ListElement {
            title: "nota 3"
            description: "this is a note"
            date: "05/02/2021"
        }

    }

    ColumnLayout{
        anchors.fill: parent

        Button {
            id: addNoteButton
            text: "Criar uma nota..."
            anchors.top: parent.top
            anchors.topMargin: 16
            anchors.bottomMargin: 16
            anchors.horizontalCenter: parent.horizontalCenter

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

    }

    Dialog {
        id: dialog
        visible: false
        title: "Nova nota"
        width: 500
        height: 200
        contentItem:Column {
            anchors.fill: parent
            spacing: 16
            anchors.topMargin: 16

            TextField {
                id: title
                placeholderText: "Título"
                width: parent.width * 0.8
                anchors.horizontalCenter: parent.horizontalCenter
            }

            TextField {
                id: description
                placeholderText: "Descrição"
                width: parent.width * 0.8
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Row{
                width: parent.width * 0.8
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: description.bottom
                anchors.topMargin: 16

                Button {
                    text: "Salvar"
                    anchors.left: parent.left
                    onPressed: {
                        if (title.text !== "" && description.text !== "")
                            notes.append({"title": title.text, "description": description.text, "date": new Date})

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

    GridView {
        id: gridView

        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
            bottom: parent.bottom
            leftMargin: window.width * 0.095
            topMargin: 80
        }

        width: 864
        height: 532

        cellHeight: height / 3
        cellWidth: width / 6

        clip: true

        leftMargin: 45

        model: notes
        delegate: Button {
            anchors.margins: 16
            Rectangle {
                color: "#ddd"
                implicitHeight: gridView.cellHeight * 0.9
                implicitWidth: gridView.cellWidth * 0.9
                radius: 8

                Column {
                    padding: 10

                    Text {
                        text: if (title.length < 15) return title + "\n"
                              else {
                                  let vartitle = ""
                                  for(let i = 0; i < 20; i+=15){
                                      vartitle += title.slice(i, i+15) + "\n"
                                  }
                                  return vartitle + "..."
                              }
                        font.bold: true
                    }

                    Text {
                        text: if (description.length < 15) return description
                              else {
                                  let vardescription = ""
                                  for(let i = 0; i < 80; i+=15){
                                      vardescription += description.slice(i, i+15) + "\n"
                                  }
                                  return vardescription + "..."
                              }
                    }
                }
            }
        }
    }

}
