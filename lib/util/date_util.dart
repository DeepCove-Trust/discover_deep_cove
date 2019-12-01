enum weekdays { Monday, Tuesday, Wednesday, Thursday, Friday }

enum month {
  January,
  Feburary,
  March,
  April,
  May,
  June,
  July,
  August,
  September,
  October,
  November,
  December
}

class DateUtil {
  static const String TH = "\u1d57\u02b0";
  static const String ND = "\u207f\u1d48";
  static const String RD = "\u02b3\u1d48";
  static const String ST = "\u02e2\u1d57";

  static String formatDate(DateTime date) {
    return "${date.day}${getOrdinalIndicator(date.day)} ${month.values[date.month - 1].toString().split('.').last} ${date.year} ";
  }

  static String getOrdinalIndicator(int day) {
    if (day >= 11 && day <= 13) {
      return TH;
    }
    switch (day % 10) {
      case 1:
        return ST;
      case 2:
        return ND;
      case 3:
        return RD;
      default:
        return TH;
    }
  }
}