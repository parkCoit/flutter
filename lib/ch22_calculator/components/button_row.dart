import 'package:flutter/cupertino.dart';
import 'package:hello_flutter/ch22_calculator/components/button.dart';

class Calculator extends StatelessWidget {

  final String? title1;
  final String? title2;
  final String? title3;
  final String? title4;

  Calculator({
    required Key key,
    this.title1,
    this.title2,
    this.title3,
    this.title4
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(child: Row(
      children: const <Widget>[

      ],
    ));
  }
}