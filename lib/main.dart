import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_schedule_app/home_page.dart';
import 'package:task_schedule_app/task_view_model/task_view_model.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => TaskViewModel(param: '1')),
      ChangeNotifierProvider(create: (context) => TaskViewModel(param: '2')),
      ChangeNotifierProvider(create: (context) => TaskViewModel(param: '3')),
    ],
    child: HomePage(),
  ));
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
