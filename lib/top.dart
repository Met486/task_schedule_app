import 'package:flutter/material.dart';

class TopPage extends StatelessWidget {
  Size size;

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Center(
      child: Container(
        width: size.width * 0.8,
        height: size.height * 0.8,
        color: Colors.grey,
        child: Column(
          children: [const Text('top'), const Text('後々カレンダーに変更')],
        ),
        alignment: Alignment.topCenter,
      ),
    );
  }
}
