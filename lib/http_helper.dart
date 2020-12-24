import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:untitled2/ToDoNote.dart';
import 'package:untitled2/enviroment.dart';

class HttpHelper {
  static Future<List<ToDoNote>> getToDoList() async {
    var response = await http.get('$API_URL_TASK?userId=$USER_ID');
    Map<String, dynamic> decodeContext = jsonDecode(response.body);
    List<dynamic> context = decodeContext['content'];
    return context
        .map<ToDoNote>((elJson) => ToDoNote.fromJson(elJson))
        .toList();
  }

  static Future<void> putNode(ToDoNote toDoNote) async {
    var json = toDoNote.toJson(USER_ID);
    return await http.put(API_URL_TASK,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: json);
  }

  static Future<ToDoNote> postNode(ToDoNote toDoNote) async {
    var jsonBody = toDoNote.toJson(USER_ID);
    var responce = await http.post(API_URL_TASK,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonBody);
    var responseBody = jsonDecode(responce.body);
    toDoNote.id = responseBody['taskId'];
    return toDoNote;
  }

  static Future<void> deleteNode(ToDoNote toDoNote) async {
    return await http.delete('$API_URL_TASK/${toDoNote.id}');
  }
}
