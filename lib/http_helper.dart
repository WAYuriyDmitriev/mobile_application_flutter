import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:untitled2/ToDoNote.dart';

class HttpHelper {
  static Future<List<ToDoNote>> getToDoList(int id) async {
    var response =
        await http.get('http://188.225.11.200:8080/todoback/tasks?userId=$id');
    print(response.body);
    // Продолжить отсюда
    // https://flutter.dev/docs/cookbook/networking/background-parsing
  }
}
