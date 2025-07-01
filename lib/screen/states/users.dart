import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:solo/models/user.dart';
import 'package:solo/services/user_service.dart';

part 'build/users.g.dart';

@riverpod
class UsersState extends _$UsersState {
  @override
  Future<List<User>> build() async {
    final service = UserService();
    return service.getUser();
  }

  Future<int> addUser(User user) async {
    int id = 0;
    await update((users) async {
      final service = UserService();
      id = await service.saveUser(user);
      return [...users, user];
    });
    return id;
  }

  Future<void> deleteUser(User user) async {
    await update((users) async {
      final service = UserService();
      await service.deleteUser(user);
      return users.where((u) => u.id != user.id).toList();
    });
  }
}
