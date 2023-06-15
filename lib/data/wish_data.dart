import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:wish/data/data_base_helper.dart';
import 'package:wish/utils/timeUtils.dart';
import 'package:wish/widgets/picker.dart';

enum SortType {
  name,
  createdTime,
  modifiedTime;

  @override
  String toString() {
    switch (this) {
      case SortType.name:
        return '名称';
      case SortType.createdTime:
        return '创建时间';
      case SortType.modifiedTime:
        return '修改时间';
    }
  }
}

enum WishType {
  wish,
  repeat,
  checkIn;

  @override
  String toString() {
    switch (this) {
      case WishType.wish:
        return '心愿';
      case WishType.repeat:
        return '重复';
      case WishType.checkIn:
        return '打卡';
    }
  }
}

class WishStep {
  final String desc;
  final bool done;

  WishStep(this.desc, this.done);

  copyWith({
    String? desc,
    bool? done,
  }) {
    return WishStep(
      desc ?? this.desc,
      done ?? this.done,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'desc': desc,
      'done': done ? 1 : 0,
    };
  }

  factory WishStep.fromMap(Map<String, dynamic> map) {
    return WishStep(
      map['desc'],
      map['done'] == 1,
    );
  }
}

class WishData {
  final int? id;
  final String name;
  final WishType wishType; // int
  final ColorType colorType; // int
  final String? note;
  final DateTime? endTime; // int
  final bool done; // int 1 or 0
  final bool paused;
  final List<WishStep>? stepList; // string json
  final bool isSecret;

  final TimeOfDay? checkInTime; //
  final int? periodDays; // int
  final List<DateTime>? checkedTimeList; // int

  final int? repeatCount;
  final int? actualRepeatCount;

  final DateTime? createdTime;
  final DateTime? modifiedTime;

  WishData(
    this.name, {
    this.id,
    required this.wishType,
    required this.colorType,
    this.note,
    this.endTime,
    this.done = false,
    this.paused = false,
    this.stepList,
    this.checkInTime,
    this.periodDays,
    this.repeatCount,
    this.isSecret = false,
    this.checkedTimeList,
    this.actualRepeatCount,
    this.createdTime,
    this.modifiedTime,
  });

  WishData copyWith({
    int? id,
    String? name,
    WishType? wishType,
    ColorType? colorType,
    String? note,
    DateTime? endTime,
    bool? done,
    bool? paused,
    List<WishStep>? stepList,
    TimeOfDay? checkInTime,
    int? periodDays,
    int? repeatCount,
    bool? isSecret,
    List<DateTime>? checkedTimeList,
    int? actualRepeatCount,
    DateTime? createdTime,
    DateTime? modifiedTime,
  }) {
    return WishData(
      name ?? this.name,
      id: id ?? this.id,
      wishType: wishType ?? this.wishType,
      colorType: colorType ?? this.colorType,
      note: note ?? this.note,
      endTime: endTime ?? this.endTime,
      done: done ?? this.done,
      paused: paused ?? this.paused,
      stepList: stepList ?? this.stepList,
      checkInTime: checkInTime ?? this.checkInTime,
      periodDays: periodDays ?? this.periodDays,
      repeatCount: repeatCount ?? this.repeatCount,
      isSecret: isSecret ?? this.isSecret,
      checkedTimeList: checkedTimeList ?? this.checkedTimeList,
      actualRepeatCount: actualRepeatCount ?? this.actualRepeatCount,
      createdTime: createdTime ?? this.createdTime,
      modifiedTime: modifiedTime ?? this.modifiedTime,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      DatabaseHelper.fieldColumnId: id,
      DatabaseHelper.filedName: name,
      DatabaseHelper.fieldWishType: wishType.index,
      DatabaseHelper.fieldColorType: colorType.index,
      DatabaseHelper.fieldNote: note,
      DatabaseHelper.fieldCheckInTime: TimeUtils.getCheckInTime(checkInTime),
      DatabaseHelper.fieldPeriodDays: periodDays,
      DatabaseHelper.fieldEndTime: TimeUtils.getDbTime(endTime),
      DatabaseHelper.fieldDone: done ? 1 : 0,
      DatabaseHelper.fieldPaused: paused ? 1 : 0,
      DatabaseHelper.fieldStepList: stepList == null
          ? null
          : json.encode(stepList?.map((e) => e.toMap()).toList()),
      DatabaseHelper.fieldIsSecret: isSecret ? 1 : 0,
      DatabaseHelper.fieldCheckedTimeList: checkedTimeList == null
          ? null
          : json.encode(
              checkedTimeList?.map((e) => TimeUtils.getDbTime(e)).toList()),
      DatabaseHelper.fieldRepeatCount: repeatCount,
      DatabaseHelper.fieldCreatedTime: TimeUtils.getDbTime(createdTime),
      DatabaseHelper.fieldModifiedTime: TimeUtils.getDbTime(modifiedTime),
    };
  }

  static bool diffSteps(List<WishStep>? step1, List<WishStep>? step2) {
    if (step1 == null) {
      return step2 != null && step2.isNotEmpty;
    }
    if (step2 == null) {
      return step1.isNotEmpty;
    }
    if (step1.length != step2.length) {
      return true;
    }
    for (int i = 0; i < step1.length; i++) {
      if (step1[i].desc != step2[i].desc || step1[i].done != step2[i].done) {
        return true;
      }
    }
    return false;
  }

  bool diffCheckedTimeList(List<DateTime>? time1, List<DateTime>? time2) {
    if (time1 == null) {
      return time2 != null && time2.isNotEmpty;
    }
    if (time2 == null) {
      return time1.isNotEmpty;
    }
    if (time1.length != time2.length) {
      return true;
    }
    for (int i = 0; i < time1.length; i++) {
      if (time1[i].millisecondsSinceEpoch != time2[i].millisecondsSinceEpoch) {
        return true;
      }
    }
    return false;
  }

  bool diff(WishData? wishData) {
    if (wishData == null) {
      return true;
    }
    return wishData.name != name ||
        wishData.wishType != wishType ||
        wishData.colorType != colorType ||
        wishData.note != note ||
        wishData.checkInTime != checkInTime ||
        wishData.periodDays != periodDays ||
        diffCheckedTimeList(wishData.checkedTimeList, checkedTimeList) ||
        wishData.endTime != endTime ||
        wishData.done != done ||
        wishData.paused != paused ||
        diffSteps(wishData.stepList, stepList) ||
        wishData.repeatCount != repeatCount ||
        wishData.actualRepeatCount != actualRepeatCount ||
        wishData.isSecret != isSecret;
  }

  static List<WishStep>? _parseStepList(String? stepList) {
    if (stepList == null) {
      return null;
    }
    List<dynamic> list = jsonDecode(stepList);
    return list.map((e) => WishStep.fromMap(e)).toList();
  }

  static List<DateTime>? _parseCheckedTimeList(String? checkedTimeList) {
    if (checkedTimeList == null) {
      return null;
    }
    List<dynamic> list = jsonDecode(checkedTimeList);
    return list
        .map((e) => DateTime.fromMillisecondsSinceEpoch(e * 1000))
        .toList();
  }

  factory WishData.fromMap(Map<String, dynamic> map) {
    return WishData(
      map[DatabaseHelper.filedName],
      id: map[DatabaseHelper.fieldColumnId],
      wishType: WishType.values[map[DatabaseHelper.fieldWishType]],
      colorType: ColorType.values[map[DatabaseHelper.fieldColorType]],
      note: map[DatabaseHelper.fieldNote],
      checkInTime:
          TimeUtils.fromCheckInTime(map[DatabaseHelper.fieldCheckInTime]),
      periodDays: map[DatabaseHelper.fieldPeriodDays],
      checkedTimeList: map[DatabaseHelper.fieldCheckedTimeList] == null
          ? null
          : _parseCheckedTimeList(map[DatabaseHelper.fieldCheckedTimeList]),
      endTime: TimeUtils.parseDbTime(map[DatabaseHelper.fieldEndTime]),
      done: map[DatabaseHelper.fieldDone] == 1,
      paused: map[DatabaseHelper.fieldPaused] == 1,
      stepList: _parseStepList(map[DatabaseHelper.fieldStepList]),
      repeatCount: map[DatabaseHelper.fieldRepeatCount],
      actualRepeatCount: map[DatabaseHelper.fieldActualRepeatCount],
      createdTime: TimeUtils.parseDbTime(map[DatabaseHelper.fieldCreatedTime]),
      modifiedTime:
          TimeUtils.parseDbTime(map[DatabaseHelper.fieldModifiedTime]),
    );
  }
}
