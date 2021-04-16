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
  String _strValidateSubtitle = '';
  String get strValidateSubtitle => _strValidateSubtitle;
  bool _validateTitle = false;
  bool get validateTitle => _validateTitle;
  bool _validateSubtitle = false;
  bool get validateSubtitle => _validateSubtitle;
  List<Task> _tasks = [];

  final _taskController = StreamController<List<Task>>();
  Stream<List<Task>> get taskStream => _taskController.stream;

  TaskViewModel(this.param) {
    getTasks();
  }

  getTasks() async {
    _tasks = (await DBProvider.db.getAllTasks(param));
    _taskController.sink.add(await DBProvider.db.getAllTasks(param));
    notifyListeners();

    // print("taskViewModel getTasks is Called");
    // print("get tasks is called param : " + param);
    // print('TaskViewModel param:${param} tasks.length:${tasks.length}');
    // print("getTasks _tasks.length : ${_tasks.length}");
  }

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

  bool validateTaskSubtitle() {
    if (editingSubtitle.isEmpty) {
      _strValidateSubtitle = '';
      notifyListeners();
      return true;
    } else {
      _strValidateSubtitle = '';
      _validateTitle = false;
      return true;
    }
  }

  void setValidateTitle(bool value) {
    _validateTitle = value;
  }

  void setValidateSubtitle(bool value) {
    _validateSubtitle = value;
  }

  void updateValidateTitle() {
    if (validateTitle) {
      validateTaskTitle();
      notifyListeners();
    }
  }

  void updateValidateSubtitle() {
    if (validateSubtitle) {
      validateTaskSubtitle();
      notifyListeners();
    }
  }

  void addTask(String param, DateTime _date) {
    final newTask = Task(
      title: titleController.text,
      subtitle: subtitleController.text,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      deadlineAt: _date,
      taskType: int.parse(param),
    );
    _tasks.add(newTask);
    // print("task_view_model addTask is called");
    newTask.assignUUID();
    DBProvider.db.createTask(newTask);
    getTasks();
    notifyListeners(); //todo 不要？
    clear();
  }

  void updateTask(Task updateTask) async {
    _tasks = (await DBProvider.db.getAllTasks(updateTask.taskType.toString()));
    final updateIndex = _tasks.indexWhere((task) {
      //return task.createdAt == updateTask.createdAt;
      return task.id == updateTask.id;
    });
    // print("task.length : ${tasks.length}");
    // print("updateTask.id : ${updateTask.id}");
    // print("updateIndex : ${updateIndex}");
    updateTask.title = titleController.text;
    updateTask.subtitle = subtitleController.text;
    updateTask.updatedAt = DateTime.now();
    _tasks[updateIndex] = updateTask;
    DBProvider.db.updateTask(updateTask);
    getTasks();
    notifyListeners();
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
