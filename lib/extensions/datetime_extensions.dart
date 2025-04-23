extension DateTimeExtensions on DateTime {
  String get formatted =>
      '${day.toString().padLeft(2, '0')}-${month.toString().padLeft(2, '0')}-${year}';

  bool get isWeekend => weekday == DateTime.saturday || weekday == DateTime.sunday;
}
