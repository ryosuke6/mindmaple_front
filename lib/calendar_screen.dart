import 'package:flutter/material.dart';
import 'package:mindmaple/components/icon_nav.dart';
import 'package:mindmaple/components/header.dart';

class CalendarScreen extends StatefulWidget {
  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  CalendarFormat _calendarFormat = CalendarFormat.month;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const Header(title: 'MindMaple'), // Headerコンポーネントを使用
      body: Column(
        children: [
          IconNav(
            icons: [
              NavIconData(
                iconPath: 'assets/images/home_icon.svg',
                label: 'ホーム',
                color: Color(0xFF7EBAD6),
                onTap: () {
                  Navigator.pushNamed(context, '/home');
                },
              ),
              NavIconData(
                iconPath: 'assets/images/graph_icon.svg',
                label: 'グラフ',
                color: Color(0xFFC67945),
                onTap: () {
                  Navigator.pushNamed(context, '/graph');
                },
              ),
              NavIconData(
                iconPath: 'assets/images/task_create_icon.svg',
                label: 'タスク作成',
                color: Color(0xFFAA92EF),
                onTap: () {
                  Navigator.pushNamed(context, '/task_create');
                },
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16.0, bottom: 16.0), // 上部にパディングを追加
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: _calendarFormat == CalendarFormat.month ? Colors.green : Colors.grey, // アクティブ/非アクティブの色
                  ),
                  onPressed: () {
                    setState(() {
                      _calendarFormat = CalendarFormat.month;
                    });
                  },
                  child: Text('月表示'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: _calendarFormat == CalendarFormat.week ? Colors.green : Colors.grey, // アクティブ/非アクティブの色
                  ),
                  onPressed: () {
                    setState(() {
                      _calendarFormat = CalendarFormat.week;
                    });
                  },
                  child: Text('週表示'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: _calendarFormat == CalendarFormat.twoWeeks ? Colors.green : Colors.grey, // アクティブ/非アクティブの色
                  ),
                  onPressed: () {
                    setState(() {
                      _calendarFormat = CalendarFormat.twoWeeks;
                    });
                  },
                  child: Text('日表示'),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: Text(
              '${_focusedDay.year}年 ${_focusedDay.month}月',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
                childAspectRatio: 1.0, // 正方形にするためのアスペクト比
                mainAxisExtent: 100, // マスの高さを100pxに設定
              ),
              itemCount: daysInMonth(_focusedDay),
              itemBuilder: (context, index) {
                DateTime day = DateTime(_focusedDay.year, _focusedDay.month, index + 1);
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedDay = day;
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      color: _selectedDay != null && isSameDay(day, _selectedDay!) ? Colors.green[200] : Colors.transparent,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end, // 下揃え
                      children: [
                        ..._buildTasksForDay(day),
                        Text('${day.day}'),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  bool isSameDay(DateTime day1, DateTime day2) {
    return day1.year == day2.year && day1.month == day2.month && day1.day == day2.day;
  }

  List<Widget> _buildTasksForDay(DateTime day) {
    // ダミータスクデータ
    List<String> tasks = [
      'タスク名1',
      'タスク名2',
      'タスク名3',
    ];

    // 任意の日付にタスクを追加する
    if (day.day == 10 || day.day == 20) {
      return tasks.map((task) => Text(task, style: TextStyle(fontSize: 12))).toList();
    }

    return [];
  }

  int daysInMonth(DateTime date) {
    var firstDayThisMonth = DateTime(date.year, date.month, 1);
    var firstDayNextMonth = DateTime(date.year, date.month + 1, 1);
    return firstDayNextMonth.difference(firstDayThisMonth).inDays;
  }
}

enum CalendarFormat { month, week, twoWeeks }
