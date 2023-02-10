class StringUtils {
  static String timeDifference(DateTime time1, DateTime time2) {
    Duration duration = time2.difference(time1);
    String str = '';
    if (duration.inDays > 0) {
      str = '${duration.inDays} Days';
    }
    if (duration.inHours > 0) {
      str = str + ' ${duration.inHours} Hours';
    }
    if (duration.inDays <= 0)
      str = str + ' ${duration.inMinutes} Mins';


    return str;
  }
}
