import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Button extends StatelessWidget {
  final String text;
  final bool isBig;
  final Color color;
  final void Function(String) onPressed;
  static const darkuttonColor = Color.fromRGBO(82, 82, 82, 1);
  static const defaultButtonColor = Color.fromRGBO(112, 112, 112, 1);
  static const operationButtonColor = Color.fromRGBO(250, 158, 13, 1);

  const Button({super.key,
    required this.text,
    required this.onPressed,
    this.isBig = true,
    this.color = Button.defaultButtonColor});

  const Button.operation({
    super.key,
    required this.text,
    required this.onPressed,
    this.isBig = false,
    this.color = operationButtonColor,
  });

  const Button.large({
    super.key,
    required this.text,
    required this.onPressed,
    this.isBig = false,
    this.color = defaultButtonColor,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
        flex: isBig ? 2 : 1,
        child: ButtonTheme(
          height: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: color),
            child: Text(
              text!,
              style: const TextStyle(
                  fontSize: 32.0,
                  fontWeight: FontWeight.w200,
                  color: Colors.white),
            ),
            onPressed: () =>
                onPressed(text),
          ),
        ));
  }
}