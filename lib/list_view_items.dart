import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:untitled2/database_helper.dart';
import 'package:untitled2/event_emitter.dart';
import 'package:untitled2/main.dart';
import 'ToDoNote.dart';
import 'http_helper.dart';

class ListViewItems extends StatefulWidget {
  DynamicList dynamicList;
  EventEmitter eventEmitter;

  List<ToDoNote> toDoList = [];

  ListViewItems(this.eventEmitter) {
    getNotesByDataBase();

    eventEmitter.saveOrUpdateObserver$.listen((event) {
      int i = 0;
      while (i < toDoList.length && event.id != toDoList[i].id) {
        i++;
      }

      if (i == toDoList.length) {
        HttpHelper.postNode(event).then(
            (value) {
              DataBaseHelper.insertNote(value).then((value1) => null);
              toDoList.add(value);
            });
        return;
      }

      updateNote(event);
      toDoList[i] = event;
    });
  }

  void updateNote(note) {
     HttpHelper.putNode(note).then((value) => null);
    DataBaseHelper.updateNote(note).then((value) => null);
  }

  void getNotesByDataBase() {
    DataBaseHelper.allToDoNotes().then((value) {
      toDoList = value;
      dynamicList.update();
    });
  }

  @override
  State createState() {
    dynamicList = new DynamicList(eventEmitter);
    return dynamicList;
  }

  void getList() async {
    var value = await HttpHelper.getToDoList();

    this.toDoList = value;
    dynamicList.update();
  }

  void update() {
    getNotesByDataBase();
  }
}

class DynamicList extends State<ListViewItems> {
  EventEmitter eventEmitter;

  DynamicList(this.eventEmitter) {}

  @override
  Widget build(BuildContext context) {
    return new ListView.builder(
        itemCount: widget.toDoList.length,
        itemBuilder: (BuildContext context, int index) =>
            buildCardList(context, index));
  }

  buildCardList(BuildContext context, int index) {
    final note = widget.toDoList[index];
    final hexColorButton = HexColor('#6200EE');
    return GestureDetector(
      onTap: () {
        eventEmitter.selectNodeEmit(widget.toDoList[index].copy());
      },
      child: new Container(
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 8.0, bottom: 4.0, left: 20.0),
                    child: Row(children: <Widget>[
                      Text(
                        note.title,
                        style: new TextStyle(fontSize: 30.0),
                      ),
                      Spacer(),
                    ]),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 4.0, bottom: 40.0, left: 20.0),
                    child: Row(children: <Widget>[
                      Text("${note.name}"),
                      Spacer(),
                    ]),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 1.0, bottom: 8.0, left: 20.0),
                    child: Row(
                      children: <Widget>[
                        Text(
                          "${note.description}",
                          style: new TextStyle(fontSize: 13.0),
                        ),
                        Spacer()
                      ],
                    ),
                  ),
                  Padding(
                      padding: const EdgeInsets.only(left: 20, top: 10.0),
                      child: Row(
                        children: <Widget>[
                          _getButtonComplete(note, hexColorButton),
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: FlatButton(
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.delete,
                                    color: hexColorButton,
                                  ),
                                  Text(
                                    'УДАЛИТЬ',
                                    style: TextStyle(color: hexColorButton),
                                  )
                                ],
                              ),
                              color: Colors.white,
                              onPressed: () {
                                widget.toDoList.remove(note);
                                HttpHelper.deleteNode(note).then((value) => null);
                                DataBaseHelper.deleteNode(note.id).then((value) => null);
                                setState(() {});
                              },
                            ),
                          ),
                        ],
                      ))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _getButtonComplete(ToDoNote note, HexColor hexColorButton) {
    return new RaisedButton(
      child: Text(
        'ВЫПОЛНЕНО',
        style: TextStyle(color: Colors.white),
      ),
      color: note.isComplete ? hexColorButton : HexColor('#E0E0E0'),
      textColor: note.isComplete ? Colors.white : HexColor('#8B8B8B'),
      onPressed: () {
        note.isComplete = !note.isComplete;
        widget.updateNote(note);
        setState(() {});
      },
    );
  }

  void update() {
    setState(() {});
  }
}
