import 'package:freezed_annotation/freezed_annotation.dart';

part 'build/user.freezed.dart';
part 'build/user.g.dart';

@freezed
class User with _$User {
  const factory User({
    required int id,
    required String name,
    required String email,
    DateTime? lastLoginTime,
    int? defaultWorkSettingId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}
