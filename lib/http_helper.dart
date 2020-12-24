import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:untitled2/ToDoNote.dart';
import 'package:untitled2/enviroment.dart';

class HttpHelper {
  static Future<List<ToDoNote>> getToDoList(int id) async {
    var response =
        await http.get('http://188.225.11.200:8080/todoback/tasks?userId=$id');
    print(response.body);
    // Продолжить отсюда
    // https://flutter.dev/docs/cookbook/networking/background-parsing
  }

  static Future<void> getNearPlaces() async {
    var responce = await http.get(
        'https://maps.googleapis.com/maps/api/place/nearbysearch/json?radius=5000&location=53.2038,50.1606&key=$API_KEY&language=ru');
    print(responce.body);
  }
}
