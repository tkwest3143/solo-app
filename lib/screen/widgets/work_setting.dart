import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:solo/models/work_setting.dart';
import 'package:solo/screen/widgets/global.dart';
import 'package:solo/utilities/date.dart';

class WorkSettingForm extends HookWidget {
  final void Function(WorkSetting) onSave;
  const WorkSettingForm({super.key, required this.onSave});

  @override
  Widget build(BuildContext context) {
    final titleController = useTextEditingController();
    final restStartController = useTextEditingController();
    final restEndController = useTextEditingController();
    final startController = useTextEditingController();
    final endController = useTextEditingController();
    final workTimeUnitController = useTextEditingController();
    final memoController = useTextEditingController();
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Column(spacing: 18.0, children: [
          TextField(
            decoration: InputDecoration(labelText: 'タイトル'),
            controller: titleController,
            keyboardType: TextInputType.datetime,
          ),
          Row(
            spacing: 8.0,
            children: [
              SizedBox(
                width: MediaQuery.sizeOf(context).width * 0.4 - 20,
                child: TimeInputForm(
                  controller: startController,
                  label: "勤務開始",
                ),
              ),
              Text('〜', style: TextStyle(fontSize: 20.0)),
              SizedBox(
                width: MediaQuery.sizeOf(context).width * 0.4 - 20,
                child: TimeInputForm(
                  controller: endController,
                  label: "勤務終了",
                ),
              ),
            ],
          ),
          Row(
            spacing: 8.0,
            children: [
              SizedBox(
                width: MediaQuery.sizeOf(context).width * 0.4 - 20,
                child: TimeInputForm(
                  controller: restStartController,
                  label: "休憩開始",
                ),
              ),
              Text('〜', style: TextStyle(fontSize: 20.0)),
              SizedBox(
                width: MediaQuery.sizeOf(context).width * 0.4 - 20,
                child: TimeInputForm(
                  controller: restEndController,
                  label: "休憩終了",
                ),
              ),
            ],
          ),
          TextField(
            decoration: InputDecoration(labelText: '勤務時間単位(分)'),
            controller: workTimeUnitController,
            keyboardType: TextInputType.number,
          ),
          TextField(
            maxLines: 3,
            decoration: InputDecoration(labelText: 'メモ'),
            controller: memoController,
            keyboardType: TextInputType.multiline,
          ),
          ElevatedButton(
            onPressed: () {
              final workSetting = WorkSetting(
                id: -1,
                title: titleController.text,
                start: parseDate(startController.text),
                end: parseDate(endController.text),
                restStart: parseDate(restStartController.text),
                restEnd: parseDate(restEndController.text),
                workingUnit: int.parse(workTimeUnitController.text),
                memo: memoController.text,
                userId: -1,
              );
              onSave(workSetting);
            },
            child: Text('保存する'),
          ),
        ]));
  }
}
