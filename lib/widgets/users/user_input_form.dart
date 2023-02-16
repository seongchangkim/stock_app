import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'dart:io' show Platform;

class UserInputForm extends StatefulWidget {
  final String labelText;
  final TextEditingController controller;
  final String inputType;
  final bool isSignUpPasswordForm;
  final bool isMoveNextCursor;

  const UserInputForm(
      {super.key,
      required this.labelText,
      required this.controller,
      required this.inputType,
      this.isSignUpPasswordForm = false,
      this.isMoveNextCursor = true});

  @override
  State<UserInputForm> createState() => _UserInputFormState();
}

class _UserInputFormState extends State<UserInputForm> {
  final _telMaskFormatter = MaskTextInputFormatter(
      mask: '###-####-####',
      filter: {"#": RegExp(r'[0-9]')},
      type: MaskAutoCompletionType.lazy);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        inputFormatters: widget.inputType == "tel" ? [_telMaskFormatter] : [],
        obscureText: widget.inputType == "password" ? true : false,
        controller: widget.controller,
        textInputAction: widget.isMoveNextCursor ? TextInputAction.next : TextInputAction.done,
        decoration: InputDecoration(labelText: widget.labelText),
        validator: (text) {
          if (widget.inputType == "email") {
            return (text!.trim().isEmpty)
                ? '이메일을 입력하세요.'
                : (!text.trim().contains('@') ? "이메일 형식에 맞게 입력하세요." : null);
          } else if (widget.inputType == "password") {
            if (text!.trim().isEmpty) {
              return '비밀번호를 입력하세요.';
            }

            if (widget.isSignUpPasswordForm) {
              if (text.length < 8) {
                return "비밀번호 8자 이상 입력하세요.";
              } else {
                return null;
              }
            }

            return null;
          } else if (widget.inputType == "tel") {
            String pattern = '01[0|1|6|7|8|9]{1}-[0-9]{3,4}-[0-9]{4}';
            RegExp regExp = RegExp(pattern);
            if (text!.trim().isEmpty) {
              return '전화번호를 입력하세요.';
            } else if (!regExp.hasMatch(widget.controller.text)) {
              return '전화번호 형식에 맞게 입력하세요.';
            }

            return null;
          } else if (widget.inputType == "name") {
            return (text!.trim().isEmpty) ? '이름을 입력하세요.' : null;
          }
        },
      ),
    );
  }
}
