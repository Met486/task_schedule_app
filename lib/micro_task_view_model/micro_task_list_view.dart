import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:task_schedule_app/add_dialog/add_dialog.dart';
import 'package:task_schedule_app/task_item.dart';
import 'package:task_schedule_app/task_view_model/task_view_model.dart';

class MicroTaskListView extends StatefulWidget {
  final String param;
  MicroTaskListView({this.param, Key key}) : super(key: key);

  @override
  _MicroTaskListViewState createState() => _MicroTaskListViewState();
}

class _MicroTaskListViewState extends State<MicroTaskListView> {
  @override
  Widget build(BuildContext context) {
    //final TaskViewModel taskViewModel = Provider.of<TaskViewModel>(context);
    //final taskViewModel = TaskViewModel(param: '1');

    return ListView(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      children: [
        ElevatedButton(
          child: const Text('追加'),
          onPressed: () {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Test'),
                    content: AddDialog(
                      param: widget.param,
                    ),
                  );
                });
          },
        ),
        Consumer<TaskViewModel>(builder: (
          context,
          taskViewModel,
          _,
        ) {
          if (taskViewModel.tasks.isEmpty) {
            return _emptyView();
          }
          return SizedBox(
            height: MediaQuery.of(context).size.height,
            child: ListView.separated(
                padding: EdgeInsets.zero,
                itemBuilder: (context, index) {
                  print("アイテムを表示"); //todo
                  final task = taskViewModel.tasks[index];
                  //var task = taskViewModel.tasks[index];
                  return Dismissible(
                    key: UniqueKey(),
                    onDismissed: (direction) {
                      if (direction == DismissDirection.endToStart) {
                        taskViewModel.deleteTask(index, task.id);
                      } else {
                        taskViewModel.toggleDone(index, true);
                      }
                    },
                    background: _buildDismissibleBackgroundContainer(false),
                    secondaryBackground:
                        _buildDismissibleBackgroundContainer(true),
                    child: TaskItem(
                      task: task,
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Test'),
                                content: AddDialog(
                                  param: widget.param,
                                ),
                              );
                            });
                      },
                    ),
                  );
                },
                separatorBuilder: (_, __) => const Divider(),
                itemCount: taskViewModel.tasks.length),
          );
        }),
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
          Text('なにもない'),
          SizedBox(height: 16),
          Text(
            '追加しよう',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 32,
            ),
          ),
        ],
      ),
    );
  }
}

/*
class MicroTaskListView extends StatelessWidget {
  const MicroTaskListView({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //final TaskViewModel taskViewModel = Provider.of<TaskViewModel>(context);
    return ListView(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      children: [
        ElevatedButton(
          child: const Text('追加'),
          onPressed: () {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Test'),
                    content: AddDialog(),
                  );
                });
          },
        ),
        Consumer<TaskViewModel>(builder: (context, taskViewModel, _) {
          if (taskViewModel.tasks.isEmpty) {
            return _emptyView();
          }
          return Expanded(
            child: SizedBox(
              height: 400,
              child: ListView.separated(
                  padding: EdgeInsets.zero,
                  itemBuilder: (context, index) {
                    final task = taskViewModel.tasks[index];
                    //var task = taskViewModel.tasks[index];
                    return Dismissible(
                      key: UniqueKey(),
                      onDismissed: (direction) {
                        if (direction == DismissDirection.endToStart) {
                          taskViewModel.deleteTask(index, task.id);
                        } else {
                          taskViewModel.toggleDone(index, true);
                        }
                      },
                      background: _buildDismissibleBackgroundContainer(false),
                      secondaryBackground:
                          _buildDismissibleBackgroundContainer(true),
                      child: TaskItem(
                        task: task,
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('Test'),
                                  content: AddDialog(),
                                );
                              });
                        },
                      ),
                    );
                  },
                  separatorBuilder: (_, __) => const Divider(),
                  itemCount: taskViewModel.tasks.length),
            ),
          );
        })
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
          Text('なにもない'),
          SizedBox(height: 16),
          Text(
            '追加しよう',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 32,
            ),
          ),
        ],
      ),
    );
  }
}
*/
