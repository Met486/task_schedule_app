//タスクを管理する3つの大枠を管理

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_schedule_app/micro_task_view_model/micro_task_list_view.dart';

class TaskList extends StatefulWidget {
  TaskList({Key key}) : super(key: key);

  @override
  _TaskListState createState() => _TaskListState();
}

/// This is the private State class that goes with MyStatefulWidget.
class _TaskListState extends State<TaskList> with TickerProviderStateMixin {
  bool selectedLeft = false;
  bool selectedCenter = false;
  bool selectedRight = false;
  bool selectedXOR = false;

  int taskCount;
  List<int> mode = [0];
  final _myListKey = GlobalKey<AnimatedListState>();

  bool _isEnabled = false;
  final List<Color> colorList = [
    Colors.green[100],
    Colors.red[100],
    Colors.blue[100],
    Colors.yellow[100],
    Colors.purple[100]
  ];
  SharedPreferences prefs;

  ScrollController con = ScrollController();
  bool scrolled = false;

  bool isVisible = false;
  Size size;

  @override
  void initState() {
    super.initState();
    preload();
    selectedLeft = false;
    selectedRight = false;
    selectedCenter = false;
    selectedXOR = false;
    scrolled = true;
  }

  void preload() async {
    prefs = await SharedPreferences.getInstance();
    if (prefs.getInt('taskCount') == null) {
      prefs.setInt('taskCount', 1);
    } else {}

    taskCount = prefs.getInt('taskCount');
    for (int i = 0; i < taskCount - 1; i++) {
      mode.add(0);
    }
    if (taskCount != mode.length) {
      mode.clear();
      for (int i = 0; i < taskCount; i++) {
        mode.add(0);
      }
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Consumer(builder: (context, taskViewModel, _) {
      return AnimatedContainer(
          color: Colors.yellow[200], //TODO 表示領域確認
          duration: Duration(seconds: 1),
          curve: Curves.fastOutSlowIn,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: AnimatedContainer(
                  duration: Duration(seconds: 2),
                  curve: Curves.fastOutSlowIn,
                  child: LayoutBuilder(
                    builder: (context, BoxConstraints constraints) {
                      return _buildList();
                      // return _buildListR();
                    },
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    child: const Text('+'),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.white,
                      onPrimary: Colors.black,
                      shape: const CircleBorder(
                        side: BorderSide(
                          color: Colors.black,
                          width: 1,
                          style: BorderStyle.solid,
                        ),
                      ),
                    ),
                    onPressed: _isEnabled
                        ? null
                        : () {
                            countUp();
                            // countUpR();
                          },
                  ),
                  ElevatedButton(
                    child: const Text('-'),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.white,
                      onPrimary: Colors.black,
                      shape: const CircleBorder(
                        side: BorderSide(
                          color: Colors.black,
                          width: 1,
                          style: BorderStyle.solid,
                        ),
                      ),
                    ),
                    onPressed: _isEnabled
                        ? null
                        : () {
                            countDown();
                            // countDownR();
                          },
                  ),
                ],
              ),
            ],
          ));
    });
  }

  Widget _buildList() {
    return ListView.builder(
      scrollDirection: (MediaQuery.of(context).size.width > 600)
          ? Axis.horizontal
          : Axis.vertical,
      itemCount: taskCount ?? 1,
      itemBuilder: (context, index) {
        print('taskCount is $taskCount');
        return AnimationConfiguration.staggeredList(
            position: index,
            duration: const Duration(milliseconds: 300),
            child: SlideAnimation(
                verticalOffset: size.height * 0.8,
                child: FadeInAnimation(child: taskViewContainer(index))));
      },
    );
  }

  Widget _buildListR() {
    return AnimatedList(
      key: _myListKey,
      initialItemCount: mode.length,
      itemBuilder: (context, index, Animation animation) {
        return SlideTransition(
            position: Tween<Offset>(
              begin: Offset.zero,
              end: const Offset(10, 0),
            ).animate(CurvedAnimation(
                curve: Curves.linear,
                parent: AnimationController(
                  duration: const Duration(seconds: 0),
                  vsync: this,
                ))),
            child: taskViewContainer(index));
      },
    );
  }

  Widget taskViewContainer(int p) {
    return GestureDetector(
      onTap: () {
        setState(() {
          testXorChanged(p);
        });
      },
      child: AnimatedContainer(
        width: size.width * 0.8,
        height: testHeightValue(mode[p]),
        color: testContainerColorValue(p),
        duration: Duration(seconds: 1),
        curve: Curves.fastOutSlowIn,
        // margin: paddingValue(p + 1),
        // padding: paddingValue(p + 1),
        margin: testMarginValue(p),
        padding: testPaddingValue(p),
        child: MicroTaskListView(
          param: (p + 1).toString(),
        ),
      ),
    );
  }

  void countUp() {
    setState(() {
      if (taskCount < 5) {
        taskCount += 1;
        prefs.setInt('taskCount', taskCount);
        mode.add(0);
      }
    });
    print('[countUP]taskCount : $taskCount');
    print('[countUP]mode : $mode');
  }

  void countUpR() {
    setState(() {
      if (taskCount < 5) {
        taskCount += 1;
        prefs.setInt('taskCount', taskCount);
        mode.add(0);
        _myListKey.currentState
            .insertItem(mode.length - 1, duration: Duration(seconds: 1));
      }
    });
    print('[countUP]taskCount : $taskCount');
    print('[countUP]mode : $mode');
  }

  void countDown() async {
    setState(() {
      if (taskCount > 1) {
        _isEnabled = true;
        mode[mode.length - 1] = 2;
        print('[countDown]:mode $mode');
        Timer(const Duration(milliseconds: 700), _testTimer);
        checker();
      }
    });
    print('[countDown]taskCount : $taskCount');
    print(mode);
  }

  void _testTimer() {
    setState(() {
      taskCount -= 1;
      mode.removeLast();
      prefs.setInt('taskCount', taskCount);
      // checker();

      _isEnabled = false;
    });
  }

  void countDownR() {
    setState(() {
      if (taskCount > 1) {
        taskCount -= 1;
        prefs.setInt('taskCount', taskCount);
        _myListKey.currentState.removeItem(mode.length - 1,
            (context, animation) => taskViewContainer(mode.length - 1));
        checker();
        mode.removeLast();
      }
    });
    print('[countDown]taskCount : $taskCount');
    print(mode);
  }

  void checker() {
    print('[checker]run');
    setState(() {
      if (!mode.contains(1) && !mode.contains(0)) {
        print('[checker]mode contains 1');
        for (int i = 0; i < mode.length; i++) {
          mode[i] = 0;
        }
        mode[mode.length - 1] = 2;
      }
    });
  }

  void xorChanged() {
    if (selectedLeft == false &&
        selectedCenter == false &&
        selectedRight == false) {
      setState(() {
        selectedXOR = true;
      });
    } else {
      setState(() {
        selectedXOR = false;
      });
    }
  }

  void testXorChanged(int p) {
    if (mode.contains(1)) {
      for (int i = 0; i < taskCount; i++) {
        mode[i] = 0;
      }
    } else {
      for (int i = 0; i < taskCount; i++) {
        mode[i] = 2;
      }
      mode[p] = 1;
    }
    print("[mode] : ${mode}");
  }

  double widthValue(int place) {
    switch (place) {
      case 1:
        {
          if (selectedCenter ^ selectedRight) {
            return 0;
          }
          if (selectedLeft == true) {
            return size.width * 0.8;
          }
          return size.width * 0.2;
        }
      case 2:
        {
          if (selectedLeft ^ selectedRight) {
            return 0;
          }
          if (selectedCenter == true) {
            return size.width * 0.8;
          }
          return size.width * 0.2;
        }
      case 3:
        {
          if (selectedLeft ^ selectedCenter) {
            return 0;
          }
          if (selectedRight == true) {
            return size.width * 0.8;
          }
          return size.width * 0.2;
        }
    }
    return size.width * 0.2;
  }

  double heightValue(int place) {
    switch (place) {
      case 1:
        {
          if (selectedCenter ^ selectedRight) {
            return 0;
          }
          if (selectedLeft == true) {
            return size.height * 0.8;
          }
          return size.height * 0.2;
        }
      case 2:
        {
          if (selectedLeft ^ selectedRight) {
            return 0;
          }
          if (selectedCenter == true) {
            return size.height * 0.8;
          }
          return size.height * 0.2;
        }
      case 3:
        {
          if (selectedLeft ^ selectedCenter) {
            return 0;
          }
          if (selectedRight == true) {
            return size.height * 0.8;
          }
          return size.height * 0.2;
        }
    }
    return size.height * 0.2;
  }

  double testHeightValue(int p) {
    if (p == 0) {
      print('p==0');
      print('[testHeightValue] mode : $mode');
      return size.height * 0.75 / taskCount;
    } else if (p == 2) {
      print('p==2');
      return 0;
    }
    return size.height * 0.8;
  }

  Color textColorValue(int place) {
    switch (place) {
      case 1:
        {
          if (selectedCenter ^ selectedRight) {
            return Colors.white.withAlpha(0);
          }
          return Colors.black;
        }
      case 2:
        {
          if (selectedCenter ^ selectedRight) {
            return Colors.white.withAlpha(0);
          }
          return Colors.black;
        }
      case 3:
        {
          if (selectedLeft ^ selectedCenter) {
            return Colors.white.withAlpha(0);
          }
          return Colors.black;
        }
    }
    return Colors.black;
  }

  Color testContainerColorValue(int p) {
    if (mode[p] == 2) {
      // return colorList[p].withAlpha(0);
      return Colors.yellow[100].withAlpha(0);
    } else {
      return colorList[p];
    }
  }

  Color containerColorValue(int place) {
    switch (place) {
      case 1:
        {
          if (selectedCenter ^ selectedRight) {
            return Colors.green.withAlpha(0);
          }
          return Colors.green[100];
        }
      case 2:
        {
          if (selectedLeft ^ selectedRight) {
            return Colors.red.withAlpha(0);
          }
          return Colors.red[100];
        }
      case 3:
        {
          if (selectedLeft ^ selectedCenter) {
            return Colors.blue.withAlpha(0);
          }
          return Colors.blue[100];
        }
    }
    return Colors.white;
  }

  EdgeInsets testPaddingValue(int p) {
    if (mode[p] == 2) {
      return EdgeInsets.all(0);
    }
    return EdgeInsets.only(bottom: 5);
  }

  EdgeInsets testMarginValue(int p) {
    if (mode[p] == 2) {
      return EdgeInsets.all(0);
    }
    return EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5);
  }

  EdgeInsets paddingValue(int place) {
    switch (place) {
      case 1:
        {
          //if (selectedCenter == true || selectedRight == true) {
          if (selectedCenter ^ selectedRight) {
            return EdgeInsets.all(0);
          }

          return EdgeInsets.all(20);
        }
      case 2:
        {
          // if (selectedLeft == true || selectedRight == true) {
          if (selectedLeft ^ selectedRight) {
            return EdgeInsets.all(0);
          }

          return EdgeInsets.all(20);
        }
      case 3:
        {
          //    if (selectedLeft == true || selectedCenter == true) {
          if (selectedLeft ^ selectedCenter) {
            return EdgeInsets.all(0);
          }
          return EdgeInsets.all(20);
        }
    }
    return EdgeInsets.all(20);
  }
}
