import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

import 'task.dart';

class DBProvider {
  DBProvider._();
  static final DBProvider db = DBProvider._();

  static Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;

    // if not exist database, create DB
    _database = await initDB();
    return _database;
  }

  Future<Database> initDB() async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();

    String path = join(documentDirectory.path, "TaskDB.db");

    return await openDatabase(path, version: 1, onCreate: _createTable);
  }

  Future<void> _createTable(Database db, int version) async {
    return await db.execute("CREATE TABLE Task ("
        "id TEXT PRIMARY KEY,"
        "title TEXT,"
        "subtitle TEXT,"
        "taskType INTEGER,"
        "createdAt TEXT,"
        "updateAt TEXT,"
        "isDone INTEGER"
        ")");
  }

  static final _tableName = "Task";

  createTask(Task task) async {
    final db = await database;
    var res = await db.insert(_tableName, task.toMap());
    return res;
  }

  //TODO taskTypeに応じた引数を取り、WHERE句で適切に集める
  getAllTasks(String taskType) async {
    final db = await database;
    var res = await db
        .query(_tableName, where: 'taskType = ?', whereArgs: [taskType]);
    List<Task> list =
        res.isNotEmpty ? res.map((c) => Task.fromMap(c)).toList() : [];
    return list;
  }

  updateTask(Task task) async {
    final db = await database;
    var res = await db.update(_tableName, task.toMap(),
        where: "id = ?", whereArgs: [task.id]);
    return res;
  }

  deleteTask(String id) async {
    final db = await database;
    var res = db.delete(_tableName, where: "id = ?", whereArgs: [id]);
    return res;
  }
}
