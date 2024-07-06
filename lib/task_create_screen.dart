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
  void didChangeDependencies() {
    super.didChangeDependencies();
    final String? task = ModalRoute.of(context)?.settings.arguments as String?;
    if (task != null) {
      _taskNameController.text = task;
    }
  }

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
                  color: Colors.green,
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
            _buildTextField('タスク名', _taskNameController),
            SizedBox(height: 16.0),
            _buildDropdownButton('重要度', _priority, ['高', '中', '低'], (value) {
              setState(() {
                _priority = value!;
              });
            }),
            SizedBox(height: 16.0),
            _buildDateField('期限', _dueDateController, context),
            SizedBox(height: 16.0),
            _buildTextField('詳細内容', _detailsController, maxLines: 3),
            SizedBox(height: 16.0),
            _buildDateTimeField('リマインド', _reminderController, context),
            SizedBox(height: 16.0),
            _buildDropdownButton('繰り返し通知', _repeat, ['なし', '毎日', '毎週', '毎月'], (value) {
              setState(() {
                _repeat = value!;
              });
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, {int maxLines = 1}) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.green, fontWeight: FontWeight.bold), // ラベルの色を変更
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: Colors.green, width: 2.0), // 枠線の色を変更
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: Colors.green, width: 2.0), // 有効時の枠線の色を変更
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: Colors.green, width: 2.0), // フォーカス時の枠線の色を変更
        ),
        filled: true,
        fillColor: Colors.white,
      ),
      maxLines: maxLines,
      style: TextStyle(fontWeight: FontWeight.bold), // テキストを太くする
    );
  }

  Widget _buildDropdownButton(String label, String value, List<String> items, ValueChanged<String?> onChanged) {
    return DropdownButtonFormField<String>(
      value: value,
      items: items.map((label) => DropdownMenuItem(
        child: Text(label, style: TextStyle(fontWeight: FontWeight.bold)), // テキストを太くする
        value: label,
      )).toList(),
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.green, fontWeight: FontWeight.bold), // ラベルの色を変更
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: Colors.green, width: 2.0), // 枠線の色を変更
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: Colors.green, width: 2.0), // 有効時の枠線の色を変更
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: Colors.green, width: 2.0), // フォーカス時の枠線の色を変更
        ),
        filled: true,
        fillColor: Colors.white,
      ),
    );
  }

  Widget _buildDateField(String label, TextEditingController controller, BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.green, fontWeight: FontWeight.bold), // ラベルの色を変更
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: Colors.green, width: 2.0), // 枠線の色を変更
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: Colors.green, width: 2.0), // 有効時の枠線の色を変更
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: Colors.green, width: 2.0), // フォーカス時の枠線の色を変更
        ),
        suffixIcon: Icon(Icons.calendar_today, color: Colors.green),
        filled: true,
        fillColor: Colors.white,
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
            controller.text = "${pickedDate.year}/${pickedDate.month}/${pickedDate.day}";
          });
        }
      },
      style: TextStyle(fontWeight: FontWeight.bold), // テキストを太くする
    );
  }

  Widget _buildDateTimeField(String label, TextEditingController controller, BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.green, fontWeight: FontWeight.bold), // ラベルの色を変更
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: Colors.green, width: 2.0), // 枠線の色を変更
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: Colors.green, width: 2.0), // 有効時の枠線の色を変更
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: Colors.green, width: 2.0), // フォーカス時の枠線の色を変更
        ),
        suffixIcon: Icon(Icons.alarm, color: Colors.green),
        filled: true,
        fillColor: Colors.white,
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
              controller.text = "${pickedDate.year}/${pickedDate.month}/${pickedDate.day} ${pickedTime.hour}:${pickedTime.minute}";
            });
          }
        }
      },
      style: TextStyle(fontWeight: FontWeight.bold), // テキストを太くする
    );
  }
}
