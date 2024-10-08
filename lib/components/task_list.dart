import 'package:flutter/material.dart';

class TaskList extends StatelessWidget {
  final String title;
  final List<String> tasks;
  final Color color;

  const TaskList({
    Key? key,
    required this.title,
    required this.tasks,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(color: color, width: 2),
        ),
        elevation: 4,
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              Divider(color: color),
              ...tasks.map((task) => _buildTaskItem(context, task, color)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTaskItem(BuildContext context, String task, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: GestureDetector(
        onTap: () => Navigator.pushNamed(
          context,
          '/task_create',
          arguments: task,
        ),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            border: Border.all(color: color),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Text(
            task,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: color,
            ),
          ),
        ),
      ),
    );
  }
}
