import 'dart:convert';

class ToDoNote {
  int id;
  String name;
  String title;
  String description;
  bool isComplete;

  ToDoNote(this.name, this.title, this.description, this.isComplete);

  ToDoNote copy() {
    ToDoNote note = new ToDoNote(name, title, description, isComplete);
    note.id = id;
    return note;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'title': title,
      'description': description,
      'isComplete': isComplete ? 1 : 0
    };
  }

  static ToDoNote DynamicToToDoNode(dynamic dynamicElemet) {
    ToDoNote node = new ToDoNote(dynamicElemet['name'], dynamicElemet['title'],
        dynamicElemet['description'], dynamicElemet['isComplete'] == 1);
    node.id = dynamicElemet['id'];
    return node;
  }

  static fromJson(dynamic dynamicElemet) {
    ToDoNote node = new ToDoNote(
        dynamicElemet['taskName'],
        dynamicElemet['title'],
        dynamicElemet['description'],
        dynamicElemet['taskComplete']);
    node.id = dynamicElemet['taskId'];
    return node;
  }

  dynamic toJson(int userId) {
    return jsonEncode({
      'userId': userId,
      'taskId': id == null ? 0 : id,
      'taskName': name,
      'title': title,
      'description': description,
      'taskComplete': isComplete
    });
  }

  @override
  String toString() {
    return '$name\n $title\n $description';
  }
}
