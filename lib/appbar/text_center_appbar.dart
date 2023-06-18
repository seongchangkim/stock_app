import 'package:flutter/material.dart';

class TextCenterAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final AppBar appBar;
  const TextCenterAppBar(
      {super.key, required this.title, required this.appBar});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      leading: GestureDetector(
        onTap: () => Navigator.pop(context),
        child: const Icon(Icons.arrow_back_ios, color: Colors.black),
      ),
      title: Text(
        title,
        style: const TextStyle(
            fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold),
      ),
      backgroundColor: Colors.white24,
      elevation: 0,
    );
  }
  
  @override
  Size get preferredSize => Size.fromHeight(appBar.preferredSize.height);
}
