# GitHub Copilot Instructions for Solo App

このファイルは、GitHub CopilotがSoloアプリの開発において一貫したコードを生成するためのガイドラインです。

## プロジェクト概要

Soloは、タスク管理とポモドーロタイマー機能を備えたFlutter製の生産性向上アプリです。

### 主要機能
- Todoタスク管理
- ポモドーロタイマー
- カウントアップタイマー
- 設定管理（テーマ、通知、タイマー設定）
- カレンダー表示

## アーキテクチャ概要

```
┌─────────────────┐
│   UI Layer      │ ← HookConsumerWidget (hooks_riverpod)
├─────────────────┤
│  State Layer    │ ← Riverpod Providers (@riverpod annotation)
├─────────────────┤
│ Service Layer   │ ← Business Logic & External API
├─────────────────┤
│Repository Layer │ ← Drift Database & Data Access
├─────────────────┤
│  Model Layer    │ ← Freezed Data Classes
└─────────────────┘
```

## 必須技術スタック

### 1. 状態管理: Riverpod
**使用ライブラリ**: `hooks_riverpod`, `riverpod_annotation`, `riverpod_generator`

**重要**: 状態管理では必ずRiverpodを使用し、他のライブラリ（Provider, Bloc, GetX等）は使用しないでください。

```dart
// ✅ 正しい実装例
@riverpod
class SettingsState extends _$SettingsState {
  @override
  AppSettings build() {
    return const AppSettings();
  }

  void updateThemeMode(ThemeMode themeMode) {
    state = state.copyWith(themeMode: themeMode);
    _saveSettings();
  }
}

// ❌ 使用禁止
// Provider, BlocProvider, GetXなどの他の状態管理ライブラリ
```

### 2. UIコンポーネント: Flutter Hooks
**使用ライブラリ**: `flutter_hooks`, `hooks_riverpod`

**パターン**: すべてのWidgetは`HookConsumerWidget`を継承してください。

```dart
// ✅ 正しい実装例
class SettingsPage extends HookConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsStateProvider);
    final settingsController = ref.read(settingsStateProvider.notifier);
    
    return Scaffold(/* ... */);
  }
}

// ❌ 使用禁止
// StatefulWidget, ConsumerWidget（HookConsumerWidgetを使用）
```

### 3. データモデル: Freezed
**使用ライブラリ**: `freezed`, `freezed_annotation`, `json_serializable`

**パターン**: すべてのデータクラスはFreezedを使用して不変オブジェクトとして定義してください。

```dart
// ✅ 正しい実装例
@freezed
class AppSettings with _$AppSettings {
  const factory AppSettings({
    @Default(ThemeMode.system) ThemeMode themeMode,
    @Default(25) int defaultWorkMinutes,
    // ...
  }) = _AppSettings;

  factory AppSettings.fromJson(Map<String, dynamic> json) =>
      _$AppSettingsFromJson(json);
}

// ❌ 使用禁止
// 通常のクラス、equatable、built_valueなど
```

### 4. データベース: Drift
**使用ライブラリ**: `drift`, `drift_flutter`

**パターン**: Singletonパターンでデータベースインスタンスを管理し、Repositoryパターンで操作してください。

```dart
// ✅ 正しい実装例 - Database定義
@DriftDatabase(tables: [Todos, Categories, TodoCheckListItems])
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.e);

  static AppDatabase? _instance;
  
  @override
  int get schemaVersion => 3;

  static Future<AppDatabase> getSingletonInstance() async {
    _instance ??= AppDatabase(LazyDatabase(() async {
      final dbFolder = await getApplicationDocumentsDirectory();
      final file = File(path.join(dbFolder.path, 'db.sqlite'));
      return NativeDatabase.createInBackground(file);
    }));
    return _instance!;
  }
}

// ✅ 正しい実装例 - Repository層
class TodoTableRepository {
  Future<List<Todo>> findAll() async {
    final database = await AppDatabase.getSingletonInstance();
    final data = await database.todos.select().get();
    return data.map((e) => Todo(/* ... */)).toList();
  }

  Future<int> insert(TodosCompanion todo) async {
    final database = await AppDatabase.getSingletonInstance();
    return await database.todos.insertOne(todo);
  }
}

// ❌ 使用禁止
// sqflite、hive、その他のデータベースライブラリ
```

### 6. 国際化・ローカライゼーション
**使用ライブラリ**: `intl`

**パターン**: 日本語ロケール（ja-JP）で初期化し、日付フォーマットを使用

```dart
// ✅ main.dartでの初期化例
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting("ja-JP", null);
  
  runApp(/* ... */);
}

// ✅ 日付フォーマットの使用例
Text(
  DateFormat('yyyy年MM月dd日').format(DateTime.now()),
)

// ✅ UIテキストは日本語で統一
Text('設定'),
Text('タスクを追加'),
Text('ポモドーロタイマー'),
```

### 5. ルーティング: GoRouter
**使用ライブラリ**: `go_router`

**パターン**: ルート定義はRouterDefinitionクラスで管理し、BulderWidgetでラップしてください。

```dart
// ✅ 正しい実装例
class RouterDefinition {
  static Route home = Route(
    path: '/',
    name: '/',
    builder: (context, state) => BulderWidget(child: const HomePage())
  );
  
  static Route settings = Route(
    path: '/settings',
    name: '/settings',
    builder: (context, state) => BulderWidget(child: const SettingsPage())
  );
}

@riverpod
GoRouter appRouter(AppRouterRef ref) {
  return GoRouter(
    routes: [
      GoRoute(
        path: RouterDefinition.home.path,
        name: RouterDefinition.home.name,
        builder: RouterDefinition.home.builder,
      ),
      // ...
    ],
  );
}

// ❌ 使用禁止
// Navigator 2.0の直接使用、auto_route、fluro
```

## コーディング規約

### 1. ファイル構成

```
lib/
├── enums/           # 列挙型
├── models/          # Freezedデータクラス
│   └── build/       # 生成されたコード
├── repositories/    # データアクセス層
├── screen/          # UI関連
│   ├── pages/       # 画面コンポーネント
│   ├── states/      # Riverpod Provider
│   └── widgets/     # 再利用可能なWidget
├── services/        # ビジネスロジック
└── utilities/       # ユーティリティ関数
```

### 2. 命名規約

- **Provider**: `xxxStateProvider`, `xxxServiceProvider`
- **Model**: `XxxModel` (例: `TodoModel`, `SettingsModel`)
- **Service**: `XxxService` (例: `TodoService`, `SettingsService`)
- **Repository**: `XxxTableRepository` (例: `TodoTableRepository`)
- **Widget**: `XxxPage`, `XxxWidget`
- **State**: `XxxState` (例: `SettingsState`, `TimerState`)
- **Extension**: `XxxExtension` (例: `AppSettingsExtension`)

### 3. Japanese UI Text Convention
UIテキストはすべて日本語で統一してください：

```dart
// ✅ 正しい例
Text('設定'),
Text('タスクを追加'),
Text('ポモドーロタイマー'),

// ❌ 間違い
Text('Settings'),
Text('Add Task'),
```

### 3. コード生成

以下のコマンドでコード生成を実行：
```bash
dart run build_runner build --delete-conflicting-outputs
```

**重要**: `part` ディレクティブは `build/` フォルダを使用してください（build.yamlで設定済み）：
```dart
part 'build/settings_state.g.dart';     // ✅ 正しい（Riverpod）
part 'build/settings_model.freezed.dart'; // ✅ 正しい（Freezed）
part 'build/settings_model.g.dart';     // ✅ 正しい（JSON）

part 'settings_state.g.dart';           // ❌ 間違い
```

### 4. ディレクトリ構成での注意点
- 生成されたファイルは必ず `build/` サブディレクトリに配置される
- 手動で生成ファイルの場所を変更しない
- 生成ファイルは `.gitignore` で除外されないため、コミットに含まれる
- `/build/` (ルートレベル) は除外されているが、`lib/**/build/` は追跡対象

## 実装パターン

### 1. 設定管理パターン

```dart
// Service層
class SettingsService {
  static Future<AppSettings> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('app_settings');
    if (jsonString != null) {
      final json = jsonDecode(jsonString) as Map<String, dynamic>;
      return AppSettings.fromJson(json);
    }
    return const AppSettings(); // デフォルト設定
  }

  static Future<void> saveSettings(AppSettings settings) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(settings.toJson());
    await prefs.setString('app_settings', jsonString);
  }
}

// State層
@riverpod
class SettingsState extends _$SettingsState {
  @override
  AppSettings build() {
    return const AppSettings();
  }

  Future<void> initialize() async {
    final loadedSettings = await SettingsService.loadSettings();
    state = loadedSettings;
  }

  void updateThemeMode(ThemeMode themeMode) {
    state = state.copyWith(themeMode: themeMode);
    _saveSettings();
  }

  Future<void> _saveSettings() async {
    await SettingsService.saveSettings(state);
  }
}
```

### 2. UI更新パターン

```dart
class SettingsPage extends HookConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsStateProvider);
    final settingsController = ref.read(settingsStateProvider.notifier);

    return Scaffold(
      body: Column(
        children: [
          SwitchListTile(
            title: Text('ダークテーマ'),
            value: settings.themeMode == ThemeMode.dark,
            onChanged: (value) {
              settingsController.updateThemeMode(
                value ? ThemeMode.dark : ThemeMode.light,
              );
            },
          ),
        ],
      ),
    );
  }
}
```

### 3. エラーハンドリングパターン

```dart
@riverpod
class DataState extends _$DataState {
  @override
  AsyncValue<List<Todo>> build() {
    return const AsyncValue.loading();
  }

  Future<void> loadData() async {
    state = const AsyncValue.loading();
    try {
      final data = await TodoService.getAllTodos();
      state = AsyncValue.data(data);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
}

// UI側
Widget build(BuildContext context, WidgetRef ref) {
  final dataState = ref.watch(dataStateProvider);

  return dataState.when(
    data: (data) => ListView(/* ... */),
    loading: () => const CircularProgressIndicator(),
    error: (error, stack) => Text('エラー: $error'),
  );
}
```

### 4. Timer管理パターン

```dart
@riverpod
class TimerState extends _$TimerState {
  Timer? _timer;

  @override
  TimerSession build() {
    return const TimerSession(
      settings: TimerSettings(),
      mode: TimerMode.pomodoro,
      remainingSeconds: 25 * 60,
    );
  }

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.remainingSeconds > 0) {
        state = state.copyWith(
          remainingSeconds: state.remainingSeconds - 1,
        );
      } else {
        _completeTimer();
      }
    });
  }

  void _stopTimer() {
    _timer?.cancel();
    _timer = null;
  }
}
```

## 禁止事項

### 使用禁止のライブラリ・パターン
- **状態管理**: Provider, Bloc, GetX, MobX
- **UI**: StatefulWidget（HookConsumerWidget使用）
- **データクラス**: built_value, equatable（Freezed使用）
- **データベース**: sqflite, hive（Drift使用）
- **ルーティング**: 直接Navigator使用（GoRouter使用）
- **HTTP**: dio, http（現在未使用、必要時は要相談）

### コーディング禁止パターン
- `setState`の使用（Riverpod使用）
- Global変数の使用
- Singletonパターン（Riverpod Provider使用、ただしDatabase層は例外）
- 生のFutureBuilder（AsyncValueパターン使用）
- `StatefulWidget`や`StatelessWidget`の直接使用（`HookConsumerWidget`使用）

## Freezed拡張パターン

```dart
// ✅ Extensionを使った表示用メソッド
extension AppSettingsExtension on AppSettings {
  String get themeDisplayName {
    switch (themeMode) {
      case ThemeMode.light:
        return 'ライトテーマ';
      case ThemeMode.dark:
        return 'ダークテーマ';
      case ThemeMode.system:
        return 'システム設定に従う';
    }
  }

  String get countUpNotificationDisplayTime {
    if (countUpNotificationMinutes < 60) {
      return '$countUpNotificationMinutes分';
    } else {
      final hours = countUpNotificationMinutes ~/ 60;
      final minutes = countUpNotificationMinutes % 60;
      return minutes == 0 ? '$hours時間' : '$hours時間$minutes分';
    }
  }
}
```

## UI共通パターン

### BulderWidget使用パターン
```dart
// ✅ 全ページでBulderWidgetを使用
class HomePage extends HookConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return BulderWidget(
      child: Scaffold(/* ... */),
    );
  }
}
```

### カラーテーマパターン
```dart
// ✅ Theme拡張の使用（lib/screen/colors.dartで定義された拡張を使用）
Container(
  decoration: BoxDecoration(
    gradient: LinearGradient(
      colors: Theme.of(context).colorScheme.backgroundGradient,
    ),
  ),
  child: Text(
    'サンプルテキスト',
    style: TextStyle(
      color: Theme.of(context).colorScheme.primaryTextColor,
      fontSize: 16,
    ),
  ),
)

// 利用可能なカラー拡張:
// - backgroundGradient: List<Color>
// - primaryGradient: List<Color>
// - primaryTextColor: Color
// - secondaryTextColor: Color
// - mutedTextColor: Color
// - successColor: Color
// - infoColor: Color
// - warningColor: Color
// - errorColor: Color
// - accentColor: Color
// - purpleColor: Color
```

## テストパターン

```dart
// ✅ Serviceクラスのテスト例
void main() {
  group('SettingsService', () {
    setUp(() async {
      SharedPreferences.setMockInitialValues({});
    });

    test('should save and load settings correctly', () async {
      const testSettings = AppSettings(
        themeMode: ThemeMode.dark,
        defaultWorkMinutes: 30,
        // ...
      );

      final saveResult = await SettingsService.saveSettings(testSettings);
      expect(saveResult, true);

      final loadedSettings = await SettingsService.loadSettings();
      expect(loadedSettings.themeMode, ThemeMode.dark);
      expect(loadedSettings.defaultWorkMinutes, 30);
    });
  });
}

// ✅ Riverpod Providerのテスト例
void main() {
  group('SettingsState', () {
    test('should update theme mode correctly', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final notifier = container.read(settingsStateProvider.notifier);
      notifier.updateThemeMode(ThemeMode.dark);

      final settings = container.read(settingsStateProvider);
      expect(settings.themeMode, ThemeMode.dark);
    });
  });
}
```

## デバッグ・開発ツール

- **Riverpod Inspector**: `riverpod_lint`使用
- **コード生成**: `build_runner`
- **静的解析**: `flutter_lints`

## まとめ

1. **状態管理**: Riverpodのみ使用
2. **UI**: HookConsumerWidgetパターン
3. **データモデル**: Freezedパターン
4. **データベース**: Driftパターン
5. **ルーティング**: GoRouterパターン
6. **アーキテクチャ**: レイヤード・アーキテクチャ

新機能追加時は、必ずこれらのパターンに従って実装し、既存コードとの一貫性を保ってください。