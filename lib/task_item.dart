//タスクの一つ一つを管理

import 'package:flutter/material.dart';
import 'package:task_schedule_app/add_dialog/add_dialog.dart';
import 'package:task_schedule_app/task.dart';

class TaskItem extends StatefulWidget {
  final Task task;
  final VoidCallback onTap;

  const TaskItem({
    Key key,
    @required this.onTap,
    @required this.task,
  }) : super(key: key);

  @override
  TaskItemState createState() => new TaskItemState();
}

class TaskItemState extends State<TaskItem> {
  // final Task task;
  // final VoidCallback onTap;

  void reload() {}
  //
  // const TaskItemState({
  //   Key key,
  //   @required this.onTap,
  //   @required this.task,
  // }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    void reload() {
      setState(() {
        print('setState');
      });
    }

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () async {
        print("タスクをタップしました");
        await showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('test'),
                content: AddDialog(
                  editTask: widget.task,
                ),
              );
            }).then((result) {
          setState(() {});
        });
      },
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        padding: EdgeInsets.all(10),
        color: deadlineColors(widget.task.deadlineAt),
        child: Column(
          children: [
            Text(
              widget.task.title,
              style: TextStyle(color: Colors.black, fontSize: 20),
            ),
            Text(
              widget.task.subtitle,
              style: TextStyle(color: Colors.black),
            ),
            Text(
                "${widget.task.deadlineAt.year}/${widget.task.deadlineAt.month}/${widget.task.deadlineAt.day}")
          ],
        ),
      ),
    );
  }

  Color deadlineColors(DateTime dt) {
    final difference = DateTime.now().difference(dt).inDays;
    print('difference is $difference');

    if (difference < -13) {
      return Colors.white;
    } else if (difference < -6) {
      return Colors.red.shade100;
    } else if (difference < -4) {
      return Colors.red.shade200;
    } else if (difference < -2) {
      return Colors.red.shade300;
    } else if (difference < 0) {
      return Colors.red.shade400;
    } else {
      return Colors.red.shade500;
    }
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
