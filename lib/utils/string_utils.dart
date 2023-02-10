class StringUtils {
  static String timeDifference(DateTime time1, DateTime time2) {
    Duration duration = time2.difference(time1);
    String str = '';
    if (duration.inDays > 0) {
      str = '${duration.inDays} Days';
    }
    if (duration.inDays <= 0 && duration.inHours > 0) {
      str = str + ' ${duration.inHours} Hours';
    } else if (duration.inDays > 0 && duration.inHours > 0) {
      str = str + ' ${duration.inHours % 24} Hours';
    }
    if (duration.inDays == 0 && duration.inHours > 0) {
      str = str + ' ${duration.inMinutes % 60} Mins';
    } else {
      str = str + ' ${duration.inMinutes} Mins';
    }

    return str;
  }
}
