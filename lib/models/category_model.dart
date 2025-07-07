import 'package:freezed_annotation/freezed_annotation.dart';

part 'build/category_model.freezed.dart';
part 'build/category_model.g.dart';

@freezed
sealed class CategoryModel with _$CategoryModel {
  const factory CategoryModel({
    required int id,
    required String title,
    String? description,
    required String color, // Color name from TodoColor enum
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _CategoryModel;

  factory CategoryModel.fromJson(Map<String, dynamic> json) =>
      _$CategoryModelFromJson(json);
}
