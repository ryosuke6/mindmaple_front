enum TaskPriority { high, medium, low }

class TaskData {
  final Map<TaskPriority, int> counts;

  TaskData(this.counts);
}
