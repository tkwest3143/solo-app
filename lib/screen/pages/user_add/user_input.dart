import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:solo/screen/router.dart';
import 'package:solo/screen/states/users.dart';
import 'package:solo/screen/widgets/user_add.dart';

class UserInputPage extends ConsumerWidget {
  const UserInputPage({super.key});

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
                child: Text('ユーザーを作成',
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    )),
              )),
          UserAddForm(
            onAddUser: (user) async {
              final id =
                  await ref.read(usersStateProvider.notifier).addUser(user);
              if (context.mounted) {
                context.go(RouterDefinition.userInputComplete.path, extra: id);
              }
            },
          ),
        ],
      ),
    );
  }
}
