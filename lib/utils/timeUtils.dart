import 'package:flutter/material.dart';

class TimeUtils {
  // 工具类、私有构造函数
  TimeUtils._();

  static int? getDbTime(DateTime? dateTime) {
    if (dateTime == null) {
      return null;
    }
    return dateTime.millisecondsSinceEpoch ~/ 1000;
  }

  static int getZeroTime(DateTime dateTime) {
    // 当天0点的时间
    final DateTime zeroTime = DateTime(dateTime.year, dateTime.month, dateTime.day);
    return zeroTime.millisecondsSinceEpoch ~/ 1000;
  }

  static int getLatestTime(DateTime dateTime) {
    // 当天0点的时间
    final DateTime zeroTime = DateTime(dateTime.year, dateTime.month, dateTime.day);
    // 23:59:59
    final DateTime endTime = zeroTime.add(const Duration(days: 1)).subtract(const Duration(seconds: 1));
    return endTime.millisecondsSinceEpoch ~/ 1000;
  }

  static DateTime? parseDbTime(int? time) {
    if (time == null) {
      return null;
    }
    return DateTime.fromMillisecondsSinceEpoch(time * 1000);
  }

  static int? getTimeStamp(DateTime? dateTime) {
    if (dateTime == null) {
      return null;
    }
    return dateTime.millisecondsSinceEpoch ~/ 1000;
  }

  static String? getCheckInTime(TimeOfDay? timeOfDay) {
    if (timeOfDay == null) {
      return null;
    }
    return '${timeOfDay.hour}:${timeOfDay.minute}';
  }

  static DateTime from(int timeStamp) {
    return DateTime.fromMillisecondsSinceEpoch(timeStamp * 1000);
  }

  static TimeOfDay? fromCheckInTime(String? time) {
    if (time == null) {
      return null;
    }
    final List<String> timeList = time.split(':');
    return TimeOfDay(
      hour: int.parse(timeList[0]),
      minute: int.parse(timeList[1]),
    );
  }

  static String getShowTime(TimeOfDay timeOfDay) {
    String addLeadingZeroIfNeeded(int value) {
      if (value < 10) {
        return '0$value';
      }
      return value.toString();
    }

    final String hourLabel = addLeadingZeroIfNeeded(timeOfDay.hour);
    final String minuteLabel = addLeadingZeroIfNeeded(timeOfDay.minute);

    return '$hourLabel:$minuteLabel';
  }

  static String getShowTimeFromTimeStamp(String checkInTime) {
    return getShowTime(fromCheckInTime(checkInTime)!);
  }

  static String getShowDate(DateTime date) {
    return '${date.year}-${date.month}-${date.day}';
  }

  static String getShowDateFromTimeStr(int timeStamp) {
    return getShowDate(from(timeStamp));
  }
}
