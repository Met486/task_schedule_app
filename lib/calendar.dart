// Copyright 2019 Aleksander Woźniak
// SPDX-License-Identifier: Apache-2.0

import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:task_schedule_app/add_dialog/add_dialog.dart';
import 'package:task_schedule_app/task.dart';
import 'package:task_schedule_app/utils.dart';

class TableTasksExample extends StatefulWidget {
  @override
  _TableTasksExampleState createState() => _TableTasksExampleState();
}

class _TableTasksExampleState extends State<TableTasksExample> {
  ValueNotifier<List<Task>> _selectedTasks;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode
      .toggledOff; // Can be toggled on/off by longpressing a date
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay;
  DateTime _rangeStart;
  DateTime _rangeEnd;

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _selectedTasks = ValueNotifier(_getTasksForDay(_selectedDay));
  }

  @override
  void dispose() {
    _selectedTasks.dispose();
    super.dispose();
  }

  List<Task> _getTasksForDay(DateTime day) {
    return kTasks[day] ?? [];
  }
  //

  List<Task> _getTasksForRange(DateTime start, DateTime end) {
    // Implementation example
    final days = daysInRange(start, end);

    return [
      for (final d in days) ..._getTasksForDay(d),
    ];
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        init();
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
        _rangeStart = null; // Important to clean those
        _rangeEnd = null;
        _rangeSelectionMode = RangeSelectionMode.toggledOff;
      });

      _selectedTasks.value = _getTasksForDay(selectedDay);
    }
  }

  void _onRangeSelected(DateTime start, DateTime end, DateTime focusedDay) {
    setState(() {
      _selectedDay = null;
      _focusedDay = focusedDay;
      _rangeStart = start;
      _rangeEnd = end;
      _rangeSelectionMode = RangeSelectionMode.toggledOn;
      init();
    });

    // `start` or `end` could be null
    if (start != null && end != null) {
      _selectedTasks.value = _getTasksForRange(start, end);
    } else if (start != null) {
      _selectedTasks.value = _getTasksForDay(start);
    } else if (end != null) {
      _selectedTasks.value = _getTasksForDay(end);
    }
  }

  final List<Color> colorList = [
    Colors.green[100],
    Colors.red[100],
    Colors.blue[100],
    Colors.yellow[100],
    Colors.purple[100]
  ];

  @override
  Widget build(BuildContext context) {
    init();
    print('build complete');
    return Scaffold(
      appBar: AppBar(
        title: Text('TableCalendar - Tasks'),
      ),
      body: Column(
        children: [
          ElevatedButton(
              onPressed: () {
                setState(() {
                  init();
                });
              },
              child: Text('debug')),
          TableCalendar<Task>(
            firstDay: kFirstDay,
            lastDay: kLastDay,
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            rangeStartDay: _rangeStart,
            rangeEndDay: _rangeEnd,
            calendarFormat: _calendarFormat,
            rangeSelectionMode: _rangeSelectionMode,
            eventLoader: _getTasksForDay,
            startingDayOfWeek: StartingDayOfWeek.monday,
            calendarStyle: CalendarStyle(
              // Use `CalendarStyle` to customize the UI
              outsideDaysVisible: true,
            ),
            onDaySelected: _onDaySelected,
            onRangeSelected: _onRangeSelected,
            onFormatChanged: (format) {
              if (_calendarFormat != format) {
                setState(() {
                  _calendarFormat = format;
                });
              }
            },
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
          ),
          const SizedBox(height: 8.0),
          Expanded(
            child: ValueListenableBuilder<List<Task>>(
              valueListenable: _selectedTasks,
              builder: (context, value, _) {
                return ListView.builder(
                  itemCount: value.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 12.0,
                        vertical: 4.0,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: ListTile(
                        tileColor: colorList[value.elementAt(0).taskType],
                        // onTap: () => print('${value[index].title}'),
                        onTap: () async {
                          print("タスクをタップしました");
                          await showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('Task'),
                                  content: AddDialog(
                                    editTask: value[index],
                                  ),
                                );
                              }).then((_) {
                            setState(() {
                              init();
                              // todo DBの処理が終わってない段階で更新をかけている可能性が高い
                              // TableTasksExample();
                              // build(context);
                            });
                          });
                        },
                        title: Text('${value[index].title}'),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
