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
    double cellWidth = MediaQuery.of(context).size.width / 8; // 8列に変更

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
          _calendarFormat == CalendarFormat.week
              ? Container()
              : Column(
                  children: [
                    Container(
                      color: Colors.green, // 背景色を緑に設定
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: Icon(Icons.arrow_left, color: Colors.white),
                            onPressed: () {
                              setState(() {
                                _focusedDay = DateTime(_focusedDay.year, _focusedDay.month - 1);
                              });
                            },
                          ),
                          Text(
                            '${_focusedDay.year}年 ${_focusedDay.month}月',
                            style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          IconButton(
                            icon: Icon(Icons.arrow_right, color: Colors.white),
                            onPressed: () {
                              setState(() {
                                _focusedDay = DateTime(_focusedDay.year, _focusedDay.month + 1);
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    Container(
                      color: Color(0xFFE8F5E9), // 薄い緑の背景色を設定
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildWeekDay('月', cellWidth, Colors.black),
                          _buildWeekDay('火', cellWidth, Colors.black),
                          _buildWeekDay('水', cellWidth, Colors.black),
                          _buildWeekDay('木', cellWidth, Colors.black),
                          _buildWeekDay('金', cellWidth, Colors.black),
                          _buildWeekDay('土', cellWidth, Colors.blue), // 土曜日の文字色を青色に変更
                          _buildWeekDay('日', cellWidth, Colors.red), // 日曜日の文字色を赤色に変更
                        ],
                      ),
                    ),
                  ],
                ),
          Expanded(
            child: _calendarFormat == CalendarFormat.week
                ? _buildWeekView(cellWidth)
                : _buildMonthView(),
          ),
        ],
      ),
    );
  }

  Widget _buildWeekDay(String day, double width, Color color) {
    return Container(
      width: width,
      height: 60,
      alignment: Alignment.center,
      child: Text(day,
          style: TextStyle(
              fontSize: 16, fontWeight: FontWeight.bold, color: color)),
    );
  }

  Widget _buildDayContainer(DateTime day, {required bool isCurrentMonth}) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedDay = day;
        });
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.green), // 枠線を緑に設定
          color: _selectedDay != null && isSameDay(day, _selectedDay!)
              ? Colors.green[200]
              : isCurrentMonth
                  ? Colors.transparent
                  : Colors.grey[300], // 前月・来月の日付はグレーの背景色
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end, // 下揃え
          children: [
            if (isCurrentMonth) ..._buildTasksForDay(day),
            Text(
              '${day.day}',
              style: TextStyle(
                fontWeight: FontWeight.bold, // 日付の文字を太く
                color:
                    isCurrentMonth ? Colors.black : Colors.grey, // 前月・来月の日付はグレーの文字色
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool isSameDay(DateTime day1, DateTime day2) {
    return day1.year == day2.year &&
        day1.month == day2.month &&
        day1.day == day2.day;
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
      return tasks
          .map((task) => Container(
                margin: EdgeInsets.symmetric(vertical: 2.0),
                padding: EdgeInsets.symmetric(horizontal: 4.0, vertical: 2.0),
                decoration: BoxDecoration(
                  color: Colors.green, // 背景色を追加
                  borderRadius: BorderRadius.circular(10), // 角を丸くする
                ),
                child: Text(
                  task,
                  style: TextStyle(
                      fontSize: 10, color: Colors.white), // テキストの色を白に設定
                ),
              ))
          .toList();
    }

    return [];
  }

  int daysInMonthWithLeadingBlanks(DateTime date) {
    return leadingBlanks(date) + daysInMonth(date);
  }

  int leadingBlanks(DateTime date) {
    return DateTime(date.year, date.month, 1).weekday - 1;
  }

  int trailingBlanks(DateTime date) {
    return 7 - (DateTime(date.year, date.month + 1, 0).weekday);
  }

  int daysInMonth(DateTime date) {
    var firstDayThisMonth = DateTime(date.year, date.month, 1);
    var firstDayNextMonth = DateTime(date.year, date.month + 1, 1);
    return firstDayNextMonth.difference(firstDayThisMonth).inDays;
  }

  Widget _buildMonthView() {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        childAspectRatio: 1.0, // 正方形にするためのアスペクト比
        mainAxisExtent: 100, // マスの高さを100pxに設定
      ),
      itemCount:
          daysInMonthWithLeadingBlanks(_focusedDay) + trailingBlanks(_focusedDay),
      itemBuilder: (context, index) {
        if (index < leadingBlanks(_focusedDay)) {
          DateTime prevMonthDay = DateTime(_focusedDay.year, _focusedDay.month, 1)
              .subtract(Duration(days: leadingBlanks(_focusedDay) - index));
          return _buildDayContainer(prevMonthDay, isCurrentMonth: false);
        } else if (index >=
            leadingBlanks(_focusedDay) + daysInMonth(_focusedDay)) {
          DateTime nextMonthDay = DateTime(
                  _focusedDay.year, _focusedDay.month, daysInMonth(_focusedDay))
              .add(Duration(
                  days: index -
                      (leadingBlanks(_focusedDay) + daysInMonth(_focusedDay)) +
                      1));
          return _buildDayContainer(nextMonthDay, isCurrentMonth: false);
        } else {
          DateTime day = DateTime(_focusedDay.year, _focusedDay.month,
              index + 1 - leadingBlanks(_focusedDay));
          return _buildDayContainer(day, isCurrentMonth: true);
        }
      },
    );
  }

  Widget _buildWeekView(double cellWidth) {
    DateTime startOfWeek =
        _focusedDay.subtract(Duration(days: _focusedDay.weekday - 1));
    return Column(
      children: [
        Container(
          color: Colors.green, // 背景色を緑に設定
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: Icon(Icons.arrow_left, color: Colors.white),
                onPressed: () {
                  setState(() {
                    _focusedDay = _focusedDay.subtract(Duration(days: 7));
                  });
                },
              ),
              Text(
                '${_focusedDay.year}年 ${_focusedDay.month}月 ${getWeekOfMonth(_focusedDay)}週',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              IconButton(
                icon: Icon(Icons.arrow_right, color: Colors.white),
                onPressed: () {
                  setState(() {
                    _focusedDay = _focusedDay.add(Duration(days: 7));
                  });
                },
              ),
            ],
          ),
        ),
        Row(
          children:[
            Container(
              width: cellWidth, // 時間表示用の幅を設定
              height: 60,
              color: Color(0xFFE8F5E9),
            ),
            Container(
              color: Color(0xFFE8F5E9), // 薄い緑の背景色を設定
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildWeekDay('月', cellWidth, Colors.black),
                  _buildWeekDay('火', cellWidth, Colors.black),
                  _buildWeekDay('水', cellWidth, Colors.black),
                  _buildWeekDay('木', cellWidth, Colors.black),
                  _buildWeekDay('金', cellWidth, Colors.black),
                  _buildWeekDay('土', cellWidth, Colors.blue), // 土曜日の文字色を青色に変更
                  _buildWeekDay('日', cellWidth, Colors.red), // 日曜日の文字色を赤色に変更
                ],
              ),
            ),
          ]
        ),
        Row(
          children: [
            Container(
              width: cellWidth, // 時間表示用の幅を設定
              height: 60,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.green),
              ),
            ),
            ...List.generate(7, (index) {
              DateTime day = startOfWeek.add(Duration(days: index));
              return Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.green),
                    color: _selectedDay != null && isSameDay(day, _selectedDay!)
                        ? Colors.green[200]
                        : Colors.transparent,
                  ),
                  height: 60,
                  alignment: Alignment.center,
                  child: Text(
                    '${day.day}',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              );
            }),
          ],
        ),
        Expanded(
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 8, // 8列に変更
              childAspectRatio: 1.0,
            ),
            itemCount: 24 * 8, // 8列分に変更
            itemBuilder: (context, index) {
              int hour = index ~/ 8;
              int dayIndex = index % 8;
              if (dayIndex == 0) {
                return Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.green),
                  ),
                  child: Text(
                    '$hour時',
                    style: TextStyle(fontSize: 10, color: Colors.black),
                  ),
                );
              } else {
                DateTime day = startOfWeek.add(Duration(days: dayIndex - 1));
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedDay = day;
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.green),
                      color: _selectedDay != null && isSameDay(day, _selectedDay!)
                          ? Colors.green[200]
                          : Colors.transparent,
                    ),
                  ),
                );
              }
            },
          ),
        ),
      ],
    );
  }

  int getWeekOfMonth(DateTime date) {
    int dayOfMonth = date.day;
    int weekOfMonth =
        (dayOfMonth + DateTime(date.year, date.month, 1).weekday - 1) ~/ 7 + 1;
    return weekOfMonth;
  }
}

enum CalendarFormat { month, week, twoWeeks }
