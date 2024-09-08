import 'package:flutter/material.dart';
import 'package:mindmaple/components/header.dart';
import 'package:mindmaple/components/icon_nav.dart';
import 'package:provider/provider.dart';

class TaskCreateScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TaskCreateModel(),
      child: TaskCreateView(),
    );
  }
}

class TaskCreateView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final model = Provider.of<TaskCreateModel>(context);
    return Scaffold(
      appBar: const Header(title: 'MindMaple'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IconNav(icons: _buildNavIcons(context)),
            SizedBox(height: 16.0),
            CustomTextField(
                label: 'タスク名', controller: model.taskNameController),
            SizedBox(height: 16.0),
            CustomDropdownButton(
              label: '重要度',
              value: model.priority,
              items: ['高', '中', '低'],
              onChanged: (value) => model.setPriority(value!),
            ),
            SizedBox(height: 16.0),
            _buildDateField('期限', model.dueDateController, context),
            SizedBox(height: 16.0),
            CustomTextField(
                label: '詳細内容',
                controller: model.detailsController,
                maxLines: 3),
            SizedBox(height: 16.0),
            _buildDateTimeField('リマインド', model.reminderController, context),
            SizedBox(height: 16.0),
            CustomDropdownButton(
              label: '繰り返し通知',
              value: model.repeat,
              items: ['なし', '毎日', '毎週', '毎月'],
              onChanged: (value) => model.setRepeat(value!),
            ),
          ],
        ),
      ),
    );
  }

  List<NavIconData> _buildNavIcons(BuildContext context) {
    return [
      NavIconData(
        iconPath: 'assets/images/back_icon.svg',
        label: '戻る',
        color: Colors.green,
        onTap: () => Navigator.pop(context),
      ),
      NavIconData(
        iconPath: 'assets/images/save_icon.svg',
        label: '保存',
        color: Color(0xFF7EBAD6),
        onTap: () {
          // 保存処理
          final model = Provider.of<TaskCreateModel>(context, listen: false);
          model.saveTask();
          Navigator.pop(context);
        },
      ),
      NavIconData(
        iconPath: 'assets/images/delete_icon.svg',
        label: '削除',
        color: Color(0xFFF76C6A),
        onTap: () {
          // 削除処理
          final model = Provider.of<TaskCreateModel>(context, listen: false);
          model.deleteTask();
          Navigator.pop(context);
        },
      ),
    ];
  }

  Widget _buildDateField(
      String label, TextEditingController controller, BuildContext context) {
    final model = Provider.of<TaskCreateModel>(context, listen: false);
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
            color: Colors.green, fontWeight: FontWeight.bold), // ラベルの色を変更
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: Colors.green, width: 2.0), // 枠線の色を変更
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide:
              BorderSide(color: Colors.green, width: 2.0), // 有効時の枠線の色を変更
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide:
              BorderSide(color: Colors.green, width: 2.0), // フォーカス時の枠線の色を変更
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
          model.setDate(controller, pickedDate);
        }
      },
      style: TextStyle(fontWeight: FontWeight.bold), // テキストを太くする
    );
  }

  Widget _buildDateTimeField(
      String label, TextEditingController controller, BuildContext context) {
    final model = Provider.of<TaskCreateModel>(context, listen: false);
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
            color: Colors.green, fontWeight: FontWeight.bold), // ラベルの色を変更
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: Colors.green, width: 2.0), // 枠線の色を変更
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide:
              BorderSide(color: Colors.green, width: 2.0), // 有効時の枠線の色を変更
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide:
              BorderSide(color: Colors.green, width: 2.0), // フォーカス時の枠線の色を変更
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
            model.setDateTime(controller, pickedDate, pickedTime);
          }
        }
      },
      style: TextStyle(fontWeight: FontWeight.bold), // テキストを太くする
    );
  }
}

// 新しい抽象化されたウィジェット
class CustomTextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final int maxLines;

  const CustomTextField({
    Key? key,
    required this.label,
    required this.controller,
    this.maxLines = 1,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: Colors.green, width: 2.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: Colors.green, width: 2.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: Colors.green, width: 2.0),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
      style: TextStyle(fontWeight: FontWeight.bold),
    );
  }
}

class CustomDropdownButton extends StatelessWidget {
  final String label;
  final String value;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  const CustomDropdownButton({
    Key? key,
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: value,
      items: items
          .map((label) => DropdownMenuItem(
                child:
                    Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
                value: label,
              ))
          .toList(),
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: Colors.green, width: 2.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: Colors.green, width: 2.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: Colors.green, width: 2.0),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
    );
  }
}

class TaskCreateModel extends ChangeNotifier {
  final TextEditingController taskNameController = TextEditingController();
  final TextEditingController detailsController = TextEditingController();
  final TextEditingController dueDateController = TextEditingController();
  final TextEditingController reminderController = TextEditingController();
  String _priority = '高';
  String _repeat = '毎日';

  String get priority => _priority;
  String get repeat => _repeat;

  void setPriority(String value) {
    _priority = value;
    notifyListeners();
  }

  void setRepeat(String value) {
    _repeat = value;
    notifyListeners();
  }

  void setDate(TextEditingController controller, DateTime date) {
    controller.text = "${date.year}/${date.month}/${date.day}";
    notifyListeners();
  }

  void setDateTime(
      TextEditingController controller, DateTime date, TimeOfDay time) {
    controller.text =
        "${date.year}/${date.month}/${date.day} ${time.hour}:${time.minute}";
    notifyListeners();
  }

  // ... その他のメソッド ...

  void saveTask() {
    // タスクの保存処理を実装
    // 例: データベースに保存、APIに送信など
    print('タスクが保存されました');
    notifyListeners();
  }

  void deleteTask() {
    // タスクの削除処理を実装
    // 例: データベースから削除、APIに削除リクエストを送信など
    print('タスクが削除されました');
    notifyListeners();
  }
}
