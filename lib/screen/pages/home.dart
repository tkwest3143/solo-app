import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:solo/screen/widgets/global.dart';
import 'package:solo/screen/widgets/home.dart';
import 'package:solo/utilities/const/working.dart';

class HomePage extends HookWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final workingState = useState<Working>(Working.notWorking);
    return GlobalLayout(
        child: Column(
      children: [
        Expanded(
            child: CurrentTime(
                working: workingState.value,
                onWorkDateChanged: () =>
                    workingState.value = Working.notWorking)),
        WorkingButtonList(
          working: workingState.value,
          onTapAttendance: () {
            workingState.value = Working.working;
          },
          onTapGoingHome: () {
            workingState.value = Working.goingHome;
          },
          onTapResting: () {
            workingState.value = Working.resting;
          },
          onTapBackOffice: () {
            workingState.value = Working.working;
          },
        )
      ],
    ));
  }
}
