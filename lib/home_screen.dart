import 'package:flutter/material.dart';
import 'package:mindmaple/components/header.dart';
import 'package:mindmaple/components/icon_nav.dart';
import 'package:mindmaple/components/task_list.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final List<String> todayTasks = [
      'タスク1/優先度/期限',
      'タスク2/優先度/期限',
      'タスク3/優先度/期限',
      'タスク4/優先度/期限',
      'タスク5/優先度/期限',
    ];

    final List<String> weekTasks = [
      '月曜日のタスク一覧',
      '火曜日のタスク一覧',
      '水曜日のタスク一覧',
      '木曜日のタスク一覧',
      '金曜日のタスク一覧',
      '土曜日のタスク一覧',
      '日曜日のタスク一覧',
    ];

    final List<String> priorityTasks = [
      'タスク1/優先度/期限',
      'タスク2/優先度/期限',
      'タスク3/優先度/期限',
      'タスク4/優先度/期限',
      'タスク5/優先度/期限',
    ];

    return Scaffold(
      appBar: const Header(title: 'MindMaple'),
      body: Container(
        color: const Color(0xFFF5F5F5), // 背景色を変更
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              IconNav(
                icons: [
                  NavIconData(
                    iconPath: 'assets/images/calendar_icon.svg',
                    label: 'カレンダー',
                    color: Color(0xFF32AF99),
                    onTap: () {
                      Navigator.pushNamed(context, '/calendar');
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
              TaskList(
                title: '今日のタスク',
                tasks: todayTasks,
                color: const Color(0xFF3D9AC7),
              ),
              TaskList(
                title: '直近の優先タスク',
                tasks: priorityTasks,
                color: const Color(0xFFE77070),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
