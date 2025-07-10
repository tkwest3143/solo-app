// タイマー種別のenum
enum TimerType { none, pomodoro, countup

 }

extension TimerTypeExtension on TimerType {
  String get name {
    switch (this) {
      case TimerType.none:
        return 'none';
      case TimerType.pomodoro:
        return 'pomodoro';
      case TimerType.countup:
        return 'countup';
    }
  }

  static TimerType fromString(String value) {
    switch (value) {
      case 'pomodoro':
        return TimerType.pomodoro;
      case 'countup':
        return TimerType.countup;
      default:
        return TimerType.none;
    }
  }
}
