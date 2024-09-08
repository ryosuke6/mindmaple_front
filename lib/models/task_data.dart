class TaskData {
  final String title;
  final DateTime startTime;
  final DateTime endTime;

  TaskData(
      {required this.title, required this.startTime, required this.endTime});
}

List<TaskData> getDummyTasks() {
  return [
    TaskData(
      title: 'タスク名1',
      startTime: DateTime(
          DateTime.now().year, DateTime.now().month, DateTime.now().day, 10),
      endTime: DateTime(
          DateTime.now().year, DateTime.now().month, DateTime.now().day, 11),
    ),
    TaskData(
      title: 'タスク名2',
      startTime: DateTime(
          DateTime.now().year, DateTime.now().month, DateTime.now().day, 12),
      endTime: DateTime(
          DateTime.now().year, DateTime.now().month, DateTime.now().day, 14),
    ),
  ];
}
