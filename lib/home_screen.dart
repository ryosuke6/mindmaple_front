import 'package:flutter/material.dart';
import 'package:mindmaple/components/header.dart';
import 'package:mindmaple/components/icon_nav.dart';
import 'package:mindmaple/components/task_list.dart';
import 'package:mindmaple/models/home_task_data.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const Header(title: 'MindMaple'),
      body: Container(
        color: const Color(0xFFF5F5F5),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              _buildIconNav(context),
              _buildTaskLists(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIconNav(BuildContext context) {
    return IconNav(
      icons: [
        NavIconData(
          iconPath: 'assets/images/calendar_icon.svg',
          label: 'カレンダー',
          color: Color(0xFF32AF99),
          onTap: () => Navigator.pushNamed(context, '/calendar'),
        ),
        NavIconData(
          iconPath: 'assets/images/graph_icon.svg',
          label: 'グラフ',
          color: Color(0xFFC67945),
          onTap: () => Navigator.pushNamed(context, '/graph'),
        ),
        NavIconData(
          iconPath: 'assets/images/task_create_icon.svg',
          label: 'タスク作成',
          color: Color(0xFFAA92EF),
          onTap: () => Navigator.pushNamed(context, '/task_create'),
        ),
      ],
    );
  }

  Widget _buildTaskLists() {
    final taskData = TaskDataProvider.getTaskData();
    return Column(
      children: taskData
          .map((data) => TaskList(
                title: data.title,
                tasks: data.tasks,
                color: data.color,
              ))
          .toList(),
    );
  }
}
