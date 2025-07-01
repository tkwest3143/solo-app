import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:solo/models/user.dart';

class UserAddForm extends HookWidget {
  final Function(User) onAddUser;
  const UserAddForm({super.key, required this.onAddUser});

  @override
  Widget build(BuildContext context) {
    final nameController = useTextEditingController();
    final emailController = useTextEditingController();
    final formKey = GlobalKey<FormState>();
    return Form(
        key: formKey,
        child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Column(spacing: 18.0, children: [
              TextFormField(
                decoration: InputDecoration(labelText: '名前'),
                controller: nameController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '名前を入力してください';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'メールアドレス'),
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'メールアドレスを入力してください';
                  }
                  final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                  if (!emailRegex.hasMatch(value)) {
                    return '有効なメールアドレスを入力してください';
                  }
                  return null;
                },
              ),
              Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                ElevatedButton(
                  onPressed: () {
                    if (formKey.currentState != null &&
                        formKey.currentState!.validate()) {
                      onAddUser(User(
                          id: -1,
                          name: nameController.text,
                          email: emailController.text));
                    }
                  },
                  child: Text('保存する'),
                )
              ])
            ])));
  }
}
