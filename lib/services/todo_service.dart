import 'package:drift/drift.dart';
import 'package:solo/enums/recurring_type.dart';
import 'package:solo/enums/timer_type.dart';
import 'package:solo/models/todo_model.dart';
import 'package:solo/models/todo_checklist_item_model.dart';
import 'package:solo/repositories/database/drift.dart';
import 'package:solo/repositories/database.dart';
import 'package:solo/services/todo_checklist_item_service.dart';

class TodoService {
  final TodoTableRepository _todoTableRepository = TodoTableRepository();

  // 仮想インスタンス用の定数
  static const int virtualInstanceIdMultiplier = -1;

  /// TodosCompanionを構築するヘルパーメソッド
  TodosCompanion _buildTodoCompanion({
    required String title,
    String? description,
    required DateTime dueDate,
    String? color,
    int? categoryId,
    bool? isRecurring,
    RecurringType? recurringType,
    int? parentTodoId,
    DateTime? recurringEndDate,
    TimerType? timerType,
    int? countupElapsedSeconds,
    int? pomodoroWorkMinutes,
    int? pomodoroShortBreakMinutes,
    int? pomodoroLongBreakMinutes,
    int? pomodoroCycle,
    int? pomodoroCompletedCycle,
    DateTime? now,
  }) {
    final timestamp = now ?? DateTime.now();
    return TodosCompanion(
      title: Value(title),
      description: Value(description),
      dueDate: Value(dueDate),
      isCompleted: const Value(false),
      color: Value(color ?? 'blue'),
      categoryId: Value(categoryId),
      createdAt: Value(timestamp),
      updatedAt: Value(timestamp),
      isRecurring: Value(isRecurring ?? false),
      parentTodoId:
          parentTodoId != null ? Value(parentTodoId) : const Value.absent(),
      recurringType: Value(recurringType?.value ?? RecurringType.daily.value),
      recurringEndDate: Value(recurringEndDate),
      timerType: Value(timerType?.name ?? TimerType.none.name),
      countupElapsedSeconds: Value(countupElapsedSeconds),
      pomodoroWorkMinutes: Value(pomodoroWorkMinutes),
      pomodoroShortBreakMinutes: Value(pomodoroShortBreakMinutes),
      pomodoroLongBreakMinutes: Value(pomodoroLongBreakMinutes),
      pomodoroCycle: Value(pomodoroCycle),
      pomodoroCompletedCycle: Value(pomodoroCompletedCycle),
    );
  }

  Future<List<TodoModel>> getTodo() async {
    final todos = await _todoTableRepository.findAll();
    return todos.map((todo) => TodoModel.fromTodo(todo)).toList();
  }

  /// テスト用: 繰り返しの親Todoを含むすべてのTodoを取得
  Future<List<TodoModel>> getTodoIncludingParents() async {
    final todos = await _todoTableRepository.findAllIncludingParents();
    return todos.map((todo) => TodoModel.fromTodo(todo)).toList();
  }

  Future<TodoModel> createTodo({
    required String title,
    String? description,
    required DateTime dueDate,
    String? color,
    int? categoryId,
    bool? isRecurring,
    RecurringType? recurringType,
    int? parentTodoId,
    DateTime? recurringEndDate,
    TimerType? timerType,
    int? countupElapsedSeconds,
    int? pomodoroWorkMinutes,
    int? pomodoroShortBreakMinutes,
    int? pomodoroLongBreakMinutes,
    int? pomodoroCycle,
    int? pomodoroCompletedCycle,
  }) async {
    final now = DateTime.now();
    final companion = _buildTodoCompanion(
      title: title,
      description: description,
      dueDate: dueDate,
      color: color,
      categoryId: categoryId,
      isRecurring: isRecurring,
      recurringType: recurringType,
      parentTodoId: parentTodoId,
      recurringEndDate: recurringEndDate,
      timerType: timerType,
      countupElapsedSeconds: countupElapsedSeconds,
      pomodoroWorkMinutes: pomodoroWorkMinutes,
      pomodoroShortBreakMinutes: pomodoroShortBreakMinutes,
      pomodoroLongBreakMinutes: pomodoroLongBreakMinutes,
      pomodoroCycle: pomodoroCycle,
      pomodoroCompletedCycle: pomodoroCompletedCycle,
      now: now,
    );
    final id = await _todoTableRepository.insert(companion);

    // 繰り返しTodoの場合、開始日の子Todoも作成
    if (isRecurring == true && parentTodoId == null) {
      final childCompanion = _buildTodoCompanion(
        title: title,
        description: description,
        dueDate: dueDate,
        color: color,
        categoryId: categoryId,
        isRecurring: true, // 子Todoは繰り返しではない
        recurringType: recurringType,
        parentTodoId: id, // 親TodoのIDを設定
        recurringEndDate: recurringEndDate,
        timerType: timerType,
        countupElapsedSeconds: countupElapsedSeconds,
        pomodoroWorkMinutes: pomodoroWorkMinutes,
        pomodoroShortBreakMinutes: pomodoroShortBreakMinutes,
        pomodoroLongBreakMinutes: pomodoroLongBreakMinutes,
        pomodoroCycle: pomodoroCycle,
        pomodoroCompletedCycle: pomodoroCompletedCycle,
        now: now,
      );
      await _todoTableRepository.insert(childCompanion);
    }

    return TodoModel(
      id: id,
      title: title,
      description: description,
      dueDate: dueDate,
      isCompleted: false,
      color: color ?? 'blue',
      categoryId: categoryId,
      createdAt: now,
      updatedAt: now,
      isRecurring: isRecurring ?? false,
      recurringType:
          RecurringType.fromString(recurringType?.name) ?? RecurringType.daily,
      recurringEndDate: recurringEndDate,
      timerType:
          TimerTypeExtension.fromString(timerType?.name ?? TimerType.none.name),
      pomodoroCompletedCycle: pomodoroCompletedCycle,
      countupElapsedSeconds: countupElapsedSeconds,
      pomodoroWorkMinutes: pomodoroWorkMinutes,
      pomodoroShortBreakMinutes: pomodoroShortBreakMinutes,
      pomodoroLongBreakMinutes: pomodoroLongBreakMinutes,
      pomodoroCycle: pomodoroCycle,
    );
  }

  Future<TodoModel?> updateTodo(int id,
      {String? title,
      String? description,
      DateTime? dueDate,
      String? color,
      int? categoryId,
      bool? isCompleted,
      bool? isRecurring,
      RecurringType? recurringType,
      DateTime? recurringEndDate,
      TimerType? timerType,
      int? countupElapsedSeconds,
      int? pomodoroWorkMinutes,
      int? pomodoroShortBreakMinutes,
      int? pomodoroLongBreakMinutes,
      int? pomodoroCycle,
      int? pomodoroCompletedCycle}) async {
    // 既存のTodoを取得して編集制限をチェック
    Todo? existingTodo;
    try {
      existingTodo = await _todoTableRepository.findById(id);
      if (existingTodo == null) {
        return null; // Todoが見つからない場合はnullを返す
      }
    } catch (e) {
      return null;
    }

    // 親TodoのIDを特定（編集対象が子Todoの場合は親ID、親Todoの場合は自身のID）
    int? parentTodoId = existingTodo.parentTodoId ??
        (existingTodo.isRecurring == true ? existingTodo.id : null);

    // 繰り返しTodoの編集制限をチェック（親Todoの場合のみ）
    if (existingTodo.isRecurring == true && existingTodo.parentTodoId == null) {
      if (isRecurring != null && isRecurring != existingTodo.isRecurring) {
        throw Exception('繰り返しTodoの編集時は繰り返し設定を変更できません');
      }
      if (recurringType != null &&
          recurringType.value != existingTodo.recurringType) {
        throw Exception('繰り返しTodoの編集時は繰り返しタイプを変更できません');
      }
      if (dueDate != null &&
          (dueDate.year != existingTodo.dueDate.year ||
              dueDate.month != existingTodo.dueDate.month ||
              dueDate.day != existingTodo.dueDate.day)) {
        throw Exception('繰り返しTodoの編集時は日付を変更できません');
      }
    }

    final now = DateTime.now();
    final companion = TodosCompanion(
      title: title != null ? Value(title) : const Value.absent(),
      description:
          description != null ? Value(description) : const Value.absent(),
      dueDate: dueDate != null ? Value(dueDate) : const Value.absent(),
      color: color != null ? Value(color) : const Value.absent(),
      categoryId: categoryId != null ? Value(categoryId) : const Value.absent(),
      isCompleted:
          isCompleted != null ? Value(isCompleted) : const Value.absent(),
      updatedAt: Value(now),
      isRecurring:
          isRecurring != null ? Value(isRecurring) : const Value.absent(),
      recurringType: recurringType != null
          ? Value(recurringType.value)
          : const Value.absent(),
      recurringEndDate: recurringEndDate != null
          ? Value(recurringEndDate)
          : const Value.absent(),
      timerType:
          timerType != null ? Value(timerType.name) : const Value.absent(),
      countupElapsedSeconds: countupElapsedSeconds != null
          ? Value(countupElapsedSeconds)
          : const Value.absent(),
      pomodoroWorkMinutes: pomodoroWorkMinutes != null
          ? Value(pomodoroWorkMinutes)
          : const Value.absent(),
      pomodoroShortBreakMinutes: pomodoroShortBreakMinutes != null
          ? Value(pomodoroShortBreakMinutes)
          : const Value.absent(),
      pomodoroLongBreakMinutes: pomodoroLongBreakMinutes != null
          ? Value(pomodoroLongBreakMinutes)
          : const Value.absent(),
      pomodoroCycle:
          pomodoroCycle != null ? Value(pomodoroCycle) : const Value.absent(),
      pomodoroCompletedCycle: pomodoroCompletedCycle != null
          ? Value(pomodoroCompletedCycle)
          : const Value.absent(),
    );

    // メインのTodoを更新
    final success = await _todoTableRepository.update(id, companion);
    if (!success) return null;

    // 繰り返しTodoの場合、親と子Todoの同期処理を行う
    if (parentTodoId != null) {
      final syncSuccess = await _synchronizeRecurringTodos(
          parentTodoId, companion, existingTodo, now);
      if (!syncSuccess) {
        // 同期に失敗した場合はログを出力（本来はロギングライブラリを使用）
        // 同期失敗してもメインの更新は成功しているのでnullは返さない
      }
    }
    Todo? todo;
    try {
      todo = await _todoTableRepository.findById(id);
      if (todo == null) {
        return null; // 更新後にTodoが見つからない場合はnullを返す
      }
    } catch (e) {
      return null;
    }
    return TodoModel.fromTodo(todo);
  }

  /// 繰り返しTodoの親と子を同期する内部メソッド（トランザクション安全）
  Future<bool> _synchronizeRecurringTodos(int parentTodoId,
      TodosCompanion companion, Todo originalTodo, DateTime now) async {
    try {
      // 最適化：親IDに関連するTodoのみを取得
      final relatedTodos =
          await _todoTableRepository.findByParentTodoId(parentTodoId);

      if (relatedTodos.isEmpty) {
        return false; // 関連するTodoが見つからない場合
      }

      final updates = <MapEntry<int, TodosCompanion>>[];

      // 編集対象が子Todoの場合、親Todoの更新を準備
      if (originalTodo.parentTodoId != null) {
        final parentUpdateCompanion = _buildSyncCompanion(companion, now);
        updates.add(MapEntry(parentTodoId, parentUpdateCompanion));
      }

      // すべての子Todoの更新を準備
      final childTodos = relatedTodos
          .where((t) =>
              t.parentTodoId == parentTodoId &&
              t.id != parentTodoId &&
              t.id != originalTodo.id)
          .toList();

      for (final childTodo in childTodos) {
        final childUpdateCompanion = _buildSyncCompanion(companion, now);
        updates.add(MapEntry(childTodo.id, childUpdateCompanion));
      }

      // トランザクション内で一括更新
      return await _todoTableRepository.updateMultipleInTransaction(updates);
    } catch (e) {
      // エラーログ記録
      return false;
    }
  }

  /// 同期用のTodosCompanionを構築するヘルパーメソッド（重複コードのリファクタリング）
  TodosCompanion _buildSyncCompanion(TodosCompanion source, DateTime now) {
    return TodosCompanion(
      title: source.title.present ? source.title : const Value.absent(),
      description: source.description.present
          ? source.description
          : const Value.absent(),
      color: source.color.present ? source.color : const Value.absent(),
      categoryId:
          source.categoryId.present ? source.categoryId : const Value.absent(),
      updatedAt: Value(now),
      timerType:
          source.timerType.present ? source.timerType : const Value.absent(),
      countupElapsedSeconds: source.countupElapsedSeconds.present
          ? source.countupElapsedSeconds
          : const Value.absent(),
      pomodoroWorkMinutes: source.pomodoroWorkMinutes.present
          ? source.pomodoroWorkMinutes
          : const Value.absent(),
      pomodoroShortBreakMinutes: source.pomodoroShortBreakMinutes.present
          ? source.pomodoroShortBreakMinutes
          : const Value.absent(),
      pomodoroLongBreakMinutes: source.pomodoroLongBreakMinutes.present
          ? source.pomodoroLongBreakMinutes
          : const Value.absent(),
      pomodoroCycle: source.pomodoroCycle.present
          ? source.pomodoroCycle
          : const Value.absent(),
      pomodoroCompletedCycle: source.pomodoroCompletedCycle.present
          ? source.pomodoroCompletedCycle
          : const Value.absent(),
    );
  }

  Future<bool> deleteTodo(int id, {DateTime? date}) async {
    // 仮想インスタンス（負のID）の場合
    if (id < 0) {
      return await deleteVirtualInstance(id, date ?? DateTime.now());
    }
    // 通常のTodoの場合は論理削除
    return await _todoTableRepository.softDelete(id);
  }

  /// 仮想インスタンス（負のID）を削除する場合、論理削除として記録
  Future<bool> deleteVirtualInstance(int virtualId, DateTime date) async {
    // 仮想インスタンスの場合（負のID）、親IDを抽出
    final parentTodoId = virtualInstanceIdMultiplier * virtualId;

    // 親Todoの情報を取得
    final parentTodo = await _todoTableRepository.findById(parentTodoId);
    if (parentTodo == null) {
      return false; // 親Todoが見つからない場合は削除できない
    }

    // 日付のみにする（時刻を除去）
    final dateOnly = DateTime(date.year, date.month, date.day);

    // その特定日に対応する削除済みTodoレコードを作成
    final now = DateTime.now();
    final companion = TodosCompanion(
      title: Value(parentTodo.title),
      description: Value(parentTodo.description),
      dueDate: Value(DateTime(
        dateOnly.year,
        dateOnly.month,
        dateOnly.day,
        parentTodo.dueDate.hour,
        parentTodo.dueDate.minute,
      )),
      isCompleted: const Value(false),
      isDeleted: const Value(true), // 論理削除フラグを設定
      color: Value(parentTodo.color),
      icon: Value(parentTodo.icon),
      categoryId: Value(parentTodo.categoryId),
      createdAt: Value(now),
      updatedAt: Value(now),
      isRecurring: Value(parentTodo.isRecurring),
      recurringType: Value(parentTodo.recurringType),
      recurringEndDate: Value(parentTodo.recurringEndDate),
      parentTodoId: Value(parentTodoId),
      timerType: Value(parentTodo.timerType),
      countupElapsedSeconds: Value(parentTodo.countupElapsedSeconds),
      pomodoroWorkMinutes: Value(parentTodo.pomodoroWorkMinutes),
      pomodoroShortBreakMinutes: Value(parentTodo.pomodoroShortBreakMinutes),
      pomodoroLongBreakMinutes: Value(parentTodo.pomodoroLongBreakMinutes),
      pomodoroCycle: Value(parentTodo.pomodoroCycle),
      pomodoroCompletedCycle: Value(parentTodo.pomodoroCompletedCycle),
    );

    await _todoTableRepository.insert(companion);
    return true;
  }

  /// 繰り返しTodoとその関連する全てのTodoを物理削除する
  Future<bool> deleteAllRecurringTodos(int todoId) async {
    try {
      // 削除するTodoを取得
      final targetTodo = await _todoTableRepository.findById(todoId);
      if (targetTodo == null) {
        return false; // Todoが見つからない場合は削除できない
      }

      if (targetTodo.isRecurring) {
        // 親Todoの場合（parentTodoIdがnull）
        if (targetTodo.parentTodoId == null) {
          // トランザクション内で親と子Todoを一括削除
          return await _todoTableRepository
              .physicalDeleteRecurringTodoWithChildren(todoId);
        } else {
          // 子Todoの場合、親IDを取得してその親と全ての子を削除
          final parentTodoId = targetTodo.parentTodoId!;
          return await _todoTableRepository
              .physicalDeleteRecurringTodoWithChildren(parentTodoId);
        }
      } else {
        // 繰り返しTodoではない場合は通常の削除
        return await _todoTableRepository.physicalDelete(todoId);
      }
    } catch (e) {
      return false;
    }
  }

  Future<TodoModel?> updateTodoPomodoroSettings(
    int todoId, {
    required int workMinutes,
    required int shortBreakMinutes,
    required int longBreakMinutes,
    required int cycle,
  }) async {
    return await updateTodo(
      todoId,
      timerType: TimerType.pomodoro, // ポモドーロタイマータイプを明示的に設定
      pomodoroWorkMinutes: workMinutes,
      pomodoroShortBreakMinutes: shortBreakMinutes,
      pomodoroLongBreakMinutes: longBreakMinutes,
      pomodoroCycle: cycle,
    );
  }

  Future<TodoModel?> toggleTodoComplete(int id) async {
    final todo = await _todoTableRepository.findById(id);
    if (todo == null) {
      return null;
    }
    final companion = TodosCompanion(
      isCompleted: Value(!todo.isCompleted),
      updatedAt: Value(DateTime.now()),
    );
    final success = await _todoTableRepository.update(id, companion);
    if (!success) return null;
    final updatedTodo = await _todoTableRepository.findById(id);
    if (updatedTodo == null) {
      return null;
    }
    return TodoModel.fromTodo(updatedTodo);
  }

  Future<TodoModel?> completeTodoById(int id) async {
    final companion = TodosCompanion(
      isCompleted: const Value(true),
      updatedAt: Value(DateTime.now()),
    );
    final success = await _todoTableRepository.update(id, companion);
    if (!success) return null;
    final updatedTodo = await _todoTableRepository.findById(id);
    if (updatedTodo == null) {
      return null;
    }
    return TodoModel.fromTodo(updatedTodo);
  }

  Future<bool> checkAndUpdateTodoCompletionByChecklist(int todoId) async {
    final checklistService = TodoCheckListItemService();
    final allItemsCompleted =
        await checklistService.areAllCheckListItemsCompleted(todoId);
    if (allItemsCompleted) {
      final todo = await _todoTableRepository.findById(todoId);
      if (todo == null) {
        return false;
      }
      if (!todo.isCompleted) {
        final companion = TodosCompanion(
          isCompleted: const Value(true),
          updatedAt: Value(DateTime.now()),
        );
        final success = await _todoTableRepository.update(todoId, companion);
        return success;
      }
    }
    return false;
  }

  Future<List<TodoModel>> getTodayTodos() async {
    final today = DateTime.now();
    final todos = await _todoTableRepository.findByDate(today);
    return todos.map((todo) => TodoModel.fromTodo(todo)).toList();
  }

  Future<List<TodoModel>> getTodosForDate(DateTime date) async {
    final todos = await _todoTableRepository.findByDate(date);
    final allTodos = await _todoTableRepository.findAll();
    // 親Todo（isRecurring=trueかつparentTodoId=null）を除外
    final List<TodoModel> result = todos
        .where(
            (todo) => !(todo.isRecurring == true && todo.parentTodoId == null))
        .map((todo) => TodoModel.fromTodo(todo))
        .toList();

    // その日の削除レコードを取得
    final endOfDay = date.add(const Duration(days: 1));
    final deletedRecords = await _getDeletedRecordsForPeriod(date, endOfDay);

    // 繰り返しTodoの仮想インスタンスも追加
    for (final todo in allTodos) {
      if (todo.isRecurring == true &&
          todo.recurringType != null &&
          todo.parentTodoId == null) {
        if (_isRecurringOnDayWithDeletedCheck(
            TodoModel.fromTodo(todo), date, deletedRecords)) {
          // 既に通常Todoとして存在しない場合のみ追加
          final exists = result.any((t) =>
              t.parentTodoId == todo.id &&
              t.dueDate.year == date.year &&
              t.dueDate.month == date.month &&
              t.dueDate.day == date.day);

          if (!exists) {
            result.add(TodoModel.fromTodo(todo).copyWith(
                id: virtualInstanceIdMultiplier * todo.id, // 仮想インスタンスは負のIDで区別
                dueDate: DateTime(date.year, date.month, date.day,
                    todo.dueDate.hour, todo.dueDate.minute),
                parentTodoId: todo.id, // 親TodoのIDを設定
                isCompleted: false));
          }
        }
      }
    }
    return result;
  }

  Future<Map<DateTime, List<TodoModel>>> getTodosForMonth(
      DateTime month) async {
    final todos = await _todoTableRepository.findAll();
    final checklistService = TodoCheckListItemService();
    final Map<DateTime, List<TodoModel>> todosByDate = {};
    final List<TodoModel> recurringTodos = [];
    final List<TodoModel> normalTodos = [];
    final firstDay = DateTime(month.year, month.month, 1);
    final lastDay = DateTime(month.year, month.month + 1, 0);

    // 削除されたレコードを一括取得（月内の期間）
    final deletedRecords = await _getDeletedRecordsForPeriod(firstDay, lastDay);
    // すべてのTodoのIDリストを作成
    final todoIds = todos.map((t) => t.id).toList();
    // 一括でチェックリストを取得
    final allChecklistItems =
        await checklistService.getCheckListItemsForTodoIds(todoIds);
    // todoIdごとにグループ化
    final Map<int, List<TodoCheckListItemModel>> checklistMap = {};
    for (final item in allChecklistItems) {
      checklistMap[item.todoId] = checklistMap[item.todoId] ?? [];
      checklistMap[item.todoId]!.add(item);
    }
    for (final todo in todos) {
      if (todo.isRecurring == true &&
          todo.recurringType != null &&
          todo.parentTodoId == null) {
        // 親Todo（繰り返し設定）の開始日がその月以前の場合を対象
        if (!todo.dueDate.isAfter(lastDay)) {
          recurringTodos.add(TodoModel.fromTodo(todo).copyWith(
            checklistItem: checklistMap[todo.id] ?? [],
          ));
        }
      } else if (!(todo.isRecurring == true && todo.parentTodoId == null)) {
        // 親Todo以外（通常TodoまたはparentTodoIdが設定された子Todo）はその月の日付のみ
        if (todo.dueDate.year == month.year &&
            todo.dueDate.month == month.month) {
          normalTodos.add(TodoModel.fromTodo(todo).copyWith(
            checklistItem: checklistMap[todo.id] ?? [],
          ));
        }
      }
    }
    // 通常Todoを日付ごとに追加
    for (final todo in normalTodos) {
      final dateKey =
          DateTime(todo.dueDate.year, todo.dueDate.month, todo.dueDate.day);
      todosByDate[dateKey] = todosByDate[dateKey] ?? [];
      todosByDate[dateKey]!.add(todo);
    }
    // 繰り返しTodoを月内の日付ごとに仮想インスタンス生成
    for (final todo in recurringTodos) {
      for (DateTime day = firstDay;
          !day.isAfter(lastDay);
          day = day.add(const Duration(days: 1))) {
        // すでにparentIdが親Todoのidと等しく日付が同じTodoがある場合はスキップ
        final exists = todosByDate[DateTime(day.year, day.month, day.day)]?.any(
              (t) =>
                  t.parentTodoId == todo.id &&
                  t.dueDate.year == day.year &&
                  t.dueDate.month == day.month &&
                  t.dueDate.day == day.day,
            ) ??
            false;

        if (_isRecurringOnDayWithDeletedCheck(todo, day, deletedRecords) &&
            !exists) {
          final instance = todo.copyWith(
            id: virtualInstanceIdMultiplier * todo.id, // 仮想インスタンスは負のIDで区別
            dueDate: DateTime(day.year, day.month, day.day, todo.dueDate.hour,
                todo.dueDate.minute),
            isCompleted: false, // 仮想インスタンスは未完了扱い
            parentTodoId: todo.id, // 親TodoのIDを設定
            checklistItem: checklistMap[todo.id] ?? [], // 親Todoのチェックリストをコピー
          );
          final dateKey = DateTime(day.year, day.month, day.day);
          todosByDate[dateKey] = todosByDate[dateKey] ?? [];
          todosByDate[dateKey]!.add(instance);
        }
      }
    }
    return todosByDate;
  }

  // メモリ内削除チェック版の_isRecurringOnDay
  bool _isRecurringOnDayWithDeletedCheck(
      TodoModel todo, DateTime day, Map<String, Set<DateTime>> deletedRecords) {
    if (todo.isRecurring != true) return false;
    if (todo.recurringEndDate != null && day.isAfter(todo.recurringEndDate!)) {
      return false;
    }

    // 削除された日付かチェック（メモリ内）
    final isDeleted = _isDateDeletedInMemory(todo.id, day, deletedRecords);
    if (isDeleted) return false;

    // 日付のみで比較するため、時刻を0:00:00にする
    final dayOnly = DateTime(day.year, day.month, day.day);
    final dueDateOnly =
        DateTime(todo.dueDate.year, todo.dueDate.month, todo.dueDate.day);

    switch (todo.recurringType) {
      case RecurringType.daily:
        return !dayOnly.isBefore(dueDateOnly);
      case RecurringType.weekly:
        return !dayOnly.isBefore(dueDateOnly) &&
            day.weekday == todo.dueDate.weekday;
      case RecurringType.monthly:
        return !dayOnly.isBefore(dueDateOnly) && day.day == todo.dueDate.day;
      case RecurringType.monthlyLast:
        final lastDay = DateTime(day.year, day.month + 1, 0).day;
        return !dayOnly.isBefore(dueDateOnly) && day.day == lastDay;
    }
  }

  /// 指定期間内の削除されたレコードを一括取得
  Future<Map<String, Set<DateTime>>> _getDeletedRecordsForPeriod(
      DateTime start, DateTime end) async {
    final deletedTodos =
        await _todoTableRepository.findDeletedTodosForPeriod(start, end);

    final Map<String, Set<DateTime>> deletedDates = {};
    for (final todo in deletedTodos) {
      final parentId = todo.parentTodoId!;
      final dateOnly =
          DateTime(todo.dueDate.year, todo.dueDate.month, todo.dueDate.day);
      final key = parentId.toString();
      deletedDates[key] = deletedDates[key] ?? <DateTime>{};
      deletedDates[key]!.add(dateOnly);
    }

    return deletedDates;
  }

  /// メモリ内で削除チェックを行う（効率化版）
  bool _isDateDeletedInMemory(int parentTodoId, DateTime date,
      Map<String, Set<DateTime>> deletedRecords) {
    final key = parentTodoId.toString();
    final dateOnly = DateTime(date.year, date.month, date.day);
    return deletedRecords[key]?.contains(dateOnly) ?? false;
  }

  /// 繰り返しTodoの次の日付を計算（プライベートメソッド）
  DateTime? _calculateNextRecurringDate(TodoModel todo) {
    if (todo.isRecurring != true) {
      return null;
    }

    final currentDate = todo.dueDate;
    final recurringType = todo.recurringType;

    switch (recurringType) {
      case RecurringType.daily:
        return DateTime(
          currentDate.year,
          currentDate.month,
          currentDate.day + 1,
          currentDate.hour,
          currentDate.minute,
        );

      case RecurringType.weekly:
        return DateTime(
          currentDate.year,
          currentDate.month,
          currentDate.day + 7,
          currentDate.hour,
          currentDate.minute,
        );

      case RecurringType.monthly:
        final nextMonth = currentDate.month == 12
            ? DateTime(currentDate.year + 1, 1, 1)
            : DateTime(currentDate.year, currentDate.month + 1, 1);
        final targetDay = currentDate.day;
        final lastDayOfMonth =
            DateTime(nextMonth.year, nextMonth.month + 1, 0).day;
        final actualDay =
            targetDay > lastDayOfMonth ? lastDayOfMonth : targetDay;

        return DateTime(
          nextMonth.year,
          nextMonth.month,
          actualDay,
          currentDate.hour,
          currentDate.minute,
        );

      case RecurringType.monthlyLast:
        final nextMonth = currentDate.month == 12
            ? DateTime(currentDate.year + 1, 1, 1)
            : DateTime(currentDate.year, currentDate.month + 1, 1);
        final lastDayOfNextMonth =
            DateTime(nextMonth.year, nextMonth.month + 1, 0).day;

        return DateTime(
          nextMonth.year,
          nextMonth.month,
          lastDayOfNextMonth,
          currentDate.hour,
          currentDate.minute,
        );
    }
  }

  /// Generate the next instance of a recurring todo
  Future<TodoModel?> generateNextRecurringInstance(
      TodoModel originalTodo) async {
    if (originalTodo.isRecurring != true) return null;

    final nextDate = _calculateNextRecurringDate(originalTodo);
    if (nextDate == null) return null;

    // Check if we've passed the end date
    if (originalTodo.recurringEndDate != null &&
        nextDate.isAfter(originalTodo.recurringEndDate!)) {
      return null;
    }

    final now = DateTime.now();
    final companion = TodosCompanion(
      title: Value(originalTodo.title),
      description: Value(originalTodo.description),
      dueDate: Value(nextDate),
      isCompleted: const Value(false),
      color: Value(originalTodo.color),
      icon: Value(originalTodo.icon),
      categoryId: Value(originalTodo.categoryId),
      createdAt: Value(now),
      updatedAt: Value(now),
      isRecurring: Value(originalTodo.isRecurring ?? false),
      recurringType: Value(
        (originalTodo.recurringType is String)
            ? originalTodo.recurringType as String
            : (originalTodo.recurringType).value,
      ),
      parentTodoId: Value(originalTodo.id), // 親TodoのIDを設定
      recurringEndDate: Value(originalTodo.recurringEndDate),
      timerType: Value(originalTodo.timerType.name),
      countupElapsedSeconds: Value(originalTodo.countupElapsedSeconds),
      pomodoroWorkMinutes: Value(originalTodo.pomodoroWorkMinutes),
      pomodoroShortBreakMinutes: Value(originalTodo.pomodoroShortBreakMinutes),
      pomodoroLongBreakMinutes: Value(originalTodo.pomodoroLongBreakMinutes),
      pomodoroCycle: Value(originalTodo.pomodoroCycle),
      pomodoroCompletedCycle: Value(originalTodo.pomodoroCompletedCycle),
    );
    final id = await _todoTableRepository.insert(companion);

    return originalTodo.copyWith(
      id: id,
      dueDate: nextDate,
      createdAt: now,
      updatedAt: now,
      isCompleted: false,
    );
  }
}
