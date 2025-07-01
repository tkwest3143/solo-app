import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:solo/models/work_time.dart';
import 'package:solo/screen/widgets/global.dart';
import 'package:solo/utilities/date.dart';

class MonthSelect extends StatelessWidget {
  final void Function(DateTime) onMonthChanged;
  final DateTime selectedMonth;
  const MonthSelect(
      {super.key, required this.onMonthChanged, required this.selectedMonth});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 16),
          child: Text(
            "${selectedMonth.year}年 ${selectedMonth.month}月",
            style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
          ),
        ),
        Row(
          children: [
            IconButton(
              icon: Icon(Icons.arrow_back_ios, size: 32),
              onPressed: () {
                onMonthChanged(
                    DateTime(selectedMonth.year, selectedMonth.month - 1));
              },
            ),
            IconButton(
              icon: Icon(Icons.arrow_forward_ios, size: 32),
              onPressed: () {
                onMonthChanged(
                    DateTime(selectedMonth.year, selectedMonth.month + 1));
              },
            ),
          ],
        ),
      ],
    );
  }
}

class WorkingList extends StatelessWidget {
  final List<WorkTime> workTimes;
  final void Function(WorkTime) onTap;
  const WorkingList({super.key, required this.workTimes, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: workTimes.length,
      itemBuilder: (context, index) {
        return WorkingListItem(
          workTime: workTimes[index],
          onTap: () => onTap(workTimes[index]),
        );
      },
    );
  }
}

class WorkingListItem extends StatelessWidget {
  final WorkTime workTime;
  final void Function() onTap;
  const WorkingListItem(
      {super.key, required this.workTime, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final date = parseDate(workTime.targetDay, format: 'yyy-MM-dd');
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    formatDate(date, format: 'yyyy/MM/dd (E)'),
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: date.weekday == DateTime.saturday
                          ? Colors.blue
                          : date.weekday == DateTime.sunday
                              ? Colors.red
                              : Colors.black,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "稼働開始: ${workTime.start != null ? formatDate(workTime.start!, format: 'HH:mm') : "00:00"}",
                    style: TextStyle(fontSize: 16),
                  ),
                  Text(
                    "稼働終了: ${workTime.end != null ? formatDate(workTime.end!, format: 'HH:mm') : "00:00"}",
                    style: TextStyle(fontSize: 16),
                  ),
                  Text(
                    "休憩時間: ${workTime.breakTime}",
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
              Icon(Icons.edit)
            ],
          ),
        ),
      ),
    );
  }
}

class WorkingTimeOnMonth extends StatelessWidget {
  final List<WorkTime> workTimes;
  const WorkingTimeOnMonth({super.key, required this.workTimes});

  @override
  Widget build(BuildContext context) {
    final totalWorkingTime =
        workTimes.fold<int>(0, (sum, workTime) => sum + workTime.workingTime);
    final hours = totalWorkingTime ~/ 60;
    final minutes = totalWorkingTime % 60;

    return Text(
      "$hours時間 $minutes分",
      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    );
  }
}

class EditWorkTimeDialog extends HookWidget {
  final WorkTime workTime;
  final void Function(WorkTime) onSave;
  const EditWorkTimeDialog(
      {super.key, required this.workTime, required this.onSave});

  @override
  Widget build(BuildContext context) {
    final startController = useTextEditingController();
    final endController = useTextEditingController();
    final restStartController = useTextEditingController();
    final restEndController = useTextEditingController();
    final isWorkingDay = useState(workTime.start != null);
    final memoController = useTextEditingController(text: workTime.memo);

    startController.text = workTime.start != null
        ? formatDate(workTime.start!, format: 'HH:mm')
        : "00:00";
    endController.text = workTime.end != null
        ? formatDate(workTime.end!, format: 'HH:mm')
        : "00:00";
    restStartController.text = workTime.restStart != null
        ? formatDate(workTime.restStart!, format: 'HH:mm')
        : "00:00";
    restEndController.text = workTime.restEnd != null
        ? formatDate(workTime.restEnd!, format: 'HH:mm')
        : "00:00";

    return AlertDialog(
      title: Text(
        formatDate(workTime.targetDayToDateTime, format: 'yyyy / M / d (E)'),
        style: TextStyle(
          color: workTime.targetDayToDateTime.weekday == DateTime.saturday
              ? Colors.blue
              : workTime.targetDayToDateTime.weekday == DateTime.sunday
                  ? Colors.red
                  : Colors.black,
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          WorkSwitchButton(
            isWorking: isWorkingDay.value,
            onTap: (value) {
              isWorkingDay.value = value;
            },
          ),
          if (isWorkingDay.value) ...[
            TimeRangeInput(
              startController: startController,
              endController: endController,
              label: "稼働時間",
            ),
            TimeRangeInput(
              startController: restStartController,
              endController: restEndController,
              label: "休憩時間",
            )
          ],
          TextFormField(
            controller: memoController,
            decoration: InputDecoration(
              labelText: "メモ",
              hintText: "メモを入力してください",
            ),
            maxLines: 3,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text("キャンセル"),
        ),
        TextButton(
          onPressed: () {
            onSave(
              WorkTime(
                  id: workTime.id,
                  userId: workTime.userId,
                  targetDay: workTime.targetDay,
                  start: parseDate(startController.text, format: 'HH:mm'),
                  end: parseDate(endController.text, format: 'HH:mm'),
                  restStart:
                      parseDate(restStartController.text, format: 'HH:mm'),
                  restEnd: parseDate(restEndController.text, format: 'HH:mm'),
                  memo: memoController.text),
            );
            Navigator.of(context).pop();
          },
          child: Text("保存"),
        ),
      ],
    );
  }
}

class WorkSwitchButton extends StatelessWidget {
  final bool isWorking;
  final void Function(bool) onTap;
  const WorkSwitchButton(
      {super.key, required this.isWorking, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text("稼働日",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        CupertinoSwitch(
          value: isWorking,
          onChanged: onTap,
        )
      ],
    );
  }
}

class TimeRangeInput extends StatelessWidget {
  final TextEditingController startController;
  final TextEditingController endController;
  final String label;
  const TimeRangeInput(
      {super.key,
      required this.startController,
      required this.endController,
      required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
          Row(
            children: [
              Expanded(
                child: TimeInputForm(
                  controller: startController,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  "〜",
                  style: TextStyle(fontSize: 18),
                ),
              ),
              Expanded(
                child: TimeInputForm(
                  controller: endController,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
