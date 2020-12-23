import 'dart:async';

import 'package:untitled2/ToDoNote.dart';

class EventEmitter {
  StreamController titleUpdate$ = new StreamController.broadcast();
  StreamController selectNode$ = new StreamController.broadcast();
  StreamController saveOrUpdate$ = new StreamController.broadcast();

  // define constructor here

  titleUpdateEmit(String title) {
    titleUpdate$.add(title);
  }

  selectNodeEmit(ToDoNote toDoNote) {
    selectNode$.add(toDoNote);
  }

  saveOrUpdateEmit(ToDoNote toDoNote) {
    saveOrUpdate$.add(toDoNote);
  }

  Stream get titleUpdateObserver$ => titleUpdate$.stream;

  Stream get selectNodeUpdateObserver$ => selectNode$.stream;

  Stream get saveOrUpdateObserver$ => saveOrUpdate$.stream;
}
