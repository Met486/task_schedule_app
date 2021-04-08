//タスクを管理する3つの大枠を管理

import 'package:flutter/material.dart';
import 'package:task_schedule_app/micro_task_view_model/micro_task_list_view.dart';
import 'package:task_schedule_app/micro_task_view_model/micro_task_list_view2.dart';
import 'package:task_schedule_app/micro_task_view_model/micro_task_list_view3.dart';

class TaskList extends StatefulWidget {
  TaskList({Key key}) : super(key: key);

  @override
  _TaskListState createState() => _TaskListState();
}

/// This is the private State class that goes with MyStatefulWidget.
class _TaskListState extends State<TaskList> {
  bool selectedLeft = false;
  bool selectedCenter = false;
  bool selectedRight = false;
  bool selectedXOR = false;

  ScrollController con = ScrollController();
  bool scrolled = false;

  bool isVisible = false;
  Size size;

  @override
  void initState() {
    super.initState();
    selectedLeft = false;
    selectedRight = false;
    selectedCenter = false;
    selectedXOR = false;
    scrolled = true;
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    //    final Size size = MediaQuery.of(context).size;
    return AnimatedContainer(
        color: Colors.white24, //TODO 表示領域確認
        duration: Duration(seconds: 1),
        curve: Curves.fastOutSlowIn,
        child: Center(
          child: LayoutBuilder(
            builder: (context, BoxConstraints constraints) {
              if (constraints.maxWidth > 600) {
                return _buildWideList();
              } else {
                return _buildNormalList();
              }
            },
          ),
        ));
  }

  Widget _buildWideList() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AnimatedContainer(
//                alignment:
//                    selectedLeft ? Alignment.center : Alignment.centerLeft
          duration: Duration(seconds: 2),
          curve: Curves.fastOutSlowIn,
          child: GestureDetector(
            onTap: () {
              setState(() {
                selectedLeft = !selectedLeft;
              });
              xorChanged(); //TODO Xor
            },
            child: AnimatedContainer(
              width: widthValue(1),
              height: selectedLeft ? size.height * 0.8 : size.height * 0.4,
              color: containerColorValue(1),
              duration: Duration(seconds: 1),
              curve: Curves.fastOutSlowIn,
              margin: paddingValue(1),
              padding: paddingValue(1),
              child: MicroTaskListView(),
            ),
          ),
        ),
        AnimatedContainer(
//                alignment:
//                    selectedCenter ? Alignment.center : Alignment.centerLeft,
          duration: Duration(seconds: 2),
          curve: Curves.fastOutSlowIn,
          child: GestureDetector(
            onTap: () {
              setState(() {
                selectedCenter = !selectedCenter;
              });
              xorChanged(); //todo
            },
            child: AnimatedContainer(
              width: widthValue(2),
              height: selectedCenter ? size.height * 0.8 : size.height * 0.4,
              color: containerColorValue(2),
              duration: Duration(seconds: 1),
              curve: Curves.fastOutSlowIn,
              margin: paddingValue(2),
              padding: paddingValue(2),
              child: MicroTaskListView2(),
            ),
          ),
        ),
        AnimatedContainer(
//                alignment:
//                    selectedCenter ? Alignment.center : Alignment.centerLeft,
          duration: Duration(seconds: 2),
          curve: Curves.ease,
          child: GestureDetector(
              onTap: () {
                setState(() {
                  selectedRight = !selectedRight;
                });
                xorChanged(); //todo
              },
              child: AnimatedContainer(
                width: widthValue(3),
                height: selectedRight ? size.height * 0.8 : size.height * 0.4,
                color: containerColorValue(3),
                duration: Duration(seconds: 1),
                curve: Curves.fastOutSlowIn,
                margin: paddingValue(3),
                padding: paddingValue(3),
                child: MicroTaskListView3(),
              )),
        ),
      ],
    );
  }

  Widget _buildNormalList() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AnimatedContainer(
//                alignment:
//                    selectedLeft ? Alignment.center : Alignment.centerLeft
          duration: Duration(seconds: 2),
          curve: Curves.fastOutSlowIn,
          child: GestureDetector(
            onTap: () {
              setState(() {
                selectedLeft = !selectedLeft;
              });
              xorChanged(); //TODO Xor
            },
            child: AnimatedContainer(
              //width: widthValue(1),
              //height: selectedLeft ? size.height * 0.8 : size.height * 0.2,
              width: selectedLeft ? size.width * 0.8 : size.width * 0.8,
              height: heightValue(1),
              color: containerColorValue(1),
              duration: Duration(seconds: 1),
              curve: Curves.fastOutSlowIn,
              margin: paddingValue(1),
              padding: paddingValue(1),
              child: MicroTaskListView(),
            ),
          ),
        ),
        AnimatedContainer(
//                alignment:
//                    selectedCenter ? Alignment.center : Alignment.centerLeft,
          duration: Duration(seconds: 2),
          curve: Curves.fastOutSlowIn,
          child: GestureDetector(
            onTap: () {
              setState(() {
                selectedCenter = !selectedCenter;
              });
              xorChanged(); //todo
            },
            child: AnimatedContainer(
//              width: widthValue(2),
//              height: selectedCenter ? size.height * 0.8 : size.height * 0.2,
              width: selectedLeft ? size.width * 0.8 : size.width * 0.8,
              height: heightValue(2),
              color: containerColorValue(2),
              duration: Duration(seconds: 1),
              curve: Curves.fastOutSlowIn,
              margin: paddingValue(2),
              padding: paddingValue(2),
              child: MicroTaskListView2(),
            ),
          ),
        ),
        AnimatedContainer(
//                alignment:
//                    selectedCenter ? Alignment.center : Alignment.centerLeft,
          duration: Duration(seconds: 2),
          curve: Curves.ease,
          child: GestureDetector(
              onTap: () {
                setState(() {
                  selectedRight = !selectedRight;
                });
                xorChanged(); //todo
              },
              child: AnimatedContainer(
//                width: widthValue(3),
//                height: selectedRight ? size.height * 0.8 : size.height * 0.2,
                width: selectedLeft ? size.width * 0.8 : size.width * 0.8,
                height: heightValue(3),
                color: containerColorValue(3),
                duration: Duration(seconds: 1),
                curve: Curves.fastOutSlowIn,
                margin: paddingValue(3),
                padding: paddingValue(3),
                child: MicroTaskListView3(),
              )),
        ),
      ],
    );
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

  Color textColorValue(int place) {
    switch (place) {
      case 1:
        {
          //    if (selectedCenter == true || selectedRight == true) {
          if (selectedCenter ^ selectedRight) {
            return Colors.white.withAlpha(0);
          }
          return Colors.black;
        }
      case 2:
        {
          //   if (selectedLeft == true || selectedRight == true) {
          if (selectedCenter ^ selectedRight) {
            return Colors.white.withAlpha(0);
          }
          return Colors.black;
        }
      case 3:
        {
          //    if (selectedLeft == true || selectedCenter == true) {
          if (selectedLeft ^ selectedCenter) {
            return Colors.white.withAlpha(0);
          }
          return Colors.black;
        }
    }
    return Colors.black;
  }

  Color containerColorValue(int place) {
    switch (place) {
      case 1:
        {
          //         if (selectedCenter == true || selectedRight == true) {
          if (selectedCenter ^ selectedRight) {
            return Colors.green.withAlpha(0);
          }
          return Colors.green[100];
        }
      case 2:
        {
          //     if (selectedLeft == true || selectedRight == true) {
          if (selectedLeft ^ selectedRight) {
            return Colors.red.withAlpha(0);
          }
          return Colors.red[100];
        }
      case 3:
        {
          //  if (selectedLeft == true || selectedCenter == true) {
          if (selectedLeft ^ selectedCenter) {
            return Colors.blue.withAlpha(0);
          }
          return Colors.blue[100];
        }
    }
    return Colors.white;
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
