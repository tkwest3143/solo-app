import 'package:solo/models/category_model.dart';
import 'package:solo/repositories/database.dart';
import 'package:solo/repositories/database/drift.dart';
import 'package:drift/drift.dart';

class CategoryService {
  final CategoryTableRepository _categoryTableRepository =
      CategoryTableRepository();

  Future<List<CategoryModel>> getCategories() async {
    final categories = await _categoryTableRepository.findAll();
    return categories
        .map((category) => CategoryModel(
              id: category.id,
              title: category.title,
              description: category.description,
              color: category.color,
              createdAt: category.createdAt,
              updatedAt: category.updatedAt,
            ))
        .toList();
  }

  Future<CategoryModel> createCategory({
    required String title,
    String? description,
    required String color,
  }) async {
    final now = DateTime.now();
    final companion = CategoriesCompanion(
      title: Value(title),
      description: Value(description),
      color: Value(color),
      createdAt: Value(now),
      updatedAt: Value(now),
    );
    final id = await _categoryTableRepository.insert(companion);
    return CategoryModel(
      id: id,
      title: title,
      description: description,
      color: color,
      createdAt: now,
      updatedAt: now,
    );
  }

  Future<CategoryModel?> updateCategory(
    int id, {
    String? title,
    String? description,
    String? color,
  }) async {
    final now = DateTime.now();
    final companion = CategoriesCompanion(
      title: title != null ? Value(title) : const Value.absent(),
      description:
          description != null ? Value(description) : const Value.absent(),
      color: color != null ? Value(color) : const Value.absent(),
      updatedAt: Value(now),
    );
    final success = await _categoryTableRepository.update(id, companion);
    if (!success) return null;
    return getCategoryById(id);
  }

  Future<bool> deleteCategory(int id) async {
    return await _categoryTableRepository.delete(id);
  }

  Future<CategoryModel?> getCategoryById(int id) async {
    final categories = await _categoryTableRepository.findAll();
    try {
      final category = categories.firstWhere((c) => c.id == id);
      return CategoryModel(
        id: category.id,
        title: category.title,
        description: category.description,
        color: category.color,
        createdAt: category.createdAt,
        updatedAt: category.updatedAt,
      );
    } catch (e) {
      return null;
    }
  }
}
