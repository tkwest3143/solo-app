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

  Future<List<TodoModel>> getTodo() async {
    final todos = await _todoTableRepository.findAll();
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
    final companion = TodosCompanion(
        title: Value(title),
        description: Value(description),
        dueDate: Value(dueDate),
        isCompleted: const Value(false),
        color: Value(color ?? 'blue'),
        categoryId: Value(categoryId),
        createdAt: Value(now),
        updatedAt: Value(now),
        isRecurring: Value(isRecurring ?? false),
        recurringType: Value(recurringType?.value ?? RecurringType.daily.value),
        recurringEndDate: Value(recurringEndDate),
        timerType: Value(timerType?.name ?? TimerType.none.name),
        countupElapsedSeconds: Value(countupElapsedSeconds),
        pomodoroWorkMinutes: Value(pomodoroWorkMinutes),
        pomodoroShortBreakMinutes: Value(pomodoroShortBreakMinutes),
        pomodoroLongBreakMinutes: Value(pomodoroLongBreakMinutes),
        pomodoroCycle: Value(pomodoroCycle),
        pomodoroCompletedCycle: Value(pomodoroCompletedCycle));
    final id = await _todoTableRepository.insert(companion);
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
    final success = await _todoTableRepository.update(id, companion);
    if (!success) return null;
    final todos = await _todoTableRepository.findAll();
    Todo? todo;
    try {
      todo = todos.firstWhere((t) => t.id == id);
    } catch (e) {
      return null;
    }
    return TodoModel.fromTodo(todo);
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
    final parentTodoId = -virtualId;
    
    // 親Todoの情報を取得
    final todos = await _todoTableRepository.findAll();
    final parentTodo = todos.firstWhere((t) => t.id == parentTodoId);
    
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
    final todos = await _todoTableRepository.findAll();
    Todo? todo;
    try {
      todo = todos.firstWhere((t) => t.id == id);
    } catch (e) {
      return null;
    }
    final companion = TodosCompanion(
      isCompleted: Value(!todo.isCompleted),
      updatedAt: Value(DateTime.now()),
    );
    final success = await _todoTableRepository.update(id, companion);
    if (!success) return null;
    final updatedTodos = await _todoTableRepository.findAll();
    Todo? updatedTodo;
    try {
      updatedTodo = updatedTodos.firstWhere((t) => t.id == id);
    } catch (e) {
      return null;
    }
    return TodoModel.fromTodo(updatedTodo);
  }

  Future<TodoModel?> completeTodoById(int id) async {
    final todos = await _todoTableRepository.findAll();
    try {
      todos.firstWhere((t) => t.id == id);
    } catch (e) {
      return null;
    }
    final companion = TodosCompanion(
      isCompleted: const Value(true),
      updatedAt: Value(DateTime.now()),
    );
    final success = await _todoTableRepository.update(id, companion);
    if (!success) return null;
    final updatedTodos = await _todoTableRepository.findAll();
    Todo? updatedTodo;
    try {
      updatedTodo = updatedTodos.firstWhere((t) => t.id == id);
    } catch (e) {
      return null;
    }
    return TodoModel.fromTodo(updatedTodo);
  }


  Future<bool> checkAndUpdateTodoCompletionByChecklist(int todoId) async {
    final checklistService = TodoCheckListItemService();
    final allItemsCompleted =
        await checklistService.areAllCheckListItemsCompleted(todoId);
    if (allItemsCompleted) {
      final todos = await _todoTableRepository.findAll();
      Todo? todo;
      try {
        todo = todos.firstWhere((t) => t.id == todoId);
      } catch (e) {
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
    final List<TodoModel> result =
        todos.map((todo) => TodoModel.fromTodo(todo)).toList();
    
    // その日の削除レコードを取得
    final endOfDay = date.add(const Duration(days: 1));
    final deletedRecords = await _getDeletedRecordsForPeriod(date, endOfDay);
    
    // 繰り返しTodoの仮想インスタンスも追加
    for (final todo in allTodos) {
      if (todo.isRecurring == true && todo.recurringType != null) {
        if (_isRecurringOnDayWithDeletedCheck(TodoModel.fromTodo(todo), date, deletedRecords)) {
          // 既に通常Todoとして存在しない場合のみ追加
          final exists = result.any((t) =>
              t.title == todo.title &&
              t.dueDate.year == date.year &&
              t.dueDate.month == date.month &&
              t.dueDate.day == date.day);
          
          if (!exists) {
            result.add(TodoModel.fromTodo(todo).copyWith(
                id: -todo.id, // 仮想インスタンスは負のIDで区別
                dueDate: DateTime(date.year, date.month, date.day,
                    todo.dueDate.hour, todo.dueDate.minute),
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
      if (todo.isRecurring == true && todo.recurringType != null) {
        // 開始日がその月以前の繰り返しTodoを対象
        if (!todo.dueDate.isAfter(lastDay)) {
          recurringTodos.add(TodoModel.fromTodo(todo).copyWith(
            checklistItem: checklistMap[todo.id] ?? [],
          ));
        }
      } else {
        // 通常Todoはその月の日付のみ
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
        if (_isRecurringOnDayWithDeletedCheck(todo, day, deletedRecords)) {
          final instance = todo.copyWith(
            id: -todo.id, // 仮想インスタンスは負のIDで区別
            dueDate: DateTime(day.year, day.month, day.day, todo.dueDate.hour,
                todo.dueDate.minute),
            isCompleted: false, // 仮想インスタンスは未完了扱い

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

  // 指定日が繰り返しTodoの該当日か判定（削除された日付もチェック）
  Future<bool> _isRecurringOnDay(TodoModel todo, DateTime day) async {
    if (todo.isRecurring != true) return false;
    if (todo.recurringEndDate != null && day.isAfter(todo.recurringEndDate!)) {
      return false;
    }
    
    // 削除された日付かチェック
    final isDeleted = await _isDateDeleted(todo.id, day);
    if (isDeleted) return false;
    
    // 日付のみで比較するため、時刻を0:00:00にする
    final dayOnly = DateTime(day.year, day.month, day.day);
    final dueDateOnly = DateTime(todo.dueDate.year, todo.dueDate.month, todo.dueDate.day);
    
    switch (todo.recurringType) {
      case RecurringType.daily:
        return !dayOnly.isBefore(dueDateOnly);
      case RecurringType.weekly:
        return !dayOnly.isBefore(dueDateOnly) &&
            day.weekday == todo.dueDate.weekday;
      case RecurringType.monthly:
        return !dayOnly.isBefore(dueDateOnly) &&
            day.day == todo.dueDate.day;
      case RecurringType.monthlyLast:
        final lastDay = DateTime(day.year, day.month + 1, 0).day;
        return !dayOnly.isBefore(dueDateOnly) && day.day == lastDay;
    }
  }

  // メモリ内削除チェック版の_isRecurringOnDay
  bool _isRecurringOnDayWithDeletedCheck(TodoModel todo, DateTime day, Map<String, Set<DateTime>> deletedRecords) {
    if (todo.isRecurring != true) return false;
    if (todo.recurringEndDate != null && day.isAfter(todo.recurringEndDate!)) {
      return false;
    }
    
    // 削除された日付かチェック（メモリ内）
    final isDeleted = _isDateDeletedInMemory(todo.id, day, deletedRecords);
    if (isDeleted) return false;
    
    // 日付のみで比較するため、時刻を0:00:00にする
    final dayOnly = DateTime(day.year, day.month, day.day);
    final dueDateOnly = DateTime(todo.dueDate.year, todo.dueDate.month, todo.dueDate.day);
    
    switch (todo.recurringType) {
      case RecurringType.daily:
        return !dayOnly.isBefore(dueDateOnly);
      case RecurringType.weekly:
        return !dayOnly.isBefore(dueDateOnly) &&
            day.weekday == todo.dueDate.weekday;
      case RecurringType.monthly:
        return !dayOnly.isBefore(dueDateOnly) &&
            day.day == todo.dueDate.day;
      case RecurringType.monthlyLast:
        final lastDay = DateTime(day.year, day.month + 1, 0).day;
        return !dayOnly.isBefore(dueDateOnly) && day.day == lastDay;
    }
  }

  /// 指定された親TodoIDと日付で削除済みレコードが存在するかチェック
  Future<bool> _isDateDeleted(int parentTodoId, DateTime date) async {
    return await _todoTableRepository.isDateDeleted(parentTodoId, date);
  }

  /// 指定期間内の削除されたレコードを一括取得
  Future<Map<String, Set<DateTime>>> _getDeletedRecordsForPeriod(DateTime start, DateTime end) async {
    final deletedTodos = await _todoTableRepository.findDeletedTodosForPeriod(start, end);
    
    final Map<String, Set<DateTime>> deletedDates = {};
    for (final todo in deletedTodos) {
      final parentId = todo.parentTodoId!;
      final dateOnly = DateTime(todo.dueDate.year, todo.dueDate.month, todo.dueDate.day);
      final key = parentId.toString();
      deletedDates[key] = deletedDates[key] ?? <DateTime>{};
      deletedDates[key]!.add(dateOnly);
    }
    
    return deletedDates;
  }

  /// メモリ内で削除チェックを行う（効率化版）
  bool _isDateDeletedInMemory(int parentTodoId, DateTime date, Map<String, Set<DateTime>> deletedRecords) {
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


  /// 繰り返しTodoから指定日に最も近い未来の日付を算出
  Future<DateTime?> getNextRecurringDateFromToday(
      TodoModel recurringTodo, DateTime today) async {
    if (recurringTodo.isRecurring != true) return null;

    // 今日以降の最初の繰り返し日を見つける
    DateTime currentCheck = today;

    // 最大90日先まで検索（無限ループを防ぐ）
    for (int i = 0; i < 90; i++) {
      if (await _isRecurringOnDay(recurringTodo, currentCheck)) {
        // 繰り返し終了日をチェック
        if (recurringTodo.recurringEndDate != null &&
            currentCheck.isAfter(recurringTodo.recurringEndDate!)) {
          return null;
        }

        // 元のdue dateよりも前の日付はスキップ（日付のみで比較）
        final currentCheckDateOnly = DateTime(currentCheck.year, currentCheck.month, currentCheck.day);
        final dueDateOnly = DateTime(recurringTodo.dueDate.year, recurringTodo.dueDate.month, recurringTodo.dueDate.day);
        if (currentCheckDateOnly.isBefore(dueDateOnly)) {
          currentCheck = currentCheck.add(const Duration(days: 1));
          continue;
        }

        // 今日以降の最初の該当日を返す（日付のみで比較）
        final todayDateOnly = DateTime(today.year, today.month, today.day);
        if (!currentCheckDateOnly.isBefore(todayDateOnly)) {
          return DateTime(
            currentCheck.year,
            currentCheck.month,
            currentCheck.day,
            recurringTodo.dueDate.hour,
            recurringTodo.dueDate.minute,
          );
        }
      }
      currentCheck = currentCheck.add(const Duration(days: 1));
    }

    return null;
  }


  /// 繰り返しTodoの新しいインスタンスを作成
  Future<TodoModel> createRecurringInstance(
      TodoModel parentTodo, DateTime targetDate) async {
    final now = DateTime.now();
    final companion = TodosCompanion(
      title: Value(parentTodo.title),
      description: Value(parentTodo.description),
      dueDate: Value(DateTime(
        targetDate.year,
        targetDate.month,
        targetDate.day,
        parentTodo.dueDate.hour,
        parentTodo.dueDate.minute,
      )),
      isCompleted: const Value(false),
      color: Value(parentTodo.color),
      icon: Value(parentTodo.icon),
      categoryId: Value(parentTodo.categoryId),
      createdAt: Value(now),
      updatedAt: Value(now),
      isRecurring: Value(parentTodo.isRecurring ?? false),
      recurringType: Value(parentTodo.recurringType.value),
      recurringEndDate: Value(parentTodo.recurringEndDate),
      parentTodoId: Value(parentTodo.id),
      timerType: Value(parentTodo.timerType.name),
      countupElapsedSeconds: Value(parentTodo.countupElapsedSeconds),
      pomodoroWorkMinutes: Value(parentTodo.pomodoroWorkMinutes),
      pomodoroShortBreakMinutes: Value(parentTodo.pomodoroShortBreakMinutes),
      pomodoroLongBreakMinutes: Value(parentTodo.pomodoroLongBreakMinutes),
      pomodoroCycle: Value(parentTodo.pomodoroCycle),
      pomodoroCompletedCycle: Value(parentTodo.pomodoroCompletedCycle),
    );

    final id = await _todoTableRepository.insert(companion);

    return parentTodo.copyWith(
      id: id,
      dueDate: DateTime(
        targetDate.year,
        targetDate.month,
        targetDate.day,
        parentTodo.dueDate.hour,
        parentTodo.dueDate.minute,
      ),
      createdAt: now,
      updatedAt: now,
      isCompleted: false,
      parentTodoId: parentTodo.id, // 親TodoのIDを設定
    );
  }

}
