import 'package:flutter/material.dart';

enum Working {
  notWorking,
  working,
  goingHome,
  resting;

  Icon get icon {
    switch (this) {
      case Working.notWorking:
        return Icon(Icons.access_time, color: Colors.grey, size: 48);
      case Working.working:
        return Icon(Icons.work,
            color: const Color.fromARGB(255, 138, 249, 153), size: 48);
      case Working.goingHome:
        return Icon(Icons.night_shelter,
            color: const Color.fromARGB(255, 43, 227, 255), size: 48);
      case Working.resting:
        return Icon(Icons.free_breakfast,
            color: const Color.fromARGB(255, 248, 195, 120), size: 48);
    }
  }

  @override
  String toString() {
    switch (this) {
      case Working.notWorking:
        return '出勤していません';
      case Working.working:
        return '勤務中';
      case Working.goingHome:
        return '退勤しました';
      case Working.resting:
        return '休憩中';
    }
  }
}
