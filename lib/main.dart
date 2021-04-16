import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_schedule_app/home_page.dart';
import 'package:task_schedule_app/task_view_model/task_view_model.dart';

final taskViewProviderFamily =
    ChangeNotifierProviderFamily((ref, String param) => TaskViewModel(param));

SharedPreferences testPrefs;

void main() {
  runApp(ProviderScope(child: HomePage()));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('TaskSchedule'),
        ),
        body: HomePage(),
      ),
    );
  }
}
