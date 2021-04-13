//タスクの一つ一つを管理

import 'package:flutter/material.dart';
import 'package:task_schedule_app/add_dialog/add_dialog.dart';
import 'package:task_schedule_app/task.dart';

class TaskItem extends StatelessWidget {
  final Task task;
  final VoidCallback onTap;

  const TaskItem({
    Key key,
    @required this.onTap,
    @required this.task,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        print("タスクをタップしました");

        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('test'),
                content: AddDialog(
                  editTask: task,
                ),
              );
            });
      },
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        padding: EdgeInsets.all(10),
        color: Colors.white,
        child: Column(
          children: [
            Text(
              task.title,
              style: TextStyle(color: Colors.black, fontSize: 20),
            ),
            Text(
              task.subtitle,
              style: TextStyle(color: Colors.black),
            ),
            Text(
                "${task.deadlineAt.year}/${task.deadlineAt.month}/${task.deadlineAt.day}")
          ],
        ),
      ),

      /*
      child: ListTile(
        tileColor: Colors.white,
        title: Text(task.title),
        subtitle: Text(task.subtitle),

        //      tileColor: priorityColors(task.priority),
      ),

       */
    );
  }

  Color priorityColors(int priority) {
    switch (priority) {
      case 1:
        return Colors.red.shade500;
      case 2:
        return Colors.red.shade400;
      case 3:
        return Colors.red.shade300;
      case 4:
        return Colors.red.shade200;
      case 5:
        return Colors.red.shade100;
    }
    return Colors.white;
  }
}
