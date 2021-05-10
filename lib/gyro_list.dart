import 'dart:async';

import 'package:async/async.dart';

class GyroList {
  List<double> gyroStack = [];

  GyroList() {
    gyroStack = [];
    kill();
  }

  void addList(double a) {
    if (a > 0) {
      a = 1;
    } else {
      a = -1;
    }
    gyroStack.add(a);
    print('gyroStack : $gyroStack');
    // listKill();
    // kill();
    _co?.cancel();
  }

  void listKill() async {
    await Future.delayed(Duration(milliseconds: 300));
    gyroStack = [];
    print('listKillが実行されました');
  }

  // void checker(){
  //   if()
  // }

  CancelableOperation<void> _co;

  Future<void> kill() async {
    while (1 == 1) {
      _co = CancelableOperation<void>.fromFuture(
        Future<void>.delayed(const Duration(seconds: 2)),
      );

      await _co.valueOrCancellation();
      if (_co.isCanceled || gyroStack.length == 0) {
      } else {
        print('listが消える ${DateTime.now()}');
        gyroStack = [];
      }
    }
  }
}
