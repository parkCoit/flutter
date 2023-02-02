import 'package:flutter/material.dart';
import 'package:hello_flutter/ch16_table_calendar/screen/table_calendar.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

import 'model/schedule.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final document = await getApplicationDocumentsDirectory();
  await initializeDateFormatting();
  await Hive.initFlutter(document.path);
  // 어답터 등록하기
  Hive.registerAdapter<Schedule>(ScheduleAdapter());
  await Hive.openBox<Schedule>('schedules');
  runApp(
    MaterialApp(
      home: TableCalendar(),
    ),
  );
}