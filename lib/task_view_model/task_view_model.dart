import 'dart:async';
import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:task_schedule_app/db_provider.dart';
import 'package:task_schedule_app/task.dart';

class TaskViewModel extends ChangeNotifier {
  final String param;

  String get editingTitle => titleController.text;
  String get editingSubtitle => subtitleController.text;
  TextEditingController titleController = TextEditingController();
  TextEditingController subtitleController = TextEditingController();
  String _strValidateTitle = '';
  String get strValidateTitle => _strValidateTitle;
  bool _validateTitle = false;
  bool get validateTitle => _validateTitle;

  final _taskController = StreamController<List<Task>>();
  Stream<List<Task>> get taskStream => _taskController.stream;

  getTasks() async {
    _tasks = (await DBProvider.db.getAllTasks(param));
    _taskController.sink.add(await DBProvider.db.getAllTasks(param));
    print("taskViewModel getTasks is Called");
    print("get tasks is called param : " + param);
    print('TaskViewModel param:${param} tasks.length:${tasks.length}');
  }

  TaskViewModel(this.param) {
    getTasks();
  }

//  TaskViewModel([this.param])
//      : super([]);

//  TaskViewModel(this.param) : super('0') {
//    this.param;
//  }

  List<Task> _tasks = [];
  UnmodifiableListView<Task> get tasks {
    return UnmodifiableListView(_tasks);
  }

  bool validateTaskTitle() {
    if (editingTitle.isEmpty) {
      _strValidateTitle = 'Please input something.';
      notifyListeners();
      return false;
    } else {
      _strValidateTitle = '';
      _validateTitle = false;
      return true;
    }
  }

  void setValidateTitle(bool value) {
    _validateTitle = value;
  }

  void updateValidateTitle() {
    if (validateTitle) {
      validateTaskTitle();
      notifyListeners();
    }
  }

  void addTask(String param) {
    final newTask = Task(
      title: titleController.text,
      subtitle: subtitleController.text,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      taskType: int.parse(param),
    );
    _tasks.add(newTask);
    print(_tasks.last.title);
    print("task_view_model addTask is called");
    newTask.assignUUID();
    DBProvider.db.createTask(newTask);
    getTasks();
    notifyListeners(); //todo 不要？
    clear();
  }

  void updateTask(Task updateTask) {
    final updateIndex = _tasks.indexWhere((task) {
      return task.createdAt == updateTask.createdAt;
    });
    updateTask.title = titleController.text;
    updateTask.subtitle = subtitleController.text;
    updateTask.updatedAt = DateTime.now();
    _tasks[updateIndex] = updateTask;
    DBProvider.db.updateTask(updateTask); //
    getTasks(); //
    clear();
  }

  void deleteTask(int index, String id) {
    _tasks.removeAt(index);
    DBProvider.db.deleteTask(id);
    notifyListeners();
  }

  void toggleDone(int index, bool isDone) {
    var task = _tasks[index];
    task.isDone = isDone;
    _tasks[index] = task;
    notifyListeners();
  }

  void clear() {
    titleController.clear();
    subtitleController.clear();
    _validateTitle = false;
    //  notifyListeners();
  }
}

/*
class TaskViewModelOld extends ChangeNotifier {
  final String param;

  String get editingTitle => titleController.text;
  String get editingSubtitle => subtitleController.text;
  TextEditingController titleController = TextEditingController();
  TextEditingController subtitleController = TextEditingController();
  String _strValidateTitle = '';
  String get strValidateTitle => _strValidateTitle;
  bool _validateTitle = false;
  bool get validateTitle => _validateTitle;

  final _taskController = StreamController<List<Task>>();
  Stream<List<Task>> get taskStream => _taskController.stream;

  getTasks() async {
    _tasks = (await DBProvider.db.getAllTasks(param));
    _taskController.sink.add(await DBProvider.db.getAllTasks(param));
    print("taskViewModel getTasks is Called");
    print("get tasks is called param : " + param);
  }

  TaskViewModel({this.param}) {
    getTasks();
  }

  List<Task> _tasks = [];
  UnmodifiableListView<Task> get tasks {
    return UnmodifiableListView(_tasks);
  }

  bool validateTaskTitle() {
    if (editingTitle.isEmpty) {
      _strValidateTitle = 'Please input something.';
      notifyListeners();
      return false;
    } else {
      _strValidateTitle = '';
      _validateTitle = false;
      return true;
    }
  }

  void setValidateTitle(bool value) {
    _validateTitle = value;
  }

  void updateValidateTitle() {
    if (validateTitle) {
      validateTaskTitle();
      notifyListeners();
    }
  }

  void addTask(String param) {
    final newTask = Task(
      title: titleController.text,
      subtitle: subtitleController.text,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      taskType: int.parse(param),
    );
    _tasks.add(newTask);
    print(_tasks.last.title);
    print("task_view_model addTask is called");
    newTask.assignUUID();
    DBProvider.db.createTask(newTask);
    getTasks();
    notifyListeners(); //todo 不要？
    clear();
  }

  void updateTask(Task updateTask) {
    final updateIndex = _tasks.indexWhere((task) {
      return task.createdAt == updateTask.createdAt;
    });
    updateTask.title = titleController.text;
    updateTask.subtitle = subtitleController.text;
    updateTask.updatedAt = DateTime.now();
    _tasks[updateIndex] = updateTask;
    DBProvider.db.updateTask(updateTask); //
    getTasks(); //
    clear();
  }

  void deleteTask(int index, String id) {
    _tasks.removeAt(index);
    DBProvider.db.deleteTask(id);
    notifyListeners();
  }

  void toggleDone(int index, bool isDone) {
    var task = _tasks[index];
    task.isDone = isDone;
    _tasks[index] = task;
    notifyListeners();
  }

  void clear() {
    titleController.clear();
    subtitleController.clear();
    _validateTitle = false;
    notifyListeners();
  }
}
*/
