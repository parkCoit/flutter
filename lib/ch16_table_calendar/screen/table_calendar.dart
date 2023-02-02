import 'package:flutter/material.dart';

import '../../admin/util/logger.dart';
import '../component/main_calendar.dart';
import '../component/schedule_bottom_sheet.dart';
import '../component/schedule_card.dart';
import '../component/today_banner.dart';
import '../const/colors.dart';




class TableCalendar extends StatefulWidget {
  const TableCalendar({super.key});
  // ➊ StatelessWidget에서 StatefulWidget으로 전환


  @override
  State<TableCalendar> createState() => _TableCalendarState();
}

class _TableCalendarState extends State<TableCalendar> {
  DateTime selectedDate = DateTime.utc(  // ➋ 선택된 날짜를 관리할 변수
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(  // ➊ 새 일정 버튼
        backgroundColor: PRIMARY_COLOR,
        onPressed: () {
          Logger.showToast("onPressed: ");
          showModalBottomSheet(  // ➋ BottomSheet 열기
            context: context,
            isDismissible: true,  // ➌ 배경 탭했을 때 BottomSheet 닫기
            isScrollControlled: true,
            builder: (_) => ScheduleBottomSheet(selectedDate: selectedDate),
          );
        },
        child: Icon(
          Icons.add,
        ),
      ),
      body: SafeArea(   // 시스템 UI 피해서 UI 구현하기
        child: Column(  // 달력과 리스트를 세로로 배치
          children: [
            MainCalendar(
              selectedDate: selectedDate,  // 선택된 날짜 전달하기

              // 날짜가 선택됐을 때 실행할 함수
              onDaySelected: onDaySelected,
            ),
            SizedBox(height: 8.0),
            TodayBanner(  // ➊ 배너 추가하기
              selectedDate: selectedDate,
              count: 0,
            ),
            SizedBox(height: 8.0),
            ScheduleCard(  // ➊ 구현해둔 일정 카드
              startTime: 12,
              endTime: 14,
              content: '프로그래밍 공부',
            ),
          ],
        ),
      ),
    );
  }

  void onDaySelected(DateTime selectedDate, DateTime focusedDate){
    // ➌ 날짜 선택될 때마다 실행할 함수
    Logger.showToast(" 1 onDaySelected ");
    setState(() {
      this.selectedDate = selectedDate;
    });
  }
}