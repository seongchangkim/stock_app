import 'package:flutter/material.dart';

class UserInputBtn extends StatelessWidget {
  final double width;
  final String text;
  final Color backgroundColor;
  UserInputBtn(
      {super.key,
      required this.width,
      required this.text,
      this.backgroundColor = Colors.blueAccent});

  @override
  Widget build(BuildContext context) {
    return Container(
        width: width,
        height: 50,
        decoration: BoxDecoration(
          color: backgroundColor,
        ),
        child: Center(
          child: Text(
            text,
            style: const TextStyle(color: Colors.white, fontSize: 15),
          ),
        ));
  }
}
