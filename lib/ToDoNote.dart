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
}
