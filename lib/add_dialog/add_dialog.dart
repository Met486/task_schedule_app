import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_schedule_app/task.dart';
import 'package:task_schedule_app/task_view_model/task_view_model.dart';

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
      child: Consumer<TaskViewModel>(
        builder: (context, viewModel, _) {
          return ListView(
            children: <Widget>[
              _buildInputField(
                context,
                title: 'Title',
                textEditingController: viewModel.titleController,
                errorText:
                    viewModel.validateTitle ? viewModel.strValidateTitle : null,
                didChanged: (_) {
                  viewModel.updateValidateTitle();
                },
              ),
              _buildInputField(
                context,
                title: 'subtitle',
                textEditingController: viewModel.subtitleController,
                errorText: null,
              ),
              _buildAddButton(context),
            ],
          );
        },
      ),
    );
  }

  bool _isEdit() {
    return widget.editTask != null;
  }

  void tapAddButton(BuildContext context) {
    final viewModel = Provider.of<TaskViewModel>(context, listen: false);
    viewModel.setValidateTitle(true);

    if (viewModel.validateTaskTitle()) {
      _isEdit()
          ? viewModel.updateTask(widget.editTask)
          : viewModel.addTask(widget.param);
      Navigator.of(context).pop();
    }
    viewModel.notifyListeners();
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

  Widget _buildAddButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: RaisedButton(
        onPressed: () => tapAddButton(context),
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
