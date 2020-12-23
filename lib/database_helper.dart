import 'dart:async';

import 'package:flutter/widgets.dart';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:untitled2/ToDoNote.dart';

class DataBaseHelper {
  static String tableName = 'note';

  static Future<Database> createDatabase() async {
    WidgetsFlutterBinding.ensureInitialized();
    // Open the database and store the reference.
    return openDatabase(
      // Set the path to the database. Note: Using the `join` function from the
      // `path` package is best practice to ensure the path is correctly
      // constructed for each platform.
      join(await getDatabasesPath(), 'note_database_1.db'),
      // When the database is first created, create a table to store dogs.
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE $tableName(id INTEGER PRIMARY KEY, name TEXT, title Text, description Text, isComplete INTEGER)',
        );
      },
      // Set the version. This executes the onCreate function and provides a
      // path to perform database upgrades and downgrades.
      version: 1,
    );
  }

  // Avoid errors caused by flutter upgrade.
  // Importing 'package:flutter/widgets.dart' is required.

  static Future<int> insertNote(ToDoNote toDoNote) async {
    // Get a reference to the database.
    final Database db = await createDatabase();

    // Insert the Dog into the correct table. Also specify the
    // `conflictAlgorithm`. In this case, if the same dog is inserted
    // multiple times, it replaces the previous data.
    return await db.insert(
      tableName,
      toDoNote.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<List<ToDoNote>> allToDoNotes() async {
    // Get a reference to the database.
    final Database db = await createDatabase();

    // Query the table for all The Dogs.
    final List<Map<String, dynamic>> maps = await db.query(tableName);

    // Convert the List<Map<String, dynamic> into a List<Dog>.
    return List.generate(maps.length, (i) {
      return ToDoNote.DynamicToToDoNode(maps[i]);
    });
  }

  static Future<void> updateNote(ToDoNote note) async {
    // Get a reference to the database.
    final db = await createDatabase();

    // Update the given Dog.
    await db.update(
      tableName,
      note.toMap(),
      // Ensure that the Dog has a matching id.
      where: "id = ?",
      // Pass the Dog's id as a whereArg to prevent SQL injection.
      whereArgs: [note.id],
    );
  }

  static Future<void> deleteNode(int id) async {
    // Get a reference to the database.
    final db = await createDatabase();

    // Remove the Dog from the database.
    await db.delete(
      tableName,
      // Use a `where` clause to delete a specific dog.
      where: "id = ?",
      // Pass the Dog's id as a whereArg to prevent SQL injection.
      whereArgs: [id],
    );
  }
}
