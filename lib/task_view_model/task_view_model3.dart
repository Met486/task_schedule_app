import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:task_schedule_app/task.dart';

class TaskViewModel3 extends ChangeNotifier {
  String get editingTitle => titleController.text;
  String get editingSubtitle => subtitleController.text;
  TextEditingController titleController = TextEditingController();
  TextEditingController subtitleController = TextEditingController();
  String _strValidateTitle = '';
  String get strValidateTitle => _strValidateTitle;
  bool _validateTitle = false;
  bool get validateTitle => _validateTitle;

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

  void addTask() {
    final newTask = Task(
      title: titleController.text,
      subtitle: subtitleController.text,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    _tasks.add(newTask);
    print('tasks length ${tasks.length}');
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
    clear();
  }

  void deleteTask(int index) {
    _tasks.removeAt(index);
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
