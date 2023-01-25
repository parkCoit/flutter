import 'package:hello_flutter/ch05_basic_widget/column_widget.dart';
import 'package:hello_flutter/ch05_basic_widget/elevated_button_widget.dart';
import 'package:hello_flutter/ch05_basic_widget/expanded_widget.dart';
import 'package:hello_flutter/ch05_basic_widget/floating_action_button_widget.dart';
import 'package:hello_flutter/ch05_basic_widget/gesture_detector_widget.dart';
import 'package:hello_flutter/ch05_basic_widget/icon_button_widget.dart';
import 'package:hello_flutter/ch05_basic_widget/outlined_button_widget.dart';
import 'package:hello_flutter/ch05_basic_widget/padding_widget.dart';
import 'package:hello_flutter/ch05_basic_widget/row_widget.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: ColumnWidgetExample(),
        ),
      ),
    );
  }
}
