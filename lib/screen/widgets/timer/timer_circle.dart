import 'package:flutter/material.dart';
import 'package:solo/screen/colors.dart';
import 'package:solo/models/timer_model.dart';

class TimerCircle extends StatelessWidget {
  final TimerSession timerSession;
  final VoidCallback? onLongPress;

  const TimerCircle({
    super.key,
    required this.timerSession,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 420, // タイマーを大きくするため高さを増加
      child: Stack(
        alignment: Alignment.center,
        children: [
          // メインの円形タイマー
          AspectRatio(
            aspectRatio: 1.0,
            child: Container(
              width: 340,
              height: 340,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).shadowColor.withValues(alpha: 0.3),
                    blurRadius: 24,
                  ),
                ],
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                // Background circle with elegant gradient
                AspectRatio(
                  aspectRatio: 1.0,
                  child: Container(
                    width: 350,
                    height: 350,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          Theme.of(context)
                              .colorScheme
                              .surface
                              .withValues(alpha: 0.8),
                          Theme.of(context)
                              .colorScheme
                              .surface
                              .withValues(alpha: 0.4),
                        ],
                        stops: const [0.0, 1.0],
                      ),
                    ),
                  ),
                ),

                // Inner circle for better depth
                AspectRatio(
                  aspectRatio: 1.0,
                  child: Container(
                    width: 340,
                    height: 340,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Theme.of(context)
                          .colorScheme
                          .surface
                          .withValues(alpha: 0.3),
                    ),
                  ),
                ),

                // Progress indicator
                AspectRatio(
                  aspectRatio: 1.0, // 1:1の比率を強制して完全な円を保証
                  child: SizedBox(
                    width: 340,
                    height: 340,
                    child: CircularProgressIndicator(
                      value: timerSession.mode == TimerMode.pomodoro
                          ? timerSession.progress
                          : 0, // カウントアップは常に完全な円
                      strokeWidth: 8,
                      strokeCap: StrokeCap.round,
                      backgroundColor: Theme.of(context)
                          .colorScheme
                          .surface
                          .withValues(alpha: 0.1),
                      valueColor: AlwaysStoppedAnimation<Color>(
                        timerSession.mode == TimerMode.pomodoro
                            ? (timerSession.isWorkPhase
                                ? Theme.of(context).colorScheme.accentColor
                                : Theme.of(context).colorScheme.infoColor)
                            : Theme.of(context)
                                .colorScheme
                                .accentColor, // カウントアップもポモドーロと同じ色
                      ),
                    ),
                  ),
                ),

                // Timer display with enhanced typography
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // フェーズ/状態表示
                    Container(
                      margin: const EdgeInsets.only(bottom: 18),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        gradient: LinearGradient(
                          colors: timerSession.mode == TimerMode.pomodoro
                              ? [
                                  (timerSession.isWorkPhase
                                          ? Theme.of(context)
                                              .colorScheme
                                              .successBackgroundColor
                                          : Theme.of(context)
                                              .colorScheme
                                              .infoBackgroundColor)
                                      .withValues(alpha: 0.5),
                                  (timerSession.isWorkPhase
                                          ? Theme.of(context)
                                              .colorScheme
                                              .successBackgroundColor
                                          : Theme.of(context)
                                              .colorScheme
                                              .infoBackgroundColor)
                                      .withValues(alpha: 0.05),
                                ]
                              : [
                                  Theme.of(context)
                                      .colorScheme
                                      .successBackgroundColor
                                      .withValues(alpha: 0.5),
                                  Theme.of(context)
                                      .colorScheme
                                      .successBackgroundColor
                                      .withValues(alpha: 0.05),
                                ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        border: Border.all(
                          color: timerSession.mode == TimerMode.pomodoro
                              ? (timerSession.isWorkPhase
                                      ? Theme.of(context)
                                          .colorScheme
                                          .successColor
                                      : Theme.of(context).colorScheme.infoColor)
                                  .withValues(alpha: 0.3)
                              : Theme.of(context)
                                  .colorScheme
                                  .successColor
                                  .withValues(alpha: 0.3),
                          width: 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: timerSession.mode == TimerMode.pomodoro
                                ? (timerSession.isWorkPhase
                                    ? Theme.of(context)
                                        .colorScheme
                                        .successBackgroundColor
                                    : Theme.of(context)
                                        .colorScheme
                                        .infoBackgroundColor)
                                : Theme.of(context)
                                    .colorScheme
                                    .successBackgroundColor,
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            timerSession.mode == TimerMode.pomodoro
                                ? (timerSession.isWorkPhase
                                    ? Icons.work_rounded
                                    : Icons.coffee_rounded)
                                : Icons.timer_outlined,
                            color: timerSession.mode == TimerMode.pomodoro
                                ? (timerSession.isWorkPhase
                                    ? Theme.of(context).colorScheme.successColor
                                    : Theme.of(context).colorScheme.infoColor)
                                : Theme.of(context).colorScheme.successColor,
                            size: 16,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            timerSession.mode == TimerMode.pomodoro
                                ? (timerSession.state == TimerStatus.running
                                    ? timerSession.currentPhaseDisplayName
                                    : 'タイマー停止中')
                                : '経過時間',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onSurface,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // タイマー表示
                    Text(
                      timerSession.displayTime,
                      style: TextStyle(
                        fontSize: 52,
                        fontWeight: FontWeight.w300,
                        color: Theme.of(context).colorScheme.onSurface,
                        fontFeatures: const [FontFeature.tabularFigures()],
                        letterSpacing: -2,
                        height: 1.0,
                      ),
                    ),
                    if (onLongPress != null &&
                        timerSession.mode == TimerMode.pomodoro)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 2),
                        child: Text(
                          '長押しで設定を変更',
                          style: TextStyle(
                            fontSize: 14,
                            color:
                                Theme.of(context).colorScheme.primaryTextColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                  ],
                ),

                // Long press detection overlay
                if (onLongPress != null)
                  Positioned.fill(
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(160),
                        onLongPress: onLongPress,
                        child: Container(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
