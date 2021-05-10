import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_schedule_app/add_dialog/add_dialog.dart';
import 'package:task_schedule_app/main.dart';
import 'package:task_schedule_app/task_item.dart';

class MicroTaskListView extends StatefulWidget {
  final String param;
  MicroTaskListView({this.param, Key key}) : super(key: key);

  @override
  _MicroTaskListViewState createState() => _MicroTaskListViewState();
}

class _MicroTaskListViewState extends State<MicroTaskListView> {
  @override
  final bool autofocus = true;
  void initState() {
    // TODO: implement initState
    this.autofocus;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Consumer(builder: (
          context,
          watch,
          child,
        ) {
          if (watch(taskViewProviderFamily(widget.param)).tasks.isEmpty) {
            //todo
            return _emptyView();
          }
          return Container(
              height: MediaQuery.of(context).size.height,
              color: Focus.of(context).hasPrimaryFocus ? Colors.black12 : null,
              child: ListView.separated(
                padding: EdgeInsets.only(top: 5),
                itemBuilder: (context, index) {
                  print("アイテムを表示 widget.param ${widget.param}"); //todo
                  final task =
                      watch(taskViewProviderFamily(widget.param)).tasks[index];
                  return Center(
                    child: Dismissible(
                      key: UniqueKey(),
                      onDismissed: (direction) {
                        if (direction == DismissDirection.endToStart) {
                          watch(taskViewProviderFamily(widget.param))
                              .deleteTask(index, task.id);
                        } else {
                          watch(taskViewProviderFamily(widget.param))
                              .toggleDone(index, true);
                        }
                      },
                      background: _buildDismissibleBackgroundContainer(false),
                      secondaryBackground:
                          _buildDismissibleBackgroundContainer(true),
                      child: Container(
                        color: Focus.of(context).hasPrimaryFocus
                            ? Colors.black12
                            : null,
                        child: TaskItem(
                          task: task,
                          onTap: () async {
                            await showDialog<bool>(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('Test'),
                                    content: AddDialog(
                                      param: widget.param,
                                      editTask: task,
                                    ),
                                  );
                                });
                          },
                        ),
                      ),
                    ),
                  );
                },
                itemCount:
                    watch(taskViewProviderFamily(widget.param)).tasks.length,
                separatorBuilder: (_, __) => const Divider(),
              ));
        }),
        Positioned(
          bottom: 0,
          right: 0,
          child: ElevatedButton(
            child: const Text(
              '+',
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            style: ElevatedButton.styleFrom(
              primary: Colors.white,
              onPrimary: Colors.blue,
              shape: const CircleBorder(
                side: BorderSide(
                  color: Colors.blue,
                  width: 1.5,
                  style: BorderStyle.solid,
                ),
              ),
            ),
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Test'),
                      content: AddDialog(param: widget.param),
                    );
                  });
            },
          ),
        ),
      ],
    );
  }

  Container _buildDismissibleBackgroundContainer(bool isSecond) {
    return Container(
      color: isSecond ? Colors.red : Colors.green,
      alignment: isSecond ? Alignment.centerRight : Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Text(
          isSecond ? 'Delete' : 'Done',
          textAlign: TextAlign.center,
          style: const TextStyle(
              fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
    );
  }

  Widget _emptyView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(child: Text('なにもない')),
          Expanded(
            child: Text(
              '追加しよう',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 32,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
