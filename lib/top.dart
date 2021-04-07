import 'package:flutter/material.dart';

class TopPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: 300,
          height: 300,
          color: Colors.green,
          child: const Text('top'),
          alignment: Alignment.center,
        ),
      ),
    );
  }
}
