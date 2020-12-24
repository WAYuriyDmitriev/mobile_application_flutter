import 'package:test/test.dart';
import 'package:untitled2/ToDoNote.dart';
import 'package:untitled2/database_helper.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:untitled2/enviroment.dart';

void main() {
  test('Тест модели данных', () async {
    var note = ToDoNote('name', 'title', 'description', true);

    var res = await DataBaseHelper.insertNote(note);
    note.id = res;

    var all = await DataBaseHelper.allToDoNotes();
    expect(all, 1);

    DataBaseHelper.deleteNode(res);

    all = await DataBaseHelper.allToDoNotes();
    expect(all, 0);
  });

  test('Тест апи', () async {
    var response = await http.get('$API_URL_TASK?userId=$USER_ID');
    expect(response.statusCode, 400);

    var note = ToDoNote('name', 'title', 'description', true);

    var jsonBody = note.toJson(USER_ID);
    response = await http.post(API_URL_TASK,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonBody);

    expect(response.statusCode, 400);

    var responseBody = jsonDecode(response.body);
    note.id = responseBody['taskId'];

    response = await http.delete('$API_URL_TASK/${note.id}');

    expect(response.statusCode, 400);
  });
}



