import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:solo/screen/states/users.dart';
import 'package:solo/screen/widgets/user_select.dart';

class UserSelectPage extends HookConsumerWidget {
  const UserSelectPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userSelectState = ref.watch(usersStateProvider);

    return userSelectState.when(
      data: (users) {
        return Scaffold(
          appBar: AppBar(
            title: Text('どのデータを利用しますか？'),
          ),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 8.0,
                crossAxisSpacing: 8.0,
              ),
              itemCount: users.length + 1,
              itemBuilder: (context, index) {
                if (index < users.length) {
                  return UserCard(user: users[index]);
                }
                return AddUserCard();
              },
            ),
          ),
        );
      },
      loading: () {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
      error: (error, _) {
        return Center(
          child: Text('Error: $error'),
        );
      },
    );
  }
}
