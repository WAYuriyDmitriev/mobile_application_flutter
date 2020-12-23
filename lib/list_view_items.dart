import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:untitled2/event_emitter.dart';
import 'package:untitled2/main.dart';
import 'ToDoNote.dart';

class ListViewItems extends StatefulWidget {
  DynamicList dynamicList;
  EventEmitter eventEmitter;

  List<ToDoNote> toDoList = [
    new ToDoNote("name", "title", "discription", true),
    new ToDoNote("name", "title", "discription", !true),
    new ToDoNote("name", "title", "discription", !!true),
    new ToDoNote("name", "title", "discription", !!!true),
  ];

  ListViewItems(this.eventEmitter){
   eventEmitter.saveOrUpdateObserver$.listen((event) {
      int i = 0;
      while (i < toDoList.length && event.id != toDoList[i].id) {
        i++;
      }

      if (i == toDoList.length) {
        event.id = toDoList.length;
        toDoList.add(event);
        return;
      }

      toDoList[i] = event;
    });
  }

  @override
  State createState() {
    dynamicList = new DynamicList(eventEmitter);
    return dynamicList;
  }

  void update() {
    dynamicList.update();
  }
}

class DynamicList extends State<ListViewItems> {
  EventEmitter eventEmitter;

  DynamicList(this.eventEmitter) {

  }

  @override
  Widget build(BuildContext context) {
    return new ListView.builder(
        itemCount: widget.toDoList.length,
        itemBuilder: (BuildContext context, int index) =>
            buildCardList(context, index));
  }

  buildCardList(BuildContext context, int index) {
    final trip = widget.toDoList[index];
    trip.id = index;
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
                        trip.title,
                        style: new TextStyle(fontSize: 30.0),
                      ),
                      Spacer(),
                    ]),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 4.0, bottom: 40.0, left: 20.0),
                    child: Row(children: <Widget>[
                      Text("${trip.name}"),
                      Spacer(),
                    ]),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 1.0, bottom: 8.0, left: 20.0),
                    child: Row(
                      children: <Widget>[
                        Text(
                          "${trip.description}",
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
                          _getButtonComplete(trip, hexColorButton),
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
                                widget.toDoList.remove(trip);
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
    widget.toDoList = [
      ToDoNote("name", "title", "discription", true),
      ToDoNote("name", "title", "discription", !true),
      ToDoNote("name", "title", "discription", !!true),
      ToDoNote("name", "title", "discription", !!!true),
    ];
    setState(() {});
  }
}
