import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:untitled2/event_emitter.dart';
import 'package:untitled2/main.dart';
import 'ToDoNote.dart';

class ListViewElement extends StatefulWidget {
  ListViewElementState listViewElementState;
  EventEmitter eventEmitter;
  ToDoNote toDoNote = new ToDoNote('name', 'title', '', false);

  @override
  State createState() {
    listViewElementState = new ListViewElementState(toDoNote, eventEmitter);
    return listViewElementState;
  }

  ListViewElement(note, EventEmitter eventEmitter) {
    toDoNote = note;
    this.eventEmitter = eventEmitter;
  }

  void save() {
    listViewElementState.save();
  }
}

class ListViewElementState extends State<ListViewElement> {
  EventEmitter eventEmitter = new EventEmitter();
  ToDoNote toDoNote = new ToDoNote('name', 'title', '', false);
  var nameController = TextEditingController(text: '');
  var titleController = TextEditingController(text: '');
  var descriptionController = TextEditingController(text: '');

  ListViewElementState(ToDoNote note, EventEmitter eventEmitter) {
    this.eventEmitter = eventEmitter;
    toDoNote = note;
    nameController = TextEditingController(text: note.name);
    titleController = TextEditingController(text: note.title);
    descriptionController = TextEditingController(text: note.description);
  }

  @override
  Widget build(BuildContext context) {
    eventEmitter.titleUpdateEmit(toDoNote.name);
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: new Container(
        child: Column(
          children: [
            TextFormField(
              maxLength: 64,
              controller: nameController,
              onChanged: (text) {
                eventEmitter.titleUpdateEmit(text);
                toDoNote.name = text;
                setState(() {});
              },
              maxLines: 1,
              decoration: InputDecoration(
                labelText: 'Имя задачи',
                border: OutlineInputBorder(),
                suffix: new SizedBox(
                    height: 18.0,
                    width: 18.0,
                    child: new IconButton(
                      padding: new EdgeInsets.all(0.0),
                      icon: new Icon(Icons.clear, size: 18.0),
                      onPressed: () {
                        nameController.text = '';
                      },
                    )),
              ),
            ),
            Row(
              children: [
                Checkbox(
                  value: toDoNote.isComplete,
                  onChanged: (bool) {
                    toDoNote.isComplete = bool;
                    setState(() {});
                  },
                  activeColor: HexColor('#6200EE'),
                ),
                Text('Задача выполнена')
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: TextFormField(
                maxLength: 64,
                controller: titleController,
                maxLines: 1,
                onChanged: (text) {
                  toDoNote.title = text;
                },
                decoration: InputDecoration(
                  labelText: 'Заголовок задачи',
                  border: OutlineInputBorder(),
                  suffix: new SizedBox(
                      height: 18.0,
                      width: 18.0,
                      child: new IconButton(
                        padding: new EdgeInsets.all(0.0),
                        icon: new Icon(Icons.clear, size: 18.0),
                        onPressed: () {
                          titleController.text = '';
                        },
                      )),
                ),
              ),
            ),
            TextFormField(
              maxLength: 64,
              onChanged: (text) {
                toDoNote.description = text;
              },
              controller: descriptionController,
              maxLines: 1,
              decoration: InputDecoration(
                labelText: 'Описание задачи',
                border: OutlineInputBorder(),
                suffix: new SizedBox(
                    height: 18.0,
                    width: 18.0,
                    child: new IconButton(
                      padding: new EdgeInsets.all(0.0),
                      icon: new Icon(Icons.clear, size: 18.0),
                      onPressed: () {
                        descriptionController.text = '';
                      },
                    )),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void save() {}
}
