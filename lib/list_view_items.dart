import 'package:flutter/material.dart';
import 'package:untitled2/database_helper.dart';
import 'package:untitled2/event_emitter.dart';
import 'package:untitled2/main.dart';
import 'ToDoNote.dart';

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
        event.id = toDoList.length;
        toDoList.add(event);

        DataBaseHelper.insertNote(event).then((value) => null);
        return;
      }

      DataBaseHelper.updateNote(event).then((value) => null);
      toDoList[i] = event;
    });
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
    note.id = index;
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
                                DataBaseHelper.deleteNode(note.id);
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

  Widget _getButtonComplete(ToDoNote trip, HexColor hexColorButton) {
    return new RaisedButton(
      child: Text(
        'ВЫПОЛНЕНО',
        style: TextStyle(color: Colors.white),
      ),
      color: trip.isComplete ? hexColorButton : HexColor('#E0E0E0'),
      textColor: trip.isComplete ? Colors.white : HexColor('#8B8B8B'),
      onPressed: () {
        trip.isComplete = !trip.isComplete;
        setState(() {});
      },
    );
  }

  void update() {
    setState(() {});
  }
}
