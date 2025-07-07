import 'package:drift/drift.dart';
import 'package:solo/models/todo_checklist_item_model.dart';
import 'package:solo/repositories/database.dart';
import 'package:solo/repositories/database/drift.dart';

class TodoCheckListItemService {
  final TodoCheckListItemTableRepository _repository =
      TodoCheckListItemTableRepository();

  Future<List<TodoCheckListItemModel>> getCheckListItemsForTodo(
      int todoId) async {
    final items = await _repository.findByTodoId(todoId);
    return items
        .map((item) => TodoCheckListItemModel(
              id: item.id,
              todoId: item.todoId,
              title: item.title,
              isCompleted: item.isCompleted,
              order: item.order,
              createdAt: item.createdAt ?? DateTime.now(),
              updatedAt: item.updatedAt ?? DateTime.now(),
            ))
        .toList();
  }

  Future<TodoCheckListItemModel> createCheckListItem({
    required int todoId,
    required String title,
    required int order,
  }) async {
    final now = DateTime.now();
    final companion = TodoCheckListItemsCompanion(
      todoId: Value(todoId),
      title: Value(title),
      isCompleted: const Value(false),
      order: Value(order),
      createdAt: Value(now),
      updatedAt: Value(now),
    );

    final id = await _repository.insert(companion);
    return TodoCheckListItemModel(
      id: id,
      todoId: todoId,
      title: title,
      isCompleted: false,
      order: order,
      createdAt: now,
      updatedAt: now,
    );
  }

  Future<bool> updateCheckListItem(
    int id, {
    String? title,
    bool? isCompleted,
    int? order,
  }) async {
    final companion = TodoCheckListItemsCompanion(
      title: title != null ? Value(title) : const Value.absent(),
      isCompleted:
          isCompleted != null ? Value(isCompleted) : const Value.absent(),
      order: order != null ? Value(order) : const Value.absent(),
      updatedAt: Value(DateTime.now()),
    );

    return await _repository.update(id, companion);
  }

  Future<bool> deleteCheckListItem(int id) async {
    return await _repository.delete(id);
  }

  Future<bool> deleteAllCheckListItemsForTodo(int todoId) async {
    return await _repository.deleteByTodoId(todoId);
  }

  Future<bool> toggleCheckListItemComplete(int id) async {
    final item = await _repository.findById(id);
    if (item == null) return false;

    final companion = TodoCheckListItemsCompanion(
      isCompleted: Value(!item.isCompleted),
      updatedAt: Value(DateTime.now()),
    );

    return await _repository.update(id, companion);
  }

  Future<bool> areAllCheckListItemsCompleted(int todoId) async {
    final items = await getCheckListItemsForTodo(todoId);
    if (items.isEmpty) {
      return false; // No checklist items means not all completed
    }
    return items.every((item) => item.isCompleted);
  }

  Future<void> reorderCheckListItems(int todoId, List<int> newOrder) async {
    for (int i = 0; i < newOrder.length; i++) {
      await updateCheckListItem(newOrder[i], order: i);
    }
  }
  // Methods for handling virtual recurring todo checklist persistence

  /// Gets persistent checklist items for a virtual todo, falling back to template if none exist
  Future<List<TodoCheckListItemModel>> getVirtualCheckListItems({
    required int virtualTodoId,
    required int originalTodoId,
  }) async {
    // First try to get any persistent entries for this virtual todo
    final persistentItems = await _repository.findByTodoId(virtualTodoId);

    if (persistentItems.isNotEmpty) {
      // Return persistent items if they exist
      return persistentItems
          .map((item) => TodoCheckListItemModel(
                id: item.id,
                todoId: item.todoId,
                title: item.title,
                isCompleted: item.isCompleted,
                order: item.order,
                createdAt: item.createdAt ?? DateTime.now(),
                updatedAt: item.updatedAt ?? DateTime.now(),
              ))
          .toList();
    } else {
      // Fall back to template items from original todo
      final templateItems = await getCheckListItemsForTodo(originalTodoId);

      // Return template items with virtual associations but keep original IDs
      return templateItems.map((item) {
        return TodoCheckListItemModel(
          id: item.id, // Keep original ID for template reference
          todoId: virtualTodoId, // Associate with virtual todo
          title: item.title,
          isCompleted:
              false, // Always start unchecked for new virtual instances
          order: item.order,
          createdAt: item.createdAt,
          updatedAt: item.updatedAt,
        );
      }).toList();
    }
  }

  /// Creates or updates a persistent checklist item for a virtual recurring todo instance
  Future<bool> saveVirtualCheckListItemState({
    required int virtualTodoId,
    required int templateItemId,
    required String title,
    required bool isCompleted,
    required int order,
  }) async {
    // Check if a persistent entry already exists for this virtual todo and template item
    final existingItems = await _repository.findByTodoId(virtualTodoId);
    TodoCheckListItem? existingItem;
    try {
      existingItem = existingItems
          .firstWhere((item) => item.title == title && item.order == order);
    } catch (e) {
      existingItem = null;
    }

    if (existingItem != null) {
      // Update existing persistent entry
      final companion = TodoCheckListItemsCompanion(
        isCompleted: Value(isCompleted),
        updatedAt: Value(DateTime.now()),
      );
      return await _repository.update(existingItem.id, companion);
    } else {
      // Create new persistent entry
      final now = DateTime.now();
      final companion = TodoCheckListItemsCompanion(
        todoId: Value(virtualTodoId), // Store with virtual todo ID
        title: Value(title),
        isCompleted: Value(isCompleted),
        order: Value(order),
        createdAt: Value(now),
        updatedAt: Value(now),
      );

      await _repository.insert(companion);
      return true;
    }
  }

  /// Deletes all persistent checklist items for a virtual todo
  Future<bool> deleteVirtualCheckListItems(int virtualTodoId) async {
    return await _repository.deleteByTodoId(virtualTodoId);
  }
}
