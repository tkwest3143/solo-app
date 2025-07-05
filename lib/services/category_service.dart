import 'package:solo/models/category_model.dart';
import 'package:solo/repositories/database.dart';
import 'package:solo/repositories/database/drift.dart';
import 'package:drift/drift.dart';

class CategoryService {
  // In-memory storage for prototype - in real app this would be persisted
  static final List<CategoryModel> _inMemoryCategories = [];
  static int _nextId = 1;

  Future<List<CategoryModel>> getCategories() async {
    final categoryTableRepository = CategoryTableRepository();
    final categories = await categoryTableRepository.findAll();

    if (categories.isNotEmpty) {
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

    // If no categories in database, use in-memory categories with default data
    if (_inMemoryCategories.isEmpty) {
      _initializeDefaultCategories();
    }

    return List.from(_inMemoryCategories);
  }

  void _initializeDefaultCategories() {
    final now = DateTime.now();
    _inMemoryCategories.addAll([
      CategoryModel(
        id: _nextId++,
        title: '仕事',
        description: '職場での業務やプロジェクト',
        color: 'blue',
        createdAt: now,
        updatedAt: now,
      ),
      CategoryModel(
        id: _nextId++,
        title: '個人',
        description: '私生活やプライベートな予定',
        color: 'green',
        createdAt: now,
        updatedAt: now,
      ),
      CategoryModel(
        id: _nextId++,
        title: '学習',
        description: '勉強や習得したいスキル',
        color: 'purple',
        createdAt: now,
        updatedAt: now,
      ),
      CategoryModel(
        id: _nextId++,
        title: '健康',
        description: '運動や健康管理',
        color: 'orange',
        createdAt: now,
        updatedAt: now,
      ),
      CategoryModel(
        id: _nextId++,
        title: '緊急',
        description: '重要で急ぎの項目',
        color: 'red',
        createdAt: now,
        updatedAt: now,
      ),
    ]);
  }

  Future<CategoryModel> createCategory({
    required String title,
    String? description,
    required String color,
  }) async {
    final newCategory = CategoryModel(
      id: _nextId++,
      title: title,
      description: description,
      color: color,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    _inMemoryCategories.add(newCategory);
    return newCategory;
  }

  Future<CategoryModel?> updateCategory(
    int id, {
    String? title,
    String? description,
    String? color,
  }) async {
    final index = _inMemoryCategories.indexWhere((c) => c.id == id);
    if (index == -1) return null;

    final category = _inMemoryCategories[index];
    final updatedCategory = category.copyWith(
      title: title ?? category.title,
      description: description ?? category.description,
      color: color ?? category.color,
      updatedAt: DateTime.now(),
    );

    _inMemoryCategories[index] = updatedCategory;
    return updatedCategory;
  }

  Future<bool> deleteCategory(int id) async {
    final index = _inMemoryCategories.indexWhere((c) => c.id == id);
    if (index == -1) return false;

    _inMemoryCategories.removeAt(index);
    return true;
  }

  Future<CategoryModel?> getCategoryById(int id) async {
    try {
      return _inMemoryCategories.firstWhere((c) => c.id == id);
    } catch (e) {
      return null;
    }
  }
}