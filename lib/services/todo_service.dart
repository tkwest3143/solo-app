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
    int? recurringDayOfWeek,
    int? recurringDayOfMonth,
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
        recurringType: Value(recurringType?.name ?? RecurringType.daily.name),
        recurringEndDate: Value(recurringEndDate),
        recurringDayOfWeek: Value(recurringDayOfWeek),
        recurringDayOfMonth: Value(recurringDayOfMonth),
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
      recurringType: RecurringType.fromString(
              recurringType?.name ?? RecurringType.daily.name) ??
          RecurringType.daily,
      recurringEndDate: recurringEndDate,
      recurringDayOfWeek: recurringDayOfWeek,
      recurringDayOfMonth: recurringDayOfMonth,
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
      int? recurringDayOfWeek,
      int? recurringDayOfMonth,
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
      recurringDayOfWeek: recurringDayOfWeek != null
          ? Value(recurringDayOfWeek)
          : const Value.absent(),
      recurringDayOfMonth: recurringDayOfMonth != null
          ? Value(recurringDayOfMonth)
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

  Future<bool> deleteTodo(int id) async {
    return await _todoTableRepository.delete(id);
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

  Future<List<TodoModel>> getTodosForTimer() async {
    final todos = await _todoTableRepository.findAll();
    return todos
        .where((todo) => 
            !todo.isCompleted && 
            (todo.timerType == TimerType.pomodoro.name || 
             todo.timerType == TimerType.countup.name))
        .map((todo) => TodoModel.fromTodo(todo))
        .toList();
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

  Future<List<TodoModel>> getUpcomingTodos() async {
    final today = DateTime.now();
    final weekFromNow = today.add(const Duration(days: 7));
    final todos = await _todoTableRepository.findUpcoming(today, weekFromNow);
    return todos
        .where((todo) {
          final todoDate = todo.dueDate;
          final isToday = todoDate.year == today.year &&
              todoDate.month == today.month &&
              todoDate.day == today.day;
          return !isToday;
        })
        .map((todo) => TodoModel.fromTodo(todo))
        .toList();
  }

  Future<List<TodoModel>> getFilteredTodos({
    bool? isCompleted,
    int? categoryId,
  }) async {
    final todos = await _todoTableRepository.findFiltered(
      isCompleted: isCompleted,
      categoryId: categoryId,
    );
    return todos.map((todo) => TodoModel.fromTodo(todo)).toList();
  }

  Future<List<TodoModel>> getTodosForDate(DateTime date) async {
    final todos = await _todoTableRepository.findByDate(date);
    final allTodos = await _todoTableRepository.findAll();
    final List<TodoModel> result =
        todos.map((todo) => TodoModel.fromTodo(todo)).toList();
    // 繰り返しTodoの仮想インスタンスも追加
    for (final todo in allTodos) {
      if (todo.isRecurring == true && todo.recurringType != null) {
        if (_isRecurringOnDay(TodoModel.fromTodo(todo), date)) {
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
        if (_isRecurringOnDay(todo, day)) {
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

  // 指定日が繰り返しTodoの該当日か判定
  bool _isRecurringOnDay(TodoModel todo, DateTime day) {
    if (todo.isRecurring != true) return false;
    if (todo.recurringEndDate != null && day.isAfter(todo.recurringEndDate!)) {
      return false;
    }
    switch (todo.recurringType) {
      case RecurringType.daily:
        return !day.isBefore(todo.dueDate);
      case RecurringType.weekly:
        return !day.isBefore(todo.dueDate) &&
            day.weekday == (todo.recurringDayOfWeek ?? todo.dueDate.weekday);
      case RecurringType.monthly:
        return !day.isBefore(todo.dueDate) &&
            day.day == (todo.recurringDayOfMonth ?? todo.dueDate.day);
      case RecurringType.monthlyLast:
        final lastDay = DateTime(day.year, day.month + 1, 0).day;
        return !day.isBefore(todo.dueDate) && day.day == lastDay;
    }
  }

  /// Calculate the next due date for a recurring todo
  DateTime? calculateNextRecurringDate(TodoModel todo) {
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
        if (todo.recurringDayOfMonth != null) {
          final nextMonth = currentDate.month == 12
              ? DateTime(currentDate.year + 1, 1, 1)
              : DateTime(currentDate.year, currentDate.month + 1, 1);
          final targetDay = todo.recurringDayOfMonth!;
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
        }
        break;

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

    return null;
  }

  /// Generate the next instance of a recurring todo
  Future<TodoModel?> generateNextRecurringInstance(
      TodoModel originalTodo) async {
    if (originalTodo.isRecurring != true) return null;

    final nextDate = calculateNextRecurringDate(originalTodo);
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
            : (originalTodo.recurringType).name,
      ),
      recurringEndDate: Value(originalTodo.recurringEndDate),
      recurringDayOfWeek: Value(originalTodo.recurringDayOfWeek),
      recurringDayOfMonth: Value(originalTodo.recurringDayOfMonth),
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

  Future<List<TodoModel>> generateUpcomingRecurringTodos() async {
    final allTodos = await getTodo();
    final now = DateTime.now();
    final oneWeekFromNow = now.add(const Duration(days: 7));
    final generatedTodos = <TodoModel>[];

    for (final todo in allTodos) {
      if (todo.isRecurring == true && !todo.isCompleted) {
        var currentTodo = todo;

        for (int i = 0; i < 3; i++) {
          final nextDate = calculateNextRecurringDate(currentTodo);
          if (nextDate == null || nextDate.isAfter(oneWeekFromNow)) break;

          if (todo.recurringEndDate != null &&
              nextDate.isAfter(todo.recurringEndDate!)) {
            break;
          }

          final exists = allTodos.any((t) =>
              t.title == todo.title &&
              t.dueDate.year == nextDate.year &&
              t.dueDate.month == nextDate.month &&
              t.dueDate.day == nextDate.day &&
              t.dueDate.hour == nextDate.hour &&
              t.dueDate.minute == nextDate.minute);
          if (!exists) {
            final now = DateTime.now();
            final companion = TodosCompanion(
              title: Value(todo.title),
              description: Value(todo.description),
              dueDate: Value(nextDate),
              isCompleted: const Value(false),
              color: Value(todo.color),
              icon: Value(todo.icon),
              categoryId: Value(todo.categoryId),
              createdAt: Value(now),
              updatedAt: Value(now),
              isRecurring: Value(todo.isRecurring ?? false),
              recurringType: Value(
                (todo.recurringType is String)
                    ? todo.recurringType as String
                    : (todo.recurringType).name,
              ),
              recurringEndDate: Value(todo.recurringEndDate),
              recurringDayOfWeek: Value(todo.recurringDayOfWeek),
              recurringDayOfMonth: Value(todo.recurringDayOfMonth),
              // タイマー設定をコピー
              timerType: Value(todo.timerType.name),
              countupElapsedSeconds: Value(todo.countupElapsedSeconds),
              pomodoroWorkMinutes: Value(todo.pomodoroWorkMinutes),
              pomodoroShortBreakMinutes: Value(todo.pomodoroShortBreakMinutes),
              pomodoroLongBreakMinutes: Value(todo.pomodoroLongBreakMinutes),
              pomodoroCycle: Value(todo.pomodoroCycle),
              pomodoroCompletedCycle: Value(todo.pomodoroCompletedCycle),
            );
            final id = await _todoTableRepository.insert(companion);

            final nextInstance = todo.copyWith(
              id: id,
              isCompleted: false,
              dueDate: nextDate,
              createdAt: now,
              updatedAt: now,
            );
            generatedTodos.add(nextInstance);
            currentTodo = nextInstance;
          } else {
            break;
          }
        }
      }
    }

    return generatedTodos;
  }

  /// 繰り返しTodoから指定日に最も近い未来の日付を算出
  DateTime? getNextRecurringDateFromToday(
      TodoModel recurringTodo, DateTime today) {
    if (recurringTodo.isRecurring != true) return null;

    // 今日以降の最初の繰り返し日を見つける
    DateTime currentCheck = today;

    // 最大90日先まで検索（無限ループを防ぐ）
    for (int i = 0; i < 90; i++) {
      if (_isRecurringOnDay(recurringTodo, currentCheck)) {
        // 繰り返し終了日をチェック
        if (recurringTodo.recurringEndDate != null &&
            currentCheck.isAfter(recurringTodo.recurringEndDate!)) {
          return null;
        }

        // 元のdue dateよりも前の日付はスキップ
        if (currentCheck.isBefore(DateTime(recurringTodo.dueDate.year,
            recurringTodo.dueDate.month, recurringTodo.dueDate.day))) {
          currentCheck = currentCheck.add(const Duration(days: 1));
          continue;
        }

        // 今日以降の最初の該当日を返す
        if (!currentCheck.isBefore(today)) {
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

  /// parentTodoIdと日付で既存のTodoインスタンスを検索
  Future<TodoModel?> findRecurringInstance(
      int parentTodoId, DateTime targetDate) async {
    final dateOnly =
        DateTime(targetDate.year, targetDate.month, targetDate.day);

    final todos = await _todoTableRepository.findAll();
    for (final todo in todos) {
      if (todo.parentTodoId == parentTodoId) {
        final todoDateOnly =
            DateTime(todo.dueDate.year, todo.dueDate.month, todo.dueDate.day);
        if (todoDateOnly.isAtSameMomentAs(dateOnly)) {
          return TodoModel.fromTodo(todo);
        }
      }
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
      recurringType: Value(parentTodo.recurringType.name),
      recurringEndDate: Value(parentTodo.recurringEndDate),
      recurringDayOfWeek: Value(parentTodo.recurringDayOfWeek),
      recurringDayOfMonth: Value(parentTodo.recurringDayOfMonth),
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

    return TodoModel(
      id: id,
      title: parentTodo.title,
      description: parentTodo.description,
      dueDate: DateTime(
        targetDate.year,
        targetDate.month,
        targetDate.day,
        parentTodo.dueDate.hour,
        parentTodo.dueDate.minute,
      ),
      isCompleted: false,
      color: parentTodo.color,
      icon: parentTodo.icon,
      categoryId: parentTodo.categoryId,
      createdAt: now,
      updatedAt: now,
      isRecurring: parentTodo.isRecurring ?? false,
      recurringType: parentTodo.recurringType,
      recurringEndDate: parentTodo.recurringEndDate,
      recurringDayOfWeek: parentTodo.recurringDayOfWeek,
      recurringDayOfMonth: parentTodo.recurringDayOfMonth,
      parentTodoId: parentTodo.id,
      timerType: parentTodo.timerType,
      countupElapsedSeconds: parentTodo.countupElapsedSeconds,
      pomodoroWorkMinutes: parentTodo.pomodoroWorkMinutes,
      pomodoroShortBreakMinutes: parentTodo.pomodoroShortBreakMinutes,
      pomodoroLongBreakMinutes: parentTodo.pomodoroLongBreakMinutes,
      pomodoroCycle: parentTodo.pomodoroCycle,
      pomodoroCompletedCycle: parentTodo.pomodoroCompletedCycle,
    );
  }

  /// 繰り返しTodoの表示フィルタリング（新しい実装）
  /// - 今日以前かつ未完了のものは全て表示
  /// - 明日以降のものは既存インスタンスがあればそれを表示、なければ最も近い日付の1件のみ作成して表示
  Future<List<TodoModel>> getFilteredTodosWithRecurringDisplay({
    required DateTime currentDate,
    required List<TodoModel> todos,
  }) async {
    final result = <TodoModel>[];
    final today =
        DateTime(currentDate.year, currentDate.month, currentDate.day);

    // 全てのTodoを取得（子インスタンス含む）
    final allTodos = await _todoTableRepository.findAll();

    // 繰り返しTodoと通常Todoを分別
    final recurringParentTodos = <TodoModel>[];
    final normalTodos = <TodoModel>[];

    for (final todo in todos) {
      if (todo.isRecurring == true && todo.parentTodoId == null) {
        // 親の繰り返しTodoのみを処理（子インスタンスは除外）
        recurringParentTodos.add(todo);
      } else if (todo.parentTodoId == null) {
        // parentTodoIdがnullの通常Todo（繰り返しではない）のみを追加
        normalTodos.add(todo);
      }
      // parentTodoIdがnullでないもの（子インスタンス）は後で処理するため、ここでは無視
    }

    // 通常Todo（繰り返しではない）を追加
    result.addAll(normalTodos);
    result.addAll(recurringParentTodos);

    // 繰り返しTodoを処理
    for (final parentTodo in recurringParentTodos) {
      // この親Todoに関連する全ての子インスタンスを取得
      final allChildInstances =
          allTodos.where((todo) => todo.parentTodoId == parentTodo.id).toList();

      // 今日以前の未完了インスタンスを追加
      final pastInstances = allChildInstances
          .where((todo) =>
              !todo.isCompleted &&
              DateTime(todo.dueDate.year, todo.dueDate.month, todo.dueDate.day)
                  .isBefore(today))
          .toList();

      for (final instance in pastInstances) {
        result.add(TodoModel.fromTodo(instance));
      }

      // 今日以降の既存インスタンスを取得
      final futureInstances = allChildInstances
          .where((todo) =>
              DateTime(todo.dueDate.year, todo.dueDate.month, todo.dueDate.day)
                  .isAtSameMomentAs(today) ||
              DateTime(todo.dueDate.year, todo.dueDate.month, todo.dueDate.day)
                  .isAfter(today))
          .toList();

      if (futureInstances.isNotEmpty) {
        // 既存の未来インスタンスがある場合、最も近い日付のもの1件のみを追加
        futureInstances.sort((a, b) => a.dueDate.compareTo(b.dueDate));
        final nearestInstance = futureInstances.first;

        result.add(TodoModel.fromTodo(nearestInstance));
      } else {
        // 既存の未来インスタンスがない場合のみ、新しいインスタンスを作成
        final nextDate = getNextRecurringDateFromToday(parentTodo, today);
        if (nextDate != null) {
          final newInstance =
              await createRecurringInstance(parentTodo, nextDate);
          result.add(newInstance);
        }
      }
    }

    return result;
  }
}
