import 'package:flutter/material.dart';
import 'package:hello_flutter/ch16_table_calendar/model/schedule.dart';
import 'package:hive_flutter/hive_flutter.dart';



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
  List<Map<String, dynamic>> _items = [];

  final _schedules = Hive.box<Schedule>('schedules');

  @override
  void initState() {
    super.initState();
    _refreshItems(); // Load data when app starts
  }

  // Get all items from the database
  void _refreshItems() {
    final data = _schedules.keys.map((key) {
      final value = _schedules.get(key);
      return {"key": key,
        "content": value?.content,
        "date": value?.date,
        "startTime": value?.startTime,
        "endTime": value?.endTime,
      };
    }).toList();

    setState(() {
      _items = data.reversed.toList();
      // we use "reversed" to sort items in order from the latest to the oldest
    });
  }
  // Create new item
  Future<void> _createItem(Map<String, dynamic> newItem) async {
    await Hive.box('schedules').add(newItem);
    _refreshItems(); // update the UI
  }

  // Retrieve a single item from the database by using its key
  // Our app won't use this function but I put it here for your reference
  Map<String, dynamic> _readItem(int key) {
    final item = Hive.box('schedules').get(key);
    return item;
  }

  // Update a single item
  Future<void> _updateItem(int itemKey, Schedule schedule) async {
    await _schedules.put(itemKey, schedule);
    _refreshItems(); // Update the UI
  }

  // Delete a single item
  Future<void> _deleteItem(int itemKey) async {
    await _schedules.delete(itemKey);
    _refreshItems(); // update the UI

    // Display a snackbar
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('An item has been deleted')));
  }

  // TextFields' controllers
  final TextEditingController _contentController = TextEditingController();


  // This function will be triggered when the floating button is pressed
  // It will also be triggered when you want to update an item
  void _showForm(BuildContext ctx, int? itemKey) async {
    // itemKey == null -> create new item
    // itemKey != null -> update an existing item

    if (itemKey != null) {
      final existingItem =
      _items.firstWhere((element) => element['key'] == itemKey);
      _contentController.text = existingItem['content'];
    }

    showModalBottomSheet(
        context: ctx,
        elevation: 5,
        isScrollControlled: true,
        builder: (_) => Container(
          padding: EdgeInsets.only(
              bottom: MediaQuery.of(ctx).viewInsets.bottom,
              top: 15,
              left: 15,
              right: 15),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              TextField(
                controller: _contentController,
                decoration: const InputDecoration(hintText: 'content'),
              ),
              const SizedBox(
                height: 10,
              ),

              ElevatedButton(
                onPressed: () async {
                  // Save new item
                  if (itemKey == null) {
                    _createItem({
                      "content": _contentController.text
                    });
                  }

                  // update an existing item
                  /*
                  if (itemKey != null) {
                    _updateItem(itemKey, {
                      "content": _contentController.text
                    });
                  }*/

                  // Clear the text fields
                  _contentController.text = '';

                  Navigator.of(context).pop(); // Close the bottom sheet
                },
                child: Text(itemKey == null ? 'Create New' : 'Update'),
              ),
              const SizedBox(
                height: 15,
              )
            ],
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    Logger.showToast("Home start: ");

    return Scaffold(
      floatingActionButton: FloatingActionButton(  // ➊ 새 일정 버튼
        backgroundColor: PRIMARY_COLOR,
        onPressed: () {
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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,// 달력과 리스트를 세로로 배치
          children: [
            MainCalendar(
              selectedDate: selectedDate,  // 선택된 날짜 전달하기

              // 날짜가 선택됐을 때 실행할 함수
              onDaySelected: onDaySelected,
            ),
            SizedBox(height: 8.0),
            TodayBanner(  // ➊ 배너 추가하기
              selectedDate: selectedDate,
              count: Hive.box<Schedule>("schedules")
                  .values.where((schedule) => schedule.date == selectedDate)
                  .length,
            ),
            SizedBox(height: 8.0),
            _items.isEmpty
                ? const Center(
              child: Text(
                'No Data',
                style: TextStyle(fontSize: 30),
              ),
            )
                :
            Container(
                height: 100,
                width: 400,
                child:
                ListView.builder(
                  // the list of items
                    itemCount: Hive.box<Schedule>("schedules")
                        .values.where((schedule) => schedule.date == selectedDate)
                        .length,
                    itemBuilder: (_, index) {
                      final currentItem = _items[index];
                      return
                        Card(
                          color: Colors.orange.shade100,
                          margin: const EdgeInsets.all(10),
                          elevation: 3,
                          child: ListTile(
                              title: Text("Test"),
                              subtitle: Text("Sample"),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  // Edit button
                                  IconButton(
                                      icon: const Icon(Icons.edit),
                                      onPressed: () {
                                        Logger.showToast("수정 클릭");
                                      }),
                                  // Delete button
                                  IconButton(
                                    icon: const Icon(Icons.delete),
                                    onPressed: () {
                                      Logger.showToast("삭제 클릭");
                                    },
                                  ),
                                ],
                              )),
                        );
                      }
                )
        )],
      ),
      )
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