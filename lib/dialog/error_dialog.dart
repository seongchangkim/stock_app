import 'package:flutter/material.dart';

class ErrorDialog extends StatelessWidget {
  final String content;
  const ErrorDialog({super.key, required this.content});

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
                  child: const Text(
                    "오류",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              Expanded(
                  flex: 2,
                  child: Center(
                    child: Container(
                      child: Text(content),
                    ),
                  )),
              Expanded(
                  flex: 1,
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                        decoration: const BoxDecoration(
                            border: Border(
                                top: BorderSide(
                                    width: 1, color: Colors.black38))),
                        child: Container(
                          margin: const EdgeInsets.only(top: 10),
                          child: Padding(
                            padding:
                                EdgeInsets.symmetric(horizontal: _width * 0.35),
                            child: const Text(
                              "확인",
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w600),
                            ),
                          ),
                        )),
                  ))
            ],
          ),
        ));
  }
}
