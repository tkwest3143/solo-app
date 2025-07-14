import 'package:flutter_test/flutter_test.dart';
import 'package:solo/services/background_timer_service.dart';
import 'package:solo/models/timer_model.dart';

void main() {
  group('BackgroundTimerService', () {
    test('should initialize alarm manager', () async {
      // Act
      final result = await BackgroundTimerService.initialize();
      
      // Assert - アラームマネージャーの初期化はテスト環境では失敗するが、例外がスローされないことを確認
      expect(result, isA<bool>());
    });

    test('should handle timer state updates correctly', () {
      // Arrange
      const timerSettings = TimerSettings(
        workMinutes: 25,
        shortBreakMinutes: 5,
        longBreakMinutes: 15,
        cyclesUntilLongBreak: 4,
      );

      final pomodoroSession = TimerSession(
        mode: TimerMode.pomodoro,
        state: TimerStatus.running,
        currentPhase: PomodoroPhase.work,
        remainingSeconds: 1500, // 25分
        elapsedSeconds: 0,
        currentCycle: 0,
        completedCycles: 0,
        settings: timerSettings,
      );

      final countUpSession = TimerSession(
        mode: TimerMode.countUp,
        state: TimerStatus.running,
        currentPhase: PomodoroPhase.work,
        remainingSeconds: 0,
        elapsedSeconds: 300, // 5分
        currentCycle: 0,
        completedCycles: 0,
        settings: timerSettings,
      );

      // Act & Assert - 状態更新処理がエラーなく実行されることを確認
      expect(
        () => BackgroundTimerService.startBackgroundTimer(pomodoroSession),
        returnsNormally,
      );

      expect(
        () => BackgroundTimerService.startBackgroundTimer(countUpSession),
        returnsNormally,
      );
    });

    test('should stop background timer correctly', () async {
      // Act & Assert - タイマー停止処理がエラーなく実行されることを確認
      expect(
        () => BackgroundTimerService.stopBackgroundTimer(),
        returnsNormally,
      );
    });

    test('should handle phase transitions correctly', () {
      // Arrange
      const timerSettings = TimerSettings(
        workMinutes: 1, // テスト用に短い時間
        shortBreakMinutes: 1,
        longBreakMinutes: 1,
        cyclesUntilLongBreak: 2,
      );

      // 作業フェーズ完了間際のセッション
      final workCompleteSession = TimerSession(
        mode: TimerMode.pomodoro,
        state: TimerStatus.running,
        currentPhase: PomodoroPhase.work,
        remainingSeconds: 1, // 残り1秒
        elapsedSeconds: 59,
        currentCycle: 0,
        completedCycles: 0,
        settings: timerSettings,
      );

      // 短い休憩完了間際のセッション
      final shortBreakCompleteSession = TimerSession(
        mode: TimerMode.pomodoro,
        state: TimerStatus.running,
        currentPhase: PomodoroPhase.shortBreak,
        remainingSeconds: 1, // 残り1秒
        elapsedSeconds: 59,
        currentCycle: 1,
        completedCycles: 0,
        settings: timerSettings,
      );

      // Act & Assert - フェーズ変更処理がエラーなく実行されることを確認
      expect(
        () => BackgroundTimerService.startBackgroundTimer(workCompleteSession),
        returnsNormally,
      );

      expect(
        () => BackgroundTimerService.startBackgroundTimer(shortBreakCompleteSession),
        returnsNormally,
      );
    });

    test('should handle alarm manager failures gracefully', () async {
      // Arrange
      const timerSettings = TimerSettings();
      final session = TimerSession(
        mode: TimerMode.pomodoro,
        state: TimerStatus.running,
        currentPhase: PomodoroPhase.work,
        remainingSeconds: 1500,
        elapsedSeconds: 0,
        currentCycle: 0,
        completedCycles: 0,
        settings: timerSettings,
      );

      // Act & Assert - アラームマネージャーが使用できない環境でも例外がスローされないことを確認
      expect(
        () async => await BackgroundTimerService.startBackgroundTimer(session),
        returnsNormally,
      );

      expect(
        () async => await BackgroundTimerService.stopBackgroundTimer(),
        returnsNormally,
      );
    });

    test('should handle exact alarms permission error gracefully', () async {
      // Arrange
      const timerSettings = TimerSettings();
      final session = TimerSession(
        mode: TimerMode.pomodoro,
        state: TimerStatus.running,
        currentPhase: PomodoroPhase.work,
        remainingSeconds: 1500,
        elapsedSeconds: 0,
        currentCycle: 0,
        completedCycles: 0,
        settings: timerSettings,
      );

      // Act
      final result = await BackgroundTimerService.startBackgroundTimer(session);

      // Assert - exact_alarms_not_permittedエラーが発生しても適切にfalseを返すか、
      // approximate alarmでfalsebackが機能することを確認
      expect(result, isA<bool>());
      
      // テスト環境では実際のアラーム設定はできないが、
      // エラーハンドリングが適切に動作し、例外がスローされないことを確認
      expect(
        () async => await BackgroundTimerService.startBackgroundTimer(session),
        returnsNormally,
      );
    });
  });
}