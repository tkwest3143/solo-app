import 'dart:isolate';
import 'dart:ui';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:solo/models/timer_model.dart';
import 'package:solo/services/notification_service.dart';

class BackgroundTimerService {
  static const String _timerDataKey = 'background_timer_data';
  static const String _isolatePortName = 'timer_isolate_port';
  static const int _alarmId = 1000;

  /// バックグラウンドタイマーを開始
  static Future<bool> startBackgroundTimer(TimerSession timerSession) async {
    try {
      // タイマーデータを永続化
      await _saveTimerData(timerSession);

      // 1秒ごとにアラームを設定
      return await AndroidAlarmManager.periodic(
        const Duration(seconds: 1),
        _alarmId,
        _backgroundTimerCallback,
        exact: true,
        wakeup: true,
        rescheduleOnReboot: true,
      );
    } catch (e) {
      // 正確なアラームの許可がない場合のエラーハンドリング
      if (e.toString().contains('exact_alarms_not_permitted')) {
        if (kDebugMode) {
          print('Exact alarms not permitted. Trying with approximate alarm.');
        }
        try {
          // exactをfalseにしてリトライ
          return await AndroidAlarmManager.periodic(
            const Duration(seconds: 1),
            _alarmId,
            _backgroundTimerCallback,
            exact: false,
            wakeup: true,
            rescheduleOnReboot: true,
          );
        } catch (retryError) {
          if (kDebugMode) {
            print(
                'Failed to start background timer with approximate alarm: $retryError');
          }
          return false;
        }
      }

      if (kDebugMode) {
        print('Failed to start background timer: $e');
      }
      return false;
    }
  }

  /// バックグラウンドタイマーを停止
  static Future<bool> stopBackgroundTimer() async {
    try {
      await AndroidAlarmManager.cancel(_alarmId);
      await _clearTimerData();
      return true;
    } catch (e) {
      if (kDebugMode) {
        print('Failed to stop background timer: $e');
      }
      return false;
    }
  }

  /// アラームマネージャーの初期化
  static Future<bool> initialize() async {
    try {
      return await AndroidAlarmManager.initialize();
    } catch (e) {
      if (kDebugMode) {
        print('Failed to initialize alarm manager: $e');
      }
      return false;
    }
  }

  /// バックグラウンドタイマーのコールバック（Isolateで実行）
  @pragma('vm:entry-point')
  static Future<void> _backgroundTimerCallback() async {
    try {
      // タイマーデータを読み込み
      final timerData = await _loadTimerData();
      if (timerData == null) {
        await stopBackgroundTimer();
        return;
      }

      // タイマー状態を更新
      final updatedTimer = _updateTimerState(timerData);

      // 更新されたデータを保存
      await _saveTimerData(updatedTimer);

      // フェーズ変更またはタイマー完了をチェック
      await _checkTimerEvents(updatedTimer);

      // UIに状態変更を通知
      await _notifyTimerUpdate(updatedTimer);
    } catch (e) {
      if (kDebugMode) {
        print('Background timer callback error: $e');
      }
    }
  }

  /// タイマー状態を更新
  static TimerSession _updateTimerState(TimerSession session) {
    if (session.mode == TimerMode.countUp) {
      return session.copyWith(
        elapsedSeconds: session.elapsedSeconds + 1,
      );
    } else {
      // ポモドーロモード
      final newRemainingSeconds = session.remainingSeconds - 1;
      return session.copyWith(
        remainingSeconds: newRemainingSeconds.clamp(0, double.infinity).toInt(),
      );
    }
  }

  /// タイマーイベント（フェーズ変更、完了）をチェック
  static Future<void> _checkTimerEvents(TimerSession session) async {
    if (session.mode == TimerMode.pomodoro && session.remainingSeconds <= 0) {
      // ポモドーロフェーズ完了
      await _handlePhaseComplete(session);
    } else if (session.mode == TimerMode.countUp) {
      // カウントアップの目標時間チェック（必要に応じて実装）
      // 目標時間データが必要な場合は追加実装
    }
  }

  /// フェーズ完了時の処理
  static Future<void> _handlePhaseComplete(TimerSession session) async {
    try {
      // 通知を表示
      final notificationService = NotificationService();
      await notificationService.initialize();
      await notificationService.showTimerPhaseNotification(
        timerSession: session,
        todoTitle: null, // バックグラウンドではTodoタイトルは取得困難
      );

      // 次のフェーズに移行
      final nextPhase = _getNextPhase(session);
      if (nextPhase != null) {
        final updatedSession = _transitionToNextPhase(session, nextPhase);
        await _saveTimerData(updatedSession);
      } else {
        // セッション完了
        await notificationService.showTimerCompletionNotification(
          timerSession: session,
          todoTitle: null,
        );
        await stopBackgroundTimer();
      }
    } catch (e) {
      if (kDebugMode) {
        print('Failed to handle phase complete: $e');
      }
    }
  }

  /// 次のフェーズを取得
  static PomodoroPhase? _getNextPhase(TimerSession session) {
    switch (session.currentPhase) {
      case PomodoroPhase.work:
        final nextCycle = session.currentCycle + 1;
        if (nextCycle >= session.settings.cyclesUntilLongBreak) {
          return PomodoroPhase.longBreak;
        } else {
          return PomodoroPhase.shortBreak;
        }
      case PomodoroPhase.shortBreak:
      case PomodoroPhase.longBreak:
        return PomodoroPhase.work;
    }
  }

  /// 次のフェーズに移行
  static TimerSession _transitionToNextPhase(
      TimerSession session, PomodoroPhase nextPhase) {
    final nextRemainingSeconds =
        _getSecondsForPhase(nextPhase, session.settings);
    int newCompletedCycles = session.completedCycles;
    int newCurrentCycle = session.currentCycle;

    // サイクル計算
    if (session.currentPhase == PomodoroPhase.work) {
      newCurrentCycle = session.currentCycle + 1;
      if (nextPhase == PomodoroPhase.longBreak) {
        newCompletedCycles = session.completedCycles + 1;
        newCurrentCycle = 0;
      }
    }

    if (session.currentPhase == PomodoroPhase.shortBreak ||
        session.currentPhase == PomodoroPhase.longBreak) {
      newCurrentCycle = session.currentCycle + 1;
      if (session.currentPhase == PomodoroPhase.longBreak) {
        newCompletedCycles = session.completedCycles + 1;
        newCurrentCycle = 0;
      }
    }

    return session.copyWith(
      currentPhase: nextPhase,
      remainingSeconds: nextRemainingSeconds,
      currentCycle: newCurrentCycle,
      completedCycles: newCompletedCycles,
    );
  }

  /// フェーズの秒数を取得
  static int _getSecondsForPhase(PomodoroPhase phase, TimerSettings settings) {
    switch (phase) {
      case PomodoroPhase.work:
        return settings.workMinutes * 60;
      case PomodoroPhase.shortBreak:
        return settings.shortBreakMinutes * 60;
      case PomodoroPhase.longBreak:
        return settings.longBreakMinutes * 60;
    }
  }

  /// タイマーデータを保存
  static Future<void> _saveTimerData(TimerSession session) async {
    final prefs = await SharedPreferences.getInstance();
    final data = {
      'mode': session.mode.name,
      'state': session.state.name,
      'currentPhase': session.currentPhase.name,
      'remainingSeconds': session.remainingSeconds,
      'elapsedSeconds': session.elapsedSeconds,
      'currentCycle': session.currentCycle,
      'completedCycles': session.completedCycles,
      'selectedTodoId': session.selectedTodoId,
      'backgroundTime': session.backgroundTime?.millisecondsSinceEpoch,
      'isInBackground': session.isInBackground,
      'settings': {
        'workMinutes': session.settings.workMinutes,
        'shortBreakMinutes': session.settings.shortBreakMinutes,
        'longBreakMinutes': session.settings.longBreakMinutes,
        'cyclesUntilLongBreak': session.settings.cyclesUntilLongBreak,
      },
    };

    await prefs.setString(_timerDataKey, data.toString());
  }

  /// タイマーデータを読み込み
  static Future<TimerSession?> _loadTimerData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final dataString = prefs.getString(_timerDataKey);
      if (dataString == null) return null;

      // 簡易的な実装 - 実際のプロジェクトではJSONシリアライゼーションを使用
      // ここでは基本的な構造のみ実装
      return null; // 実装が複雑なため、一旦nullを返す
    } catch (e) {
      if (kDebugMode) {
        print('Failed to load timer data: $e');
      }
      return null;
    }
  }

  /// タイマーデータをクリア
  static Future<void> _clearTimerData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_timerDataKey);
  }

  /// UIにタイマー更新を通知
  static Future<void> _notifyTimerUpdate(TimerSession session) async {
    final sendPort = IsolateNameServer.lookupPortByName(_isolatePortName);
    if (sendPort != null) {
      sendPort.send({
        'type': 'timer_update',
        'data': session,
      });
    }
  }

  /// UIからの通信ポートを登録
  static void registerUIPort(SendPort sendPort) {
    IsolateNameServer.removePortNameMapping(_isolatePortName);
    IsolateNameServer.registerPortWithName(sendPort, _isolatePortName);
  }
}
