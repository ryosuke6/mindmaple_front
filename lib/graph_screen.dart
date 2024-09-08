import 'package:flutter/material.dart';
import 'package:mindmaple/components/icon_nav.dart';
import 'package:mindmaple/components/header.dart';
import 'package:mindmaple/constants.dart';
import 'package:mindmaple/models/task_priority.dart';
import 'dart:math';

class GraphScreen extends StatefulWidget {
  @override
  _GraphScreenState createState() => _GraphScreenState();
}

class _GraphScreenState extends State<GraphScreen> {
  late DateTime _focusedDay;
  DateTime? _selectedDay;
  CalendarFormat _calendarFormat = CalendarFormat.month;

  late Map<DateTime, TaskData> _taskData;
  late Map<DateTime, TaskData> _weekTaskData;

  @override
  void initState() {
    super.initState();
    _focusedDay = DateTime.now();
    _updateTaskData();
  }

  void _generateTaskData() {
    final now = DateTime.now();
    _taskData = {
      DateTime(now.year, now.month, 10): TaskData({
        TaskPriority.high: 5,
        TaskPriority.medium: 3,
        TaskPriority.low: 3,
      }),
      DateTime(now.year, now.month, 20): TaskData({
        TaskPriority.high: 4,
        TaskPriority.medium: 3,
        TaskPriority.low: 5,
      }),
      DateTime(now.year, now.month, 25): TaskData({
        TaskPriority.high: 2,
        TaskPriority.medium: 1,
        TaskPriority.low: 4,
      }),
      DateTime(now.year, now.month, 28): TaskData({
        TaskPriority.high: 1,
        TaskPriority.medium: 3,
        TaskPriority.low: 2,
      }),
    };
    print('Task data updated: $_taskData'); // デバッグ用
  }

  void _generateWeekTaskData() {
    final startOfWeek =
        _focusedDay.subtract(Duration(days: _focusedDay.weekday - 1));
    _weekTaskData = {
      for (int i = 0; i < 7; i++)
        startOfWeek.add(Duration(days: i)): TaskData({
          TaskPriority.high: _generateRandomTaskCount(3),
          TaskPriority.medium: _generateRandomTaskCount(4),
          TaskPriority.low: _generateRandomTaskCount(3),
        })
    };
  }

  void _updateTaskData() {
    _generateTaskData();
    _generateWeekTaskData();
  }

  int _generateRandomTaskCount(int maxCount) {
    return Random().nextInt(maxCount + 1);
  }

  void _changeFocusedDay(int delta) {
    setState(() {
      if (_calendarFormat == CalendarFormat.week) {
        _focusedDay = _focusedDay.add(Duration(days: 7 * delta));
      } else if (_calendarFormat == CalendarFormat.twoWeeks) {
        _focusedDay = _focusedDay.add(Duration(days: delta));
      } else {
        _focusedDay = DateTime(_focusedDay.year, _focusedDay.month + delta, 1);
      }
      _updateTaskData();
    });
  }

  @override
  Widget build(BuildContext context) {
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
                onTap: () => Navigator.pushNamed(context, '/home'),
              ),
              NavIconData(
                iconPath: 'assets/images/calendar_icon.svg',
                label: 'カレンダー',
                color: Color(0xFF32AF99),
                onTap: () => Navigator.pushNamed(context, '/calendar'),
              ),
              NavIconData(
                iconPath: 'assets/images/task_create_icon.svg',
                label: 'タスク作成',
                color: Color(0xFFAA92EF),
                onTap: () => Navigator.pushNamed(context, '/task_create'),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildFormatButton(CalendarFormat.month, '月表示'),
                _buildFormatButton(CalendarFormat.week, '週表示'),
                _buildFormatButton(CalendarFormat.twoWeeks, '日表示'),
              ],
            ),
          ),
          Expanded(
            child: _calendarFormat == CalendarFormat.week
                ? _buildWeekView()
                : _calendarFormat == CalendarFormat.twoWeeks
                    ? _buildDayView()
                    : _buildMonthCalendar(),
          ),
        ],
      ),
    );
  }

  Widget _buildFormatButton(CalendarFormat format, String label) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        primary: _calendarFormat == format ? Colors.green : Colors.grey,
      ),
      onPressed: () => setState(() => _calendarFormat = format),
      child: Text(label),
    );
  }

  Widget _buildWeekView() {
    DateTime startOfWeek =
        _focusedDay.subtract(Duration(days: _focusedDay.weekday - 1));
    int weekOfMonth = (startOfWeek.day - 1) ~/ 7 + 1;

    return Column(
      children: [
        _buildWeekHeader(startOfWeek, weekOfMonth),
        Expanded(
          child: _buildWeekGraph(startOfWeek),
        ),
      ],
    );
  }

  Widget _buildWeekHeader(DateTime startOfWeek, int weekOfMonth) {
    return Container(
      color: Colors.green,
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: Icon(Icons.arrow_left, color: Colors.white),
            onPressed: () => _changeFocusedDay(-1),
          ),
          Text(
            '${startOfWeek.year}年 ${startOfWeek.month}月 第$weekOfMonth週',
            style: TextStyle(
                fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          IconButton(
            icon: Icon(Icons.arrow_right, color: Colors.white),
            onPressed: () => _changeFocusedDay(1),
          ),
        ],
      ),
    );
  }

  Widget _buildWeekGraph(DateTime startOfWeek) {
    const double taskHeight = 30.0; // 1タスクあたりの高さを10ピクセルに設定
    const double maxBarHeight = 300.0; // バーの最大高さを150ピクセルに設定

    return Row(
      children: List.generate(7, (index) {
        DateTime currentDay = startOfWeek.add(Duration(days: index));
        TaskData dayData = _weekTaskData[currentDay] ?? TaskData({});
        int totalTasks =
            dayData.counts.values.fold(0, (sum, count) => sum + count);

        return Expanded(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 2),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.withOpacity(0.3)),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                Expanded(
                  child: _buildDayBar(
                      dayData, totalTasks, taskHeight, maxBarHeight),
                ),
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Text(
                    '${currentDay.day}',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildDayBar(
      TaskData dayData, int total, double taskHeight, double maxBarHeight) {
    double barHeight = min(total * taskHeight, maxBarHeight);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            height: barHeight,
            child: Column(
              children: [
                _buildPrioritySegment(dayData.counts[TaskPriority.high] ?? 0,
                    AppColors.highPriority, taskHeight),
                _buildPrioritySegment(dayData.counts[TaskPriority.medium] ?? 0,
                    AppColors.mediumPriority, taskHeight),
                _buildPrioritySegment(dayData.counts[TaskPriority.low] ?? 0,
                    AppColors.lowPriority, taskHeight),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPrioritySegment(int count, Color color, double taskHeight) {
    if (count == 0) return SizedBox.shrink();
    return Container(
      height: count * taskHeight,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Center(
        child: Text(
          count.toString(),
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildMonthYearSelector() {
    return Container(
      color: Colors.green,
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: Icon(Icons.arrow_left, color: Colors.white),
            onPressed: () => _changeFocusedDay(-1),
          ),
          Text(
            '${_focusedDay.year}年 ${_focusedDay.month}月',
            style: TextStyle(
                fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          IconButton(
            icon: Icon(Icons.arrow_right, color: Colors.white),
            onPressed: () => _changeFocusedDay(1),
          ),
        ],
      ),
    );
  }

  Widget _buildMonthCalendar() {
    return Column(
      children: [
        _buildMonthYearSelector(),
        _buildMonthWeekdayHeader(),
        Expanded(
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              childAspectRatio: 1.0,
              mainAxisExtent: 100,
            ),
            itemCount: 42,
            itemBuilder: (context, index) {
              return _buildDayCell(index);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildMonthWeekdayHeader() {
    final weekdays = ['月', '火', '水', '木', '金', '土', '日'];
    return Container(
      color: Color(0xFFE8F5E9),
      child: Row(
        children: [
          for (int i = 0; i < 7; i++)
            Expanded(
              child: Container(
                alignment: Alignment.center,
                child: Text(
                  weekdays[i],
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: i == 5
                        ? Colors.blue
                        : (i == 6 ? Colors.red : Colors.black),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildDayCell(int index) {
    DateTime firstDayOfMonth = DateTime(_focusedDay.year, _focusedDay.month, 1);
    int daysBeforeMonth = firstDayOfMonth.weekday - 1;
    DateTime day = firstDayOfMonth
        .subtract(Duration(days: daysBeforeMonth))
        .add(Duration(days: index));

    bool isToday = isSameDay(day, DateTime.now());
    bool isCurrentMonth = day.month == _focusedDay.month;
    bool isWeekend = day.weekday == 6 || day.weekday == 7;

    return GestureDetector(
      onTap: () => setState(() => _selectedDay = day),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.green),
          color: _selectedDay != null && isSameDay(day, _selectedDay!)
              ? Colors.green[200]
              : isToday
                  ? Colors.yellow[100]
                  : isCurrentMonth
                      ? Colors.transparent
                      : Colors.grey[300],
        ),
        child: Column(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Text(
                  '${day.day}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isCurrentMonth
                        ? (isWeekend
                            ? (day.weekday == 6 ? Colors.blue : Colors.red)
                            : Colors.black)
                        : Colors.grey,
                  ),
                ),
              ),
            ),
            if (isCurrentMonth)
              Expanded(
                child: _buildTaskGraph(day),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskGraph(DateTime day) {
    TaskData dayData = _taskData[day] ?? TaskData({});

    if (dayData.counts.isEmpty) return SizedBox();

    int total = dayData.counts.values.reduce((a, b) => a + b);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        _buildTaskBar(TaskPriority.high, dayData.counts[TaskPriority.high] ?? 0,
            total, AppColors.highPriority),
        _buildTaskBar(
            TaskPriority.medium,
            dayData.counts[TaskPriority.medium] ?? 0,
            total,
            AppColors.mediumPriority),
        _buildTaskBar(TaskPriority.low, dayData.counts[TaskPriority.low] ?? 0,
            total, AppColors.lowPriority),
      ],
    );
  }

  Widget _buildTaskBar(
      TaskPriority priority, int count, int total, Color color) {
    double height = count / total * 50;
    return Container(
      width: 10,
      height: height,
      color: color,
      margin: EdgeInsets.symmetric(horizontal: 1),
    );
  }

  bool isSameDay(DateTime day1, DateTime day2) {
    return day1.year == day2.year &&
        day1.month == day2.month &&
        day1.day == day2.day;
  }

  int daysInMonthWithLeadingBlanks(DateTime date) {
    int daysInMonth = DateTime(date.year, date.month + 1, 0).day;
    int leadingBlanks = DateTime(date.year, date.month, 1).weekday - 1;
    return leadingBlanks + daysInMonth;
  }

  int trailingBlanks(DateTime date) {
    int daysInMonth = DateTime(date.year, date.month + 1, 0).day;
    int trailingBlanks =
        7 - (daysInMonth + DateTime(date.year, date.month, 1).weekday - 1) % 7;
    return trailingBlanks;
  }

  Widget _buildDayView() {
    return Column(
      children: [
        _buildDayHeader(),
        Expanded(
          child: _buildDayGraph(),
        ),
      ],
    );
  }

  Widget _buildDayHeader() {
    return Container(
      color: Colors.green,
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: Icon(Icons.arrow_left, color: Colors.white),
            onPressed: () => _changeFocusedDay(-1),
          ),
          Text(
            '${_focusedDay.year}年 ${_focusedDay.month}月 ${_focusedDay.day}日',
            style: TextStyle(
                fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          IconButton(
            icon: Icon(Icons.arrow_right, color: Colors.white),
            onPressed: () => _changeFocusedDay(1),
          ),
        ],
      ),
    );
  }

  Widget _buildDayGraph() {
    const double taskHeight = 30.0; // 1タスクあたりの高さを15ピクセルに設定
    const double maxBarHeight = 300.0; // バーの最大高さを150ピクセルに設定

    return ListView.separated(
      scrollDirection: Axis.horizontal,
      itemCount: 24,
      separatorBuilder: (context, index) => SizedBox(width: 10),
      itemBuilder: (context, index) {
        DateTime currentHour = DateTime(
            _focusedDay.year, _focusedDay.month, _focusedDay.day, index);
        TaskData hourData = _getDayTaskData(currentHour);
        int total = hourData.counts.values.fold(0, (sum, count) => sum + count);

        return Container(
          width: MediaQuery.of(context).size.width / 8,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.withOpacity(0.3)),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              Expanded(
                child:
                    _buildHourlyBar(hourData, total, taskHeight, maxBarHeight),
              ),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Text(
                  '${index.toString().padLeft(2, '0')}:00',
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHourlyBar(
      TaskData hourData, int total, double taskHeight, double maxBarHeight) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double barHeight = min(total * taskHeight, maxBarHeight);
        return Container(
          padding: EdgeInsets.all(4),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                height: barHeight,
                child: Column(
                  children: [
                    _buildPrioritySegment(
                        hourData.counts[TaskPriority.high] ?? 0,
                        AppColors.highPriority,
                        taskHeight),
                    _buildPrioritySegment(
                        hourData.counts[TaskPriority.medium] ?? 0,
                        AppColors.mediumPriority,
                        taskHeight),
                    _buildPrioritySegment(
                        hourData.counts[TaskPriority.low] ?? 0,
                        AppColors.lowPriority,
                        taskHeight),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  TaskData _getDayTaskData(DateTime hour) {
    return TaskData({
      TaskPriority.high: hour.hour % 3,
      TaskPriority.medium: (hour.hour + 1) % 4,
      TaskPriority.low: (hour.hour + 2) % 5,
    });
  }
}

enum CalendarFormat { month, week, twoWeeks }
