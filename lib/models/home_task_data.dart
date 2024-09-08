import 'package:flutter/material.dart';
import 'package:mindmaple/constants.dart';

class TaskData {
  final String title;
  final List<String> tasks;
  final Color color;

  TaskData({required this.title, required this.tasks, required this.color});
}

class TaskDataProvider {
  static List<TaskData> getTaskData() {
    return [
      TaskData(
        title: '今日のタスク',
        tasks: [
          'タスク1/優先度/期限',
          'タスク2/優先度/期限',
          'タスク3/優先度/期限',
          'タスク4/優先度/期限',
          'タスク5/優先度/期限',
        ],
        color: AppColors.todayTaskColor,
      ),
      TaskData(
        title: '直近の優先タスク',
        tasks: [
          'タスク1/優先度/期限',
          'タスク2/優先度/期限',
          'タスク3/優先度/期限',
          'タスク4/優先度/期限',
          'タスク5/優先度/期限',
        ],
        color: AppColors.priorityTaskColor,
      ),
    ];
  }
}
