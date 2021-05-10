import 'dart:collection';

import 'package:table_calendar/table_calendar.dart';
import 'package:task_schedule_app/db_provider.dart';
import 'package:task_schedule_app/task.dart';

final kTasks = LinkedHashMap<DateTime, List<Task>>(
  equals: isSameDay,
  hashCode: getHashCode,
)..addAll(_tasksSource);
// )..addAll(_kTasksSource);
// )..addAll(_tasksSourceBM);

init() async {
  _tasksSource.clear();

  await _kTasksSource.clear();
  await _tasksSourceB.clear();
  await listDateElements.clear();

  await getT();
  await generateList();
  // print('clear kTasks ');

  await kTasks.clear();

  await _tasksSource.clear();

  print('init listdate length is ${listDateElements.length}');

  _tasksSource = await Map.fromIterable(
      List.generate(_taskListDate.length, (index) => index),
      // List.generate(listDateElements.length, (index) => index),
      key: (item) => listDateElements.elementAt(item),
      // ignore: top_level_instance_method
      value: (item) => _taskListDate.elementAt(item));
  await kTasks.addAll(_tasksSource);

  kTasks.forEach((key, value) {
    print('key:${key},value:${value}');
  });
  print('all displayed');
}

getT() async {
  List<DateTime> tempListDate = [];

  if (_tasksSourceB.length < 1) {
    _tasksSourceB.addAll(await DBProvider.db.getAllTasks());
  }
  if (listDateElements.length == 0) {
    print('listDateElement length is 0');
    await _tasksSourceB
        .forEach((element) => tempListDate.add(element.deadlineAt));
  }
  listDateElements.addAll(new Set<DateTime>.from(tempListDate).toList());
}

final List<DateTime> listDateElements = [];

Future<List<Task>> getTaskList(int dt) async {
  // var li = await DBProvider.db.getAllTasksDays(listDateElements.elementAt(dt)) todo
  // as List<Task>;
  var li = await DBProvider.db.getAllTasksDays(listDateElements.elementAt(dt));

  // return li; todo
  return Future<List<Task>>.value(li);
}

final List<List<Task>> _taskListDate = [];

generateList() {
  if (_taskListDate.length < 1) {
    for (var value in listDateElements) {
      List<Task> _tempList = [];
      _tasksSourceB.forEach((element) {
        if (element.deadlineAt == value) {
          _tempList.add(element);
        }
      });

      _taskListDate.add(_tempList);
    }
  }
}

List<Task> getList(int dt) {
  List<Task> li = getTaskList(dt) as List<Task>;
  return li;
}

final _kTasksSource = Map.fromIterable(List.generate(50, (index) => index),
    key: (item) => DateTime.utc(2020, 10, item * 5),
    value: (item) => List.generate(item % 4 + 1, (index) => Task()));
//

Map<DateTime, List<Task>> _tasksSource =
    Map.fromIterable(List.generate(listDateElements.length, (index) => index),
        key: (item) => listDateElements.elementAt(item),
        // ignore: top_level_instance_method
        value: (item) =>
            // DBProvider.db.getAllTasksDays(listDateElements.elementAt(item)));
            // getList(item));
            _taskListDate.elementAt(item));

// final List _tasksSourceB = {DBProvider.db.getAllTasks()} as List;
final List _tasksSourceB = [];

int getHashCode(DateTime key) {
  return key.day * 1000000 + key.month * 10000 + key.year;
}

List<DateTime> daysInRange(DateTime first, DateTime last) {
  final dayCount = last.difference(first).inDays + 1;
  return List.generate(
    dayCount,
    (index) => DateTime.utc(first.year, first.month, first.day + index),
  );
}

final kNow = DateTime.now();
final kFirstDay = DateTime(kNow.year, kNow.month - 3, kNow.day);
final kLastDay = DateTime(kNow.year, kNow.month + 3, kNow.day);
