import 'package:intl/intl.dart';

String formatDate(DateTime date,
    {String format = 'yyyy/MM/dd (EEE) HH:mm:ss'}) {
  final DateFormat formatter = DateFormat(format, 'ja_JP');
  return formatter.format(date);
}

DateTime parseDate(String date, {String format = 'yyyy/MM/dd HH:mm:ss'}) {
  final DateFormat formatter = DateFormat(format, 'ja_JP');
  return formatter.parse(date);
}

bool isToday(DateTime date) {
  final now = DateTime.now();
  return date.year == now.year &&
      date.month == now.month &&
      date.day == now.day;
}
