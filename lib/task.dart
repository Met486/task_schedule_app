import 'package:uuid/uuid.dart';

class Task {
  Task(
      {this.id,
      this.title,
      this.subtitle,
      //  this.priority,
      this.taskType,
      this.isDone = false,
      this.updatedAt,
      this.createdAt});

  String id;
  String title;
  String subtitle;
  // int priority;
  int taskType;
  bool isDone;
  DateTime updatedAt;
  DateTime createdAt;

  assignUUID() {
    id = Uuid().v4();
  }

  Task.newTask() {
    title = "";
    subtitle = "";
    createdAt = DateTime.now();
  }

  factory Task.fromMap(Map<String, dynamic> json) => Task(
      id: json["id"],
      title: json["title"],
      subtitle: json["subtitle"],
      taskType: json["taskType"],
      isDone: (json["isDone"] == 1) ? true : false,
      createdAt: DateTime.parse(json["createdAt"]).toLocal(),
      updatedAt: DateTime.parse(json["updateAt"]).toLocal());

  Map<String, dynamic> toMap() => {
        "id": id,
        "title": title,
        "subtitle": subtitle,
        "taskType": taskType,
        "isDone": isDone ? 1 : 0,
        "createdAt": createdAt.toUtc().toIso8601String(),
        "updateAt": updatedAt.toUtc().toIso8601String()
      };
}
