
class DateTimeExt extends DateTime {

  DateTimeExt(int year,
      [int month = 1,
        int day = 1,
        int hour = 0,
        int minute = 0,
        int second = 0,
        int millisecond = 0,
        int microsecond = 0])
      : super(year, month, day, hour, minute, second, millisecond,
      microsecond);

  DateTimeExt.now() : super.now();

  DateTimeExt.fromDate(DateTime date) : super(date.year, date.month, date.day, date.hour, date.minute, date.second, date.millisecond,
      date.microsecond);

  String getYMD() => '$year-${add0(month)}-${add0(day)}';
  String getDMY([String? sep]) => '${add0(day)} ${sep ?? '-'} ${add0(month)} ${sep ?? '-'} $year';
  String getDM([String? sep]) => '${add0(day)}${sep ?? ' - '}${add0(month)}';

  static String add0(int num) => num > 9 ? '$num' : '0$num';
}
