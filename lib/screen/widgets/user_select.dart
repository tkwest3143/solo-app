import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:solo/models/user.dart';
import 'package:solo/screen/router.dart';
import 'package:solo/screen/states/state.dart';
import 'package:solo/utilities/date.dart';

class AddUserCard extends StatelessWidget {
  const AddUserCard({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => nextRouting(context, RouterDefinition.addUser),
      child: DottedBorder(
        color: Colors.grey,
        borderType: BorderType.RRect,
        radius: Radius.circular(10),
        strokeWidth: 2.0,
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.5 - 20,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.add,
                size: 50.0,
                color: Colors.grey,
              ),
              SizedBox(height: 10.0),
              Text(
                '追加する',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 20.0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class UserCard extends ConsumerWidget {
  final User user;

  const UserCard({super.key, required this.user});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
        onTap: () {
          ref.read(globalStateProvider.notifier).state = user;
          // 状態が更新された後に画面遷移を行う
          WidgetsBinding.instance.addPostFrameCallback((_) {
            nextRouting(context, RouterDefinition.home);
          });
        },
        child: Card(
            color: Theme.of(context).cardColor,
            shadowColor: Theme.of(context).shadowColor,
            elevation: 8,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 10.0),
                    Text(
                      user.name,
                      style: TextStyle(
                        fontSize: 20.0,
                      ),
                    ),
                    SizedBox(height: 5.0),
                    Text(
                      user.email,
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.grey,
                      ),
                    ),
                    if (user.lastLoginTime != null)
                      Text(
                        '最終にアクセスした日: ${formatDate(user.lastLoginTime!, format: 'yyyy/M/d')}',
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.grey,
                        ),
                      ),
                  ],
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    iconSize: 36.0,
                    icon: Icon(Icons.close_rounded, color: Colors.grey),
                    onPressed: () {
                      // Handle user deletion
                    },
                  ),
                ),
              ],
            )));
  }
}
