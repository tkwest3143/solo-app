#!/usr/bin/env dart

// Test script to verify category functionality
import '../lib/models/category_model.dart';
import '../lib/services/category_service.dart';

void main() async {
  print('Testing Category Service...');
  
  final categoryService = CategoryService();
  
  // Test getting default categories
  final categories = await categoryService.getCategories();
  print('Default categories loaded: ${categories.length}');
  
  for (final category in categories) {
    print('- ${category.title}: ${category.description} (${category.color})');
  }
  
  // Test creating a new category
  final newCategory = await categoryService.createCategory(
    title: 'テストカテゴリ',
    description: 'テスト用のカテゴリです',
    color: 'red',
  );
  
  print('\nNew category created: ${newCategory.title}');
  
  // Test getting categories again
  final updatedCategories = await categoryService.getCategories();
  print('Total categories after creation: ${updatedCategories.length}');
  
  print('Category service test completed successfully!');
}