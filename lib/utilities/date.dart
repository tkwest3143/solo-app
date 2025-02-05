import 'package:intl/intl.dart';

String formatDate(DateTime date,
    {String format = 'yyyy/MM/dd (EEE) HH:mm:ss'}) {
  final DateFormat formatter = DateFormat(format, 'ja_JP');
  return formatter.format(date);
}
