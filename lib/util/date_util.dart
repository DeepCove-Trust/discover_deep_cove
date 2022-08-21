enum Weekdays {
  monday,
  tuesday,
  wednesday,
  thursday,
  friday,
}

enum Month {
  january,
  feburary,
  march,
  april,
  may,
  june,
  july,
  august,
  september,
  october,
  november,
  december,
}

class DateUtil {
  static const String th = '\u1d57\u02b0';
  static const String nd = '\u207f\u1d48';
  static const String rd = '\u02b3\u1d48';
  static const String st = '\u02e2\u1d57';

  static String formatDate(DateTime date) {
    return "${date.day}${getOrdinalIndicator(date.day)} ${Month.values[date.month - 1].toString().split('.').last} ${date.year} ";
  }

  static String getOrdinalIndicator(int day) {
    if (day >= 11 && day <= 13) {
      return th;
    }
    switch (day % 10) {
      case 1:
        return st;
      case 2:
        return nd;
      case 3:
        return rd;
      default:
        return th;
    }
  }
}
