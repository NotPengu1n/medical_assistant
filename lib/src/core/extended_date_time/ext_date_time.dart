
import 'package:intl/intl.dart';

extension DateTimeExtensions on DateTime {
  bool isEmpty() {
    return (year <= 1 && month <= 1 && day <= 1 && hour == 0 && minute == 0 && second == 0);
  }

  DateTime beginOfDay() {
    return DateTime(year, month, day);
  }

  String toApiString() {
    return DateFormat("yyyy-MM-ddTHH:mm:ss").format(this);
  }

  String strWeekday() {
    final weekdays = ['ПН', 'ВТ', 'СР', 'ЧТ', 'ПТ', 'СБ', 'ВС'];
    return weekdays[weekday - 1];
  }

  String strDayMonth() {
    return DateFormat('dd.MM').format(this);
  }
}