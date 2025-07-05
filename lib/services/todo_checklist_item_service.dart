import 'package:solo/models/todo_checklist_item_model.dart';

class TodoCheckListItemService {
  // In-memory storage for prototype - in real app this would be persisted
  static final List<TodoCheckListItemModel> _inMemoryItems = [];
  static int _nextId = 1;

  Future<List<TodoCheckListItemModel>> getCheckListItemsForTodo(int todoId) async {
    return _inMemoryItems
        .where((item) => item.todoId == todoId)
        .toList()
      ..sort((a, b) => a.order.compareTo(b.order));
  }

  Future<TodoCheckListItemModel> createCheckListItem({
    required int todoId,
    required String title,
    required int order,
  }) async {
    final now = DateTime.now();
    final newItem = TodoCheckListItemModel(
      id: _nextId++,
      todoId: todoId,
      title: title,
      isCompleted: false,
      order: order,
      createdAt: now,
      updatedAt: now,
    );
    
    _inMemoryItems.add(newItem);
    return newItem;
  }

  Future<bool> updateCheckListItem(
    int id, {
    String? title,
    bool? isCompleted,
    int? order,
  }) async {
    final index = _inMemoryItems.indexWhere((item) => item.id == id);
    if (index == -1) return false;

    final oldItem = _inMemoryItems[index];
    final updatedItem = TodoCheckListItemModel(
      id: oldItem.id,
      todoId: oldItem.todoId,
      title: title ?? oldItem.title,
      isCompleted: isCompleted ?? oldItem.isCompleted,
      order: order ?? oldItem.order,
      createdAt: oldItem.createdAt,
      updatedAt: DateTime.now(),
    );
    
    _inMemoryItems[index] = updatedItem;
    return true;
  }

  Future<bool> deleteCheckListItem(int id) async {
    final index = _inMemoryItems.indexWhere((item) => item.id == id);
    if (index == -1) return false;
    
    _inMemoryItems.removeAt(index);
    return true;
  }

  Future<bool> deleteAllCheckListItemsForTodo(int todoId) async {
    final initialCount = _inMemoryItems.length;
    _inMemoryItems.removeWhere((item) => item.todoId == todoId);
    return _inMemoryItems.length < initialCount;
  }

  Future<bool> toggleCheckListItemComplete(int id) async {
    final index = _inMemoryItems.indexWhere((item) => item.id == id);
    if (index == -1) return false;

    final oldItem = _inMemoryItems[index];
    final updatedItem = TodoCheckListItemModel(
      id: oldItem.id,
      todoId: oldItem.todoId,
      title: oldItem.title,
      isCompleted: !oldItem.isCompleted,
      order: oldItem.order,
      createdAt: oldItem.createdAt,
      updatedAt: DateTime.now(),
    );
    
    _inMemoryItems[index] = updatedItem;
    return true;
  }

  Future<bool> areAllCheckListItemsCompleted(int todoId) async {
    final items = await getCheckListItemsForTodo(todoId);
    if (items.isEmpty) return false; // No checklist items means not all completed
    return items.every((item) => item.isCompleted);
  }

  Future<void> reorderCheckListItems(int todoId, List<int> newOrder) async {
    for (int i = 0; i < newOrder.length; i++) {
      await updateCheckListItem(newOrder[i], order: i);
    }
  }
}