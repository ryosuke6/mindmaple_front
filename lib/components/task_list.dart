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
        ),
        elevation: 4,
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
              ...tasks.map((task) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Text(
                  task,
                  style: TextStyle(
                    fontSize: 16,
                    color: color,
                  ),
                ),
              )),
            ],
          ),
        ),
      ),
    );
  }
}
