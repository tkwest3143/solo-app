import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:solo/screen/router.dart';
import 'package:solo/screen/states/work_setting_add.dart';

class UserInputCompletePage extends ConsumerWidget {
  final int userId;
  const UserInputCompletePage({super.key, required this.userId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
              padding: EdgeInsets.all(8.0),
              child: Align(
                alignment: Alignment.center,
                child: Text('ユーザーの保存が完了しました',
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    )),
              )),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 8.0,
            children: [
              GestureDetector(
                onTap: () {
                  if (context.mounted) {
                    nextRouting(context, RouterDefinition.root);
                  }
                },
                child: Container(
                  padding: EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Text(
                    'ユーザー選択に戻る',
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 16.0,
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  if (context.mounted) {
                    ref
                        .read(workSettingAddStateProvider.notifier)
                        .update(userId: userId);
                    nextRouting(context, RouterDefinition.addWorkSetting);
                  }
                },
                child: Container(
                  padding: EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Text(
                    '続けて勤務時間設定を登録する',
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 16.0,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
