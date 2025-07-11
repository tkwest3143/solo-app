# Solo - タスク管理 & ポモドーロタイマーアプリ

Soloは、タスク管理とポモドーロタイマーを統合したFlutterベースのモバイルアプリケーションです。効率的な時間管理と生産性向上を支援します。

## 主な機能

### 📝 タスク管理
- カテゴリー別のタスク整理（カスタムカラー・アイコン対応）
- チェックリスト機能付きタスク
- 繰り返しタスク（毎日/週次/月次）
- 期限管理
- カレンダー表示

### ⏱️ タイマー機能
- ポモドーロタイマー（作業・休憩サイクル）
- カウントアップタイマー
- タスクとの連携
- カスタマイズ可能な作業・休憩時間

### 🎨 その他の機能
- ダークモード/ライトモード対応
- ローカル通知
- 設定の永続化
- 日本語UI

## 技術スタック

- **フレームワーク**: Flutter (Dart SDK ^3.6.1)
- **状態管理**: Riverpod 2.6.1
- **データベース**: Drift (SQLite)
- **ルーティング**: Go Router
- **コード生成**: Freezed, Build Runner

## セットアップ

### 必要な環境
- Flutter SDK 3.6.1以上
- Dart SDK
- iOS開発の場合: Xcode, CocoaPods
- Android開発の場合: Android Studio

### インストール手順

1. リポジトリをクローン
```bash
git clone [repository-url]
cd solo-app
```

2. 依存関係をインストール
```bash
flutter pub get
```

3. コード生成を実行
```bash
make build
# または
flutter pub run build_runner build --delete-conflicting-outputs
```

4. iOSの場合、Podをインストール
```bash
cd ios
pod install
cd ..
```

5. アプリを実行
```bash
flutter run
```

## 開発

### コード生成
モデルやリポジトリの変更後は、以下のコマンドでコードを再生成してください：
```bash
make build
```

### iOS Podの再インストール
Podに関する問題が発生した場合：
```bash
make pod-re
```

## プロジェクト構造

```
lib/
├── models/          # データモデル (Freezed使用)
├── repositories/    # データベース層 (Drift)
├── services/        # ビジネスロジック
├── screen/          # UI層
│   ├── pages/       # メイン画面
│   ├── widgets/     # 再利用可能なウィジェット
│   └── states/      # 状態管理 (Riverpod)
├── enums/           # 列挙型定義
└── utilities/       # ヘルパー関数
```

## ビルド

### デバッグビルド
```bash
flutter build apk --debug        # Android
flutter build ios --debug        # iOS
```

### リリースビルド
```bash
flutter build apk --release      # Android
flutter build ios --release      # iOS
```

## ライセンス

このプロジェクトのライセンスについては、プロジェクトオーナーにお問い合わせください。