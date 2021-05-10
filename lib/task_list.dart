//タスクを管理する3つの大枠を管理

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_schedule_app/micro_task_view_model/micro_task_list_view.dart';

class TaskList extends StatefulWidget {
  TaskList({Key key}) : super(key: key);

  @override
  _TaskListState createState() => _TaskListState();
}

class Model {
  final String title;
  final String subTitle;
  final String key;

  Model({
    @required this.title,
    @required this.subTitle,
    @required this.key,
  });
}

/// This is the private State class that goes with MyStatefulWidget.
class _TaskListState extends State<TaskList> with TickerProviderStateMixin {
  int taskCount;
  List<int> mode = [0];

  bool _isEnabled = false;
  final List<Color> colorList = [
    Colors.green[100],
    Colors.red[100],
    Colors.blue[100],
    Colors.yellow[100],
    Colors.purple[100]
  ];
  SharedPreferences prefs;
  final bool autoFocus = true;

  ScrollController con = ScrollController();
  bool scrolled = false;

  bool isVisible = false;
  Size size;

  @override
  void initState() {
    this.autoFocus;
    super.initState();
    preload();
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
    return Scaffold(
      floatingActionButton: Row(
        // verticalDirection: VerticalDirection.up,
        // mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(bottom: 5, left: 20),
            child: FloatingActionButton(
              backgroundColor: _isEnabled ? Colors.grey : Colors.redAccent,
              child: Icon(FontAwesomeIcons.plus),
              onPressed: _isEnabled
                  ? null
                  : () {
                      countUp();
                      // countUpR();
                    },
            ),
          ),
          Container(
            margin: EdgeInsets.only(bottom: 5, left: 16),
            child: FloatingActionButton(
              backgroundColor: _isEnabled ? Colors.grey : Colors.amberAccent,
              child: FaIcon(FontAwesomeIcons.minus),
              onPressed: _isEnabled
                  ? null
                  : () {
                      countDown();
                      // countDownR();
                    },
            ),
          )
        ],
      ),
      body: Consumer(builder: (context, taskViewModel, _) {
        return Focus(
          autofocus: autoFocus,
          child: Stack(
            fit: StackFit.loose,
            children: [
              AnimatedContainer(
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
                            },
                          ),
                        ),
                      ),
                    ],
                  )),
              Positioned(
                right: 0,
                bottom: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [],
                ),
              )
            ],
          ),
        );
      }),
    );
  }

  Widget _buildList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(), //スクロールを制限
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
                child: FadeInAnimation(
                    child: Focus(
                        autofocus: autoFocus,
                        child: taskViewContainer(index)))));
      },
    );
  }

  Widget taskViewContainer(int p) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _xorChanged(p);
        });
      },
      child: AnimatedContainer(
        width: size.width * 0.8,
        height: _heightValue(mode[p]),
        color: _containerColorValue(p),
        duration: Duration(seconds: 1),
        curve: Curves.fastOutSlowIn,
        margin: _marginValue(p),
        padding: _paddingValue(p),
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

  void countDown() async {
    setState(() {
      if (taskCount > 1) {
        _isEnabled = true;
        checker();

        mode[mode.length - 1] = 2;
        print('[countDown]:mode $mode');
        Timer(const Duration(milliseconds: 700), _timer);
      }
    });
    print('[countDown]taskCount : $taskCount');
    print(mode);
  }

  void _timer() {
    setState(() {
      taskCount -= 1;
      mode.removeLast();
      prefs.setInt('taskCount', taskCount);
      // checker();

      _isEnabled = false;
    });
  }

  void checker() {
    print('[checker]run');
    setState(() {
      // if (!mode.contains(1) && !mode.contains(0)) {
      if (mode[mode.length - 1] == 1) {
        print('[checker]mode contains 1');
        for (int i = 0; i < mode.length; i++) {
          mode[i] = 0;
        }
        mode[mode.length - 1] = 2;
      }
    });
  }

  void _xorChanged(int p) {
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

  double _heightValue(int p) {
    if (p == 0) {
      print('p==0');
      print('[HeightValue] mode : $mode');
      return (size.height * 0.85) / (taskCount ?? 1);
    } else if (p == 2) {
      print('p==2');
      return 0;
    }
    return size.height * 0.85;
  }

  Color _containerColorValue(int p) {
    if (mode[p] == 2) {
      // return colorList[p].withAlpha(0);
      return Colors.yellow[100].withAlpha(0);
    } else {
      return colorList[p];
    }
  }

  EdgeInsets _paddingValue(int p) {
    if (mode[p] == 2) {
      return EdgeInsets.all(0);
    }
    return EdgeInsets.only(bottom: 5);
  }

  EdgeInsets _marginValue(int p) {
    if (mode[p] == 2) {
      return EdgeInsets.all(0);
    }
    return EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5);
  }
}
