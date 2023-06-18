import 'package:flutter/material.dart';

class ConfirmDialog extends StatelessWidget {
  final String title;
  final String content;
  final void Function()? func;

  const ConfirmDialog(
      {super.key,
      required this.title,
      required this.content,
      required this.func});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double _height = size.height;
    double _width = size.width;
    return Dialog(
        alignment: Alignment.center,
        child: Container(
          height: _height * 0.25,
          width: double.infinity,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                flex: 1,
                child: Container(
                  margin: const EdgeInsets.only(top: 20),
                  child: Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),),
                ),
              ),
              Expanded(
                flex: 2,
                child: Center(
                  child: Container(
                    child: Text(content),
                  ),
                )
              ),
              Expanded(
                flex: 1,
                child: GestureDetector(
                  onTap: () {
                    if (func != null) {
                      func!();
                    } else {
                      Navigator.pop(context);
                    }
                  },
                  child: Container(
                    decoration: const BoxDecoration(
                      border: Border(
                        top: BorderSide(
                          width: 1,
                          color: Colors.black38
                        )
                      )
                    ),
                    child: Container(
                      margin: const EdgeInsets.only(top:10),
                      child : Padding(
                          padding: EdgeInsets.symmetric(horizontal: _width * 0.35),
                          child: const Text("확인", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),),
                        ),
                    )
                    
                  ),
                )
              )
            ],
          ),
        ));
  }
}
