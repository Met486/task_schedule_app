import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:task_schedule_app/main.dart';
import 'package:task_schedule_app/task.dart';

class AddDialog extends StatefulWidget {
  final String param;
  final Task editTask;

  AddDialog({this.param, key, this.editTask}) : super(key: key);

  @override
  _AddDialogState createState() => _AddDialogState();
}

class _AddDialogState extends State<AddDialog> {
  //AddDialog({Key key, this.editTask}) : super(key: key);
  //final Task editTask;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      height: 300,
      child: Consumer(
        //builder: (context, viewModel, _) {
        builder: (context, watch, child) {
          return ListView(
            children: <Widget>[
              _buildInputField(
                context,
                title: 'Title',
                textEditingController:
                    watch(taskViewProviderFamily(widget.param)).titleController,
                //textEditingController: viewModel.titleController,
                //textEditingController: TaskViewModel('1').titleController,

                errorText:
                    watch(taskViewProviderFamily(widget.param)).validateTitle
                        ? watch(taskViewProviderFamily(widget.param))
                            .strValidateTitle
                        : null,
                //   viewModel.validateTitle ? viewModel.strValidateTitle : null,
//                    TaskViewModel('1').validateTitle
//                        ? TaskViewModel('1').strValidateTitle
//                        : null,
                didChanged: (_) {
                  watch(taskViewProviderFamily(widget.param))
                      .updateValidateTitle();
                  //viewModel.updateValidateTitle();
                  //TaskViewModel('1').updateValidateTitle();
                },
              ),
              _buildInputField(
                context,
                title: 'subtitle',
                textEditingController:
                    watch(taskViewProviderFamily(widget.param))
                        .subtitleController,
                //textEditingController: TaskViewModel('1').subtitleController,
                errorText: null,
              ),
              _buildAddButton(context, watch),
            ],
          );
        },
      ),
    );
  }

  bool _isEdit() {
    return widget.editTask != null;
  }

  void tapAddButton(BuildContext context, watch) {
    //final viewModel = Provider.of<TaskViewModel>(context, listen: false);

    //final viewModel = StateNotifierProvider((ref) => TaskViewModel('1'));
    //final viewModel = TaskViewModel(widget.param);
    final viewModel = watch(taskViewProviderFamily(widget.param));
    print(taskViewProviderFamily(widget.param));

    viewModel.setValidateTitle(true);

    print('widget.edittask : ${widget.editTask}');

    if (viewModel.validateTaskTitle()) {
      _isEdit()
          ? viewModel.updateTask(widget.editTask)
          : viewModel.addTask(widget.param);
      print('タスクの可否をチェック');
      Navigator.of(context).pop();
    }
    print('add button');
    print('widget param is ${viewModel.param}');
    //viewModel.addTask(widget.param);
    print(viewModel.tasks.length);

    //Navigator.of(context).pop();

    //viewModel.notifyListeners();
  }

  Widget _buildInputField(BuildContext context,
      {String title,
      TextEditingController textEditingController,
      String errorText,
      Function(String) didChanged}) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: Theme.of(context).textTheme.subtitle,
          ),
          TextField(
            controller: textEditingController,
            decoration: InputDecoration(errorText: errorText),
            onChanged: (value) {
              didChanged(value);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAddButton(BuildContext context, watch) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: RaisedButton(
        onPressed: () => tapAddButton(context, watch),
        color: Theme.of(context).primaryColor,
        padding: const EdgeInsets.all(20),
        child: Center(
          child: Text(
            _isEdit() ? 'Save' : 'Add',
            style:
                Theme.of(context).textTheme.title.copyWith(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
