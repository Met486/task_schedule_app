import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';

import '../main.dart';
import '../task.dart';
import '../task_item.dart';

/// Taskの編集を行うダイアログ
class AddDialog extends StatefulWidget {
  /// taskTypeを扱うための変数
  final String param;

  /// 変更を行うタスク
  final Task editTask;

  /// コンストラクタ
  AddDialog({this.param, key, this.editTask}) : super(key: key);

  @override
  _AddDialogState createState() => _AddDialogState();
}

class _AddDialogState extends State<AddDialog> {
  DateTime _date = DateTime(DateTime.now().year, DateTime.now().month,
      DateTime.now().day, 0, 0, 0, 0, 0);

  @override
  void initState() {
    super.initState();
    if (_isEdit()) {
      _date = widget.editTask.deadlineAt;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      height: 500,
      child: Consumer(
        builder: (context, watch, child) {
          final _model = watch(taskViewProviderFamily(widget.param));
          if (_isEdit()) {
            // _model.titleController.text = widget.editTask.title;
            _model.titleController.value = _model.titleController.value
                .copyWith(text: widget.editTask.title);
            // _model.subtitleController.text = widget.editTask.subtitle;
            _model.subtitleController.value = _model.subtitleController.value
                .copyWith(text: widget.editTask.subtitle);
          }

          return ListView(
            children: <Widget>[
              _buildInputField(
                context,
                title: 'Title',
                textEditingController: _model.titleController,
                errorText:
                    _model.validateTitle ? _model.strValidateTitle : null,
                didChanged: (_) {
                  _model.updateValidateTitle();
                },
              ),
              _buildInputField(
                context,
                title: 'subtitle',
                textEditingController: _model.subtitleController,
                errorText: null,
                didChanged: (_) {
                  _model.updateValidateSubtitle();
                },
              ),
              ElevatedButton(
                onPressed: () {
                  _selectDate(context);
                },
                child: new Text(
                    "現在の締め切り : ${_date.year}/${_date.month}/${_date.day}"),
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
    final viewModel = watch(taskViewProviderFamily(widget.param));
    print(taskViewProviderFamily(widget.param));

    viewModel.setValidateTitle(true);

    if (viewModel.validateTaskTitle()) {
      _isEdit()
          ? viewModel.updateTask(widget.editTask, _date)
          : viewModel.addTask(widget.param, _date);

      setState(() {
        TaskItemState().reload();
      });
      Navigator.of(context).pop(true);
    }
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
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: Theme.of(context).primaryColor,
          padding: const EdgeInsets.all(20),
        ),
        onPressed: () => tapAddButton(context, watch),
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

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: _date,
        firstDate: new DateTime(2016),
        lastDate: new DateTime.now().add(new Duration(days: 360)));
    _date = DateTime(_date.year, _date.month, _date.day, 0, 0, 0, 0, 0);
    if (picked != null) setState(() => _date = picked);
  }
}
