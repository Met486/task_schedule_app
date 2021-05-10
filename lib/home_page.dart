import 'package:flutter/material.dart';
import 'package:task_schedule_app/settings.dart';
import 'package:task_schedule_app/task_list.dart';

import 'calendar.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  static List<Widget> _pageList = [
    TableTasksExample(),
    // gyro(),
    TaskList(),
    SettingPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: _pageList[_selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              title: Text('top'),
              icon: Icon(Icons.home),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.schedule),
              title: Text('schedule'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              title: Text('settings'),
            ),
          ],
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}
