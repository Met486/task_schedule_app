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
  DateTime _date = new DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      height: 500,
      child: Consumer(
        builder: (context, watch, child) {
          final _model = watch(taskViewProviderFamily(widget.param));
          return ListView(
            children: <Widget>[
              _buildInputField(
                context,
                title: 'Title',
//                textEditingController:
//                    watch(taskViewProviderFamily(widget.param)).titleController,
                textEditingController: _model.titleController,

//                errorText:
//                    watch(taskViewProviderFamily(widget.param)).validateTitle
//                        ? watch(taskViewProviderFamily(widget.param))
//                            .strValidateTitle
                //                  :null,
                errorText:
                    _model.validateTitle ? _model.strValidateTitle : null,

                didChanged: (_) {
                  //watch(taskViewProviderFamily(widget.param))
                  _model.updateValidateTitle();
                },
              ),
              _buildInputField(
                context,
                title: 'subtitle',
                textEditingController:
                    //   watch(taskViewProviderFamily(widget.param))
                    _model.subtitleController,
                errorText: null,
              ),
              ElevatedButton(
                  onPressed: () => _selectDate(context),
                  child: new Text(
                      "現在の締め切り : ${_date.year}/${_date.month}/${_date.day}")),
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
          ? viewModel.updateTask(
              widget.editTask,
            )
          : viewModel.addTask(widget.param, _date);
      Navigator.of(context).pop();
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

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: _date,
        firstDate: new DateTime(2016),
        lastDate: new DateTime.now().add(new Duration(days: 360)));
    if (picked != null) setState(() => _date = picked);
  }
}
