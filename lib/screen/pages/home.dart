import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:solo/screen/states/home.dart';
import 'package:solo/screen/widgets/home.dart';
import 'package:solo/utilities/const/working.dart';

class HomePage extends HookConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final workingState = useState<Working>(Working.notWorking);
    final homeState = ref.watch(homeStateProvider);
    return homeState.when(data: (workTime) {
      return Column(
        children: [
          SizedBox(
              height: MediaQuery.sizeOf(context).height * 0.3,
              child: CurrentTime(
                  working: workingState.value,
                  onWorkDateChanged: () =>
                      workingState.value = Working.notWorking)),
          SizedBox(
            height: MediaQuery.sizeOf(context).height * 0.3,
            child: WorkingButtonList(
              working: workingState.value,
              onTapAttendance: () async {
                workingState.value = Working.working;
                await ref
                    .read(homeStateProvider.notifier)
                    .updateWorkTime(workTime.copyWith(start: DateTime.now()));
              },
              onTapGoingHome: () async {
                workingState.value = Working.goingHome;
                await ref
                    .read(homeStateProvider.notifier)
                    .updateWorkTime(workTime.copyWith(end: DateTime.now()));
              },
              onTapResting: () async {
                workingState.value = Working.resting;
                await ref.read(homeStateProvider.notifier).updateWorkTime(
                    workTime.copyWith(restStart: DateTime.now()));
              },
              onTapBackOffice: () async {
                workingState.value = Working.working;
                await ref
                    .read(homeStateProvider.notifier)
                    .updateWorkTime(workTime.copyWith(restEnd: DateTime.now()));
              },
            ),
          ),
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
