import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:solo/screen/router.dart';
import 'package:solo/screen/states/work_setting_add.dart';
import 'package:solo/screen/widgets/work_setting.dart';

class WorkSettingInputPage extends ConsumerWidget {
  const WorkSettingInputPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.arrow_back), onPressed: () => context.pop()),
      ),
      body: Column(
        children: [
          Padding(
              padding: EdgeInsets.all(8.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text('勤務時間を作成',
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    )),
              )),
          WorkSettingForm(
            onSave: (workSetting) async {
              ref.read(workSettingAddStateProvider.notifier).update(
                    start: workSetting.start,
                    end: workSetting.end,
                    restStart: workSetting.restStart,
                    restEnd: workSetting.restEnd,
                    title: workSetting.title,
                    memo: workSetting.memo,
                  );
              await ref.read(workSettingAddStateProvider.notifier).onSave();
              if (context.mounted) {
                nextRouting(context, RouterDefinition.root);
              }
            },
          ),
        ],
      ),
    );
  }
}
