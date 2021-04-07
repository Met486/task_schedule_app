import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_schedule_app/home_page.dart';
import 'package:task_schedule_app/task_view_model/task_view_model.dart';
import 'package:task_schedule_app/task_view_model/task_view_model2.dart';
import 'package:task_schedule_app/task_view_model/task_view_model3.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => TaskViewModel()),
      ChangeNotifierProvider(create: (context) => TaskViewModel2()),
      ChangeNotifierProvider(create: (context) => TaskViewModel3()),
    ],
    child: HomePage(),
  )
//    ChangeNotifierProvider(
//      create: (context) => TaskViewModel(),
//      child: HomePage(),
//    ),
      );
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
