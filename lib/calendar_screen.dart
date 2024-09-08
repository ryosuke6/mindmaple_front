import 'package:flutter/material.dart';
import 'package:mindmaple/components/icon_nav.dart';
import 'package:mindmaple/components/header.dart';
import 'package:mindmaple/models/task_data.dart'; // ダミータスクデータをインポート

const int numColumns = 8; // 列数
const double cellHeight = 100.0; // セルの高さ
const double cellWidthFactor = 8.0; // セルの幅を計算するための因子

enum CalendarFormat { month, week, twoWeeks }

class CalendarScreen extends StatefulWidget {
  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  CalendarFormat _calendarFormat = CalendarFormat.month;

  // ダミータスクデータ
  List<TaskData> _tasks = getDummyTasks();

  @override
  Widget build(BuildContext context) {
    double cellWidth = MediaQuery.of(context).size.width / cellWidthFactor;

    return Scaffold(
      appBar: const Header(title: 'MindMaple'),
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
            padding: const EdgeInsets.only(top: 16.0, bottom: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildCalendarButton('月表示', CalendarFormat.month),
                _buildCalendarButton('週表示', CalendarFormat.week),
                _buildCalendarButton('日表示', CalendarFormat.twoWeeks),
              ],
            ),
          ),
          if (_calendarFormat == CalendarFormat.month) ...[
            _buildMonthHeader(),
            _buildWeekDaysRow(cellWidth),
          ],
          if (_calendarFormat == CalendarFormat.week) ...[
            _buildWeekHeader(),
          ],
          Expanded(
            child: _calendarFormat == CalendarFormat.week
                ? _buildWeekView(cellWidth)
                : _calendarFormat == CalendarFormat.twoWeeks
                    ? _buildDayView(cellWidth)
                    : _buildMonthView(),
          ),
        ],
      ),
    );
  }

  ElevatedButton _buildCalendarButton(String text, CalendarFormat format) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        primary: _calendarFormat == format ? Colors.green : Colors.grey,
      ),
      onPressed: () {
        setState(() {
          _calendarFormat = format;
        });
      },
      child: Text(text),
    );
  }

  Widget _buildMonthHeader() {
    return Container(
      color: Colors.green,
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
                fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
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
    );
  }

  Widget _buildWeekHeader() {
    return Container(
      color: Colors.green,
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
                fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
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
    );
  }

  Widget _buildWeekDaysRow(double cellWidth) {
    return Container(
      color: Color(0xFFE8F5E9),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildWeekDay('月', cellWidth, Colors.black),
          _buildWeekDay('火', cellWidth, Colors.black),
          _buildWeekDay('水', cellWidth, Colors.black),
          _buildWeekDay('木', cellWidth, Colors.black),
          _buildWeekDay('金', cellWidth, Colors.black),
          _buildWeekDay('土', cellWidth, Colors.blue),
          _buildWeekDay('日', cellWidth, Colors.red),
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
          border: Border.all(color: Colors.green),
          color: _selectedDay != null && isSameDay(day, _selectedDay!)
              ? Colors.green[200]
              : isCurrentMonth
                  ? Colors.transparent
                  : Colors.grey[300],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            if (isCurrentMonth) ..._buildTasksForDay(day),
            Text(
              '${day.day}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isCurrentMonth ? Colors.black : Colors.grey,
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
    List<String> tasks = [
      '非常に長いタスク名1',
      'タスク名2',
      'タスク名3',
    ];

    if (day.day == 10 || day.day == 20) {
      return tasks
          .map((task) => Container(
                margin: EdgeInsets.symmetric(vertical: 2.0),
                padding: EdgeInsets.symmetric(horizontal: 4.0, vertical: 2.0),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  task,
                  style: TextStyle(fontSize: 10, color: Colors.white),
                  overflow: TextOverflow.ellipsis,
                  softWrap: true,
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
        childAspectRatio: 1.0,
        mainAxisExtent: cellHeight,
      ),
      itemCount: daysInMonthWithLeadingBlanks(_focusedDay) +
          trailingBlanks(_focusedDay),
      itemBuilder: (context, index) {
        if (index < leadingBlanks(_focusedDay)) {
          DateTime prevMonthDay =
              DateTime(_focusedDay.year, _focusedDay.month, 1)
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
        Row(
          children: [
            Container(
              width: cellWidth,
              height: 60,
              color: Color(0xFFE8F5E9),
            ),
            _buildWeekDaysRow(cellWidth),
          ],
        ),
        Row(
          children: [
            Container(
              width: cellWidth,
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
          child: Stack(
            children: [
              GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: numColumns,
                  mainAxisExtent: cellHeight,
                  childAspectRatio: 1.0,
                ),
                itemCount: 24 * numColumns,
                itemBuilder: (context, index) {
                  int hour = index ~/ numColumns;
                  int dayIndex = index % numColumns;
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
                    DateTime day =
                        startOfWeek.add(Duration(days: dayIndex - 1));
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedDay = day;
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.green),
                          color: _selectedDay != null &&
                                  isSameDay(day, _selectedDay!)
                              ? Colors.green[200]
                              : Colors.transparent,
                        ),
                      ),
                    );
                  }
                },
              ),
              ..._tasks
                  .map((task) => _buildTaskWidget(task, cellWidth))
                  .toList(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDayView(double cellWidth) {
    DateTime startOfDay =
        DateTime(_focusedDay.year, _focusedDay.month, _focusedDay.day);
    return Column(
      children: [
        Container(
          color: Colors.green,
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: Icon(Icons.arrow_left, color: Colors.white),
                onPressed: () {
                  setState(() {
                    _focusedDay = _focusedDay.subtract(Duration(days: 1));
                  });
                },
              ),
              Text(
                '${_focusedDay.year}年 ${_focusedDay.month}月 ${_focusedDay.day}日',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              IconButton(
                icon: Icon(Icons.arrow_right, color: Colors.white),
                onPressed: () {
                  setState(() {
                    _focusedDay = _focusedDay.add(Duration(days: 1));
                  });
                },
              ),
            ],
          ),
        ),
        Expanded(
          child: Stack(
            children: [
              GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 1,
                  mainAxisExtent: cellHeight,
                  childAspectRatio: 1.0,
                ),
                itemCount: 24,
                itemBuilder: (context, index) {
                  int hour = index;
                  return Row(
                    children: [
                      Container(
                        width: cellWidth,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.green),
                        ),
                        child: Text(
                          '$hour時',
                          style: TextStyle(fontSize: 10, color: Colors.black),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.green),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
              ..._tasks
                  .where((task) => isSameDay(task.startTime, startOfDay))
                  .map((task) => _buildTaskWidget(task, cellWidth))
                  .toList(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTaskWidget(TaskData task, double cellWidth) {
    int startHour = task.startTime.hour;
    int endHour = task.endTime.hour;
    double topOffset = startHour * cellHeight;
    double height = (endHour - startHour) * cellHeight;

    return Positioned(
      top: topOffset,
      left: cellWidth,
      child: Container(
        width: MediaQuery.of(context).size.width - cellWidth,
        height: height,
        margin: EdgeInsets.symmetric(horizontal: 1.0, vertical: 2.0),
        padding: EdgeInsets.symmetric(horizontal: 4.0, vertical: 2.0),
        decoration: BoxDecoration(
          color: Colors.green,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          task.title,
          style: TextStyle(fontSize: 10, color: Colors.white),
          overflow: TextOverflow.ellipsis,
          softWrap: true,
        ),
      ),
    );
  }

  int getWeekOfMonth(DateTime date) {
    int dayOfMonth = date.day;
    int weekOfMonth =
        (dayOfMonth + DateTime(date.year, date.month, 1).weekday - 1) ~/ 7 + 1;
    return weekOfMonth;
  }
}
