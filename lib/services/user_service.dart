import 'package:solo/models/user.dart';
import 'package:solo/repositories/database.dart';

class UserService {
  Future<List<User>> getUser() async {
    final userTableRepository = UserTableRepository();
    final users = await userTableRepository.findAll();
    return users;
  }

  Future<int> saveUser(User user) async {
    final userTableRepository = UserTableRepository();
    final userForDB = User(
      id: user.id,
      name: user.name,
      email: user.email,
      defaultWorkSettingId: user.defaultWorkSettingId,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    return await userTableRepository.createUser(userForDB);
  }

  Future<void> deleteUser(User user) async {
    final userTableRepository = UserTableRepository();
    await userTableRepository.deleteUser(user.id);
  }
}
