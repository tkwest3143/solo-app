import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:solo/screen/states/state.dart';
import 'package:solo/screen/states/work_time_list.dart';
import 'package:solo/screen/widgets/work_time_list.dart';

class WorkListPage extends HookConsumerWidget {
  const WorkListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedMonth = useState<DateTime>(DateTime.now());
    final selectedUser = ref.watch(globalStateProvider);
    final workTimeList = ref.watch(workTimeListStateProvider(selectedUser!.id));
    return workTimeList.when(data: (workTimes) {
      return Column(
        children: [
          MonthSelect(
            onMonthChanged: (DateTime month) async {
              selectedMonth.value = month;
              await ref
                  .read(workTimeListStateProvider(selectedUser.id).notifier)
                  .changeMonth(selectedUser.id, month);
            },
            selectedMonth: selectedMonth.value,
          ),
          Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  WorkingTimeOnMonth(
                    workTimes: workTimes,
                  )
                ],
              )),
          Expanded(
              child: WorkingList(
                  workTimes: workTimes,
                  onTap: (workTime) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return EditWorkTimeDialog(
                          workTime: workTime,
                          onSave: (workTime) async {
                            await ref
                                .read(workTimeListStateProvider(selectedUser.id)
                                    .notifier)
                                .updateWorkTime(workTime);
                          },
                        );
                      },
                    );
                  })),
        ],
      );
    }, loading: () {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }, error: (error, _) {
      return Center(
        child: Text('Error: $error'),
      );
    });
  }
}
