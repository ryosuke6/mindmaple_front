import 'package:flutter/material.dart';
import 'package:mindmaple/components/icon_nav.dart';
import 'package:mindmaple/components/header.dart';

class GraphScreen extends StatefulWidget {
  @override
  _GraphScreenState createState() => _GraphScreenState();
}

class _GraphScreenState extends State<GraphScreen> {
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
                iconPath: 'assets/images/calendar_icon.svg',
                label: 'カレンダー',
                color: Color(0xFF32AF99),
                onTap: () {
                  Navigator.pushNamed(context, '/calendar');
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
            padding: const EdgeInsets.only(top: 16.0, bottom: 16.0), // 上部と下部にパディングを追加
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end, // 追加
                          children: _buildTasksForDay(day),
                        ),
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
    Map<DateTime, Map<String, int>> tasks = {
      DateTime(2024, 6, 10): {'high': 5, 'medium': 3, 'low': 3},
      DateTime(2024, 6, 20): {'high': 4, 'medium': 3, 'low': 5},
      DateTime(2024, 7, 10): {'high': 2, 'medium': 1, 'low': 4},
      DateTime(2024, 7, 20): {'high': 1, 'medium': 3, 'low': 2},
    };

    if (tasks.containsKey(day)) {
      return tasks[day]!.entries.map((entry) {
        return TaskBar(priority: entry.key, count: entry.value);
      }).toList();
    }

    return [];
  }

  int daysInMonth(DateTime date) {
    var firstDayThisMonth = DateTime(date.year, date.month, 1);
    var firstDayNextMonth = DateTime(date.year, date.month + 1, 1);
    return firstDayNextMonth.difference(firstDayThisMonth).inDays;
  }
}

class TaskBar extends StatelessWidget {
  final String priority;
  final int count;

  TaskBar({required this.priority, required this.count});

  @override
  Widget build(BuildContext context) {
    Color color;
    switch (priority) {
      case 'high':
        color = Colors.red;
        break;
      case 'medium':
        color = Colors.yellow;
        break;
      case 'low':
        color = Colors.green;
        break;
      default:
        color = Colors.grey;
    }

    return Padding(
      padding: const EdgeInsets.only(left: 2.0, right: 2.0, bottom: 2.0), // マージンを追加
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end, // 下揃え
        children: [
          Container(
            height: count * 10.0,
            width: 10,
            color: color,
          ),
          SizedBox(height: 4),
          Text(
            count.toString(),
            style: TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }
}

enum CalendarFormat { month, week, twoWeeks }
