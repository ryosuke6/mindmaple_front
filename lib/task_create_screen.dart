import 'package:flutter/material.dart';
import 'package:mindmaple/components/header.dart';
import 'package:mindmaple/components/icon_nav.dart';

class TaskCreateScreen extends StatefulWidget {
  @override
  _TaskCreateScreenState createState() => _TaskCreateScreenState();
}

class _TaskCreateScreenState extends State<TaskCreateScreen> {
  final TextEditingController _taskNameController = TextEditingController();
  final TextEditingController _detailsController = TextEditingController();
  final TextEditingController _dueDateController = TextEditingController();
  final TextEditingController _reminderController = TextEditingController();
  String _priority = '高';
  String _repeat = '毎日';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const Header(title: 'MindMaple'), // Headerコンポーネントを使用
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IconNav(
              icons: [
                NavIconData(
                  iconPath: 'assets/images/back_icon.svg',
                  label: '戻る',
                  color: Color(0xFF32AF99),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                NavIconData(
                  iconPath: 'assets/images/save_icon.svg',
                  label: '保存',
                  color: Color(0xFF7EBAD6),
                  onTap: () {
                    // 保存処理
                  },
                ),
                NavIconData(
                  iconPath: 'assets/images/delete_icon.svg',
                  label: '削除',
                  color: Color(0xFFF76C6A),
                  onTap: () {
                    // 削除処理
                  },
                ),
              ],
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _taskNameController,
              decoration: InputDecoration(
                labelText: 'タスク名',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            DropdownButtonFormField<String>(
              value: _priority,
              items: ['高', '中', '低']
                  .map((label) => DropdownMenuItem(
                        child: Text(label),
                        value: label,
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _priority = value!;
                });
              },
              decoration: InputDecoration(
                labelText: '重要度',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _dueDateController,
              decoration: InputDecoration(
                labelText: '期限',
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.calendar_today),
              ),
              readOnly: true,
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2101),
                );
                if (pickedDate != null) {
                  setState(() {
                    _dueDateController.text =
                        "${pickedDate.year}/${pickedDate.month}/${pickedDate.day}";
                  });
                }
              },
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _detailsController,
              decoration: InputDecoration(
                labelText: '詳細内容',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _reminderController,
              decoration: InputDecoration(
                labelText: 'リマインド',
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.alarm),
              ),
              readOnly: true,
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2101),
                );
                if (pickedDate != null) {
                  TimeOfDay? pickedTime = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );
                  if (pickedTime != null) {
                    setState(() {
                      _reminderController.text =
                          "${pickedDate.year}/${pickedDate.month}/${pickedDate.day} ${pickedTime.hour}:${pickedTime.minute}";
                    });
                  }
                }
              },
            ),
            SizedBox(height: 16.0),
            DropdownButtonFormField<String>(
              value: _repeat,
              items: ['なし', '毎日', '毎週', '毎月']
                  .map((label) => DropdownMenuItem(
                        child: Text(label),
                        value: label,
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _repeat = value!;
                });
              },
              decoration: InputDecoration(
                labelText: '繰り返し通知',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
