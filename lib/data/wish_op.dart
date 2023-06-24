import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/wish_localizations.dart';
import 'package:wish/data/data_base_helper.dart';
import 'package:wish/data/wish_data.dart';
import 'package:wish/utils/struct.dart';
import 'package:wish/utils/timeUtils.dart';
import 'package:wish/widgets/picker.dart';

enum WishOpType {
  create,
  delete,
  edit,
  done,
  pause,
  doneStep,
  checkIn,
  updateCount,
}

// 必须要记录的字段 wishId, wishName, wishType、time
// update: 修改了名字from-to、修改的字段
// doneStep: 步骤名字、done
//

class WishOp {
  final WishOpType opType; // type
  final DateTime time; // time
  final int wishId; // wishId
  final String wishName; // wishName
  final WishType wishType; // wishType
  final bool? isDone; // done
  final bool? isPaused;
  final OpEdit? opEdit; // edit
  final OpDoneStep? opDoneStep; // doneStep
  final OpRepeatCount? opRepeatCount; // updateCount

  WishOp(this.opType, this.time, this.wishId, this.wishName, this.wishType, this.opEdit, this.opDoneStep,
      this.opRepeatCount, this.isDone, this.isPaused);

  Map<String, dynamic> toMap() {
    return {
      DatabaseHelper.optionType: opType.index,
      DatabaseHelper.optionTime: time.millisecondsSinceEpoch ~/ 1000,
      DatabaseHelper.optionWishId: wishId,
      DatabaseHelper.optionWishName: wishName,
      DatabaseHelper.optionWishType: wishType.index,
      DatabaseHelper.optionEdit: opEdit?.toString(),
      DatabaseHelper.optionDoneStep: opDoneStep?.toString(),
      DatabaseHelper.optionRepeatCount: opRepeatCount?.toString(),
      DatabaseHelper.optionDone: isDone == null ? null : (isDone! ? 1 : 0),
      DatabaseHelper.optionPaused: isPaused == null ? null : (isPaused! ? 1 : 0),
    };
  }

  factory WishOp.fromMap(Map<String, dynamic> map) {
    return WishOp(
      WishOpType.values[map[DatabaseHelper.optionType]],
      DateTime.fromMillisecondsSinceEpoch(map[DatabaseHelper.optionTime] * 1000),
      map[DatabaseHelper.optionWishId],
      map[DatabaseHelper.optionWishName],
      WishType.values[map[DatabaseHelper.optionWishType]],
      map[DatabaseHelper.optionEdit] == null ? null : OpEdit.fromMap(map[DatabaseHelper.optionEdit]),
      map[DatabaseHelper.optionDoneStep] == null ? null : OpDoneStep.fromValue(map[DatabaseHelper.optionDoneStep]),
      map[DatabaseHelper.optionRepeatCount] == null
          ? null
          : OpRepeatCount.fromValue(map[DatabaseHelper.optionRepeatCount]),
      map[DatabaseHelper.optionDone] == null ? null : map[DatabaseHelper.optionDone] == 1,
      map[DatabaseHelper.optionPaused] == null ? null : map[DatabaseHelper.optionPaused] == 1,
    );
  }

  String getShowTime() {
    return time.toLocal().toString().substring(0, 16);
  }

  String getShowTitle1(BuildContext context, bool showLabelName) {
    var localizations = WishLocalizations.of(context)!;
    switch (opType) {
      case WishOpType.create:
        return '${localizations.opTitleCreateWish}${showLabelName ? '：$wishName' : ''}';
      case WishOpType.delete:
        return '${localizations.opTitleDelWish}${showLabelName ? '：$wishName' : ''}';
      case WishOpType.edit:
        return '${localizations.opTitleModifyWish}${showLabelName ? '：$wishName' : ''}';
      case WishOpType.done:
        return isDone! ? localizations.opTitleDoneWish : localizations.opTitleUndoneWish;
      case WishOpType.doneStep:
        return localizations.opTitleUpdatedSteps;
      case WishOpType.checkIn:
        return localizations.opTitleCheckIn;
      case WishOpType.updateCount:
        return localizations.opTitleUpdateCount;
      case WishOpType.pause:
        return isPaused! ? localizations.opTitlePauseCheckIn : localizations.opTitleResumeCheckIn;
    }
  }

  bool breakAddTitle(WishLocalizations localizations, int index, List<EditDesc> res, key, value) {
    if (index <= 2) {
      return false;
    }
    if (index == 3) {
      res.add(EditDesc('\n${localizations.opChangeFrom}'));
    }
    switch (key) {
      case EditType.name:
        res.add(EditDesc(localizations.opName, isKey: true));
        res.add(EditDesc(' '));
        break;
      case EditType.wishType:
        res.add(EditDesc(localizations.opType, isKey: true));
        res.add(EditDesc(' '));
        break;
      case EditType.colorType:
        res.add(EditDesc(localizations.opColor, isKey: true));
        res.add(EditDesc(' '));
        break;
      case EditType.note:
        res.add(EditDesc(localizations.opNote, isKey: true));
        res.add(EditDesc(' '));
        break;
      case EditType.checkInTime:
        res.add(EditDesc(localizations.opCheckInTime, isKey: true));
        res.add(EditDesc(' '));
        break;
      case EditType.checkInPeriod:
        res.add(EditDesc(localizations.opCheckInPeriod, isKey: true));
        res.add(EditDesc(' '));
        break;
      case EditType.endTime:
        res.add(EditDesc(localizations.opDeadline, isKey: true));
        res.add(EditDesc(' '));
        break;
      case EditType.stepList:
        res.add(EditDesc(localizations.opSteps, isKey: true));
        res.add(EditDesc(' '));
        break;
      case EditType.repeatCount:
        res.add(EditDesc(localizations.opRepeatCount, isKey: true));
        res.add(EditDesc(' '));
        break;
      case EditType.isSecret:
        // todo
        res.add(EditDesc('是否保密', isKey: true));
        res.add(EditDesc(' '));
        break;
    }
    return true;
  }

  _addPreInfo(WishLocalizations localizations, List<EditDesc> res, String key, {String? value}) {
    res.add(EditDesc('\n${localizations.opChangeFrom}'));
    res.add(EditDesc(key, isKey: true));
    res.add(EditDesc(localizations.opChangeTo));
    if (value != null) {
      res.add(EditDesc(value, isKey: true));
    }
  }

  Pair<List<EditDesc>, int>? getShowTitle2(BuildContext context) {
    var localizations = WishLocalizations.of(context)!;
    if (opEdit != null && opEdit!.editMap.isNotEmpty) {
      List<EditDesc> res = [];
      int index = 0;
      opEdit!.editMap.forEach((key, value) {
        switch (key) {
          case EditType.name:
            index++;
            if (breakAddTitle(localizations, index, res, key, value)) {
              break;
            }
            _addPreInfo(localizations, res, localizations.opName, value: value);
            break;
          case EditType.wishType:
            index++;
            if (breakAddTitle(localizations, index, res, key, value)) {
              break;
            }
            _addPreInfo(localizations, res, localizations.opType, value: WishType.values[value].name);
            break;
          case EditType.colorType:
            index++;
            if (breakAddTitle(localizations, index, res, key, value)) {
              break;
            }
            _addPreInfo(localizations, res, localizations.opColor);
            res.add(
                EditDesc(ColorType.values[value].getShowStr(context), isKey: true, color: ColorType.values[value].toColor()));
            break;
          case EditType.note:
            index++;
            if (breakAddTitle(localizations, index, res, key, value)) {
              break;
            }
            res.add(EditDesc('\n${localizations.opModifyNote}'));
            break;
          case EditType.checkInTime:
            index++;
            if (breakAddTitle(localizations, index, res, key, value)) {
              break;
            }
            _addPreInfo(localizations, res, localizations.opCheckInTime, value: TimeUtils.getShowTimeFromTimeStr(value));
            break;
          case EditType.checkInPeriod:
            index++;
            if (breakAddTitle(localizations, index, res, key, value)) {
              break;
            }
            _addPreInfo(localizations, res, localizations.opCheckInPeriod, value: '$value天');
            break;
          case EditType.endTime:
            index++;
            if (breakAddTitle(localizations, index, res, key, value)) {
              break;
            }
            _addPreInfo(localizations, res, localizations.opDeadline, value: TimeUtils.getShowDateFromTimeStamp(value));
            break;
          case EditType.stepList:
            index++;
            if (breakAddTitle(localizations, index, res, key, value)) {
              break;
            }
            res.add(EditDesc('\n${localizations.opModifiedStep}'));
            break;
          case EditType.repeatCount:
            index++;
            if (breakAddTitle(localizations, index, res, key, value)) {
              break;
            }
            _addPreInfo(localizations, res, localizations.opRepeatCount, value: value.toString());
            break;
          case EditType.isSecret:
            index++;
            if (breakAddTitle(localizations, index, res, key, value)) {
              break;
            }
            // todo
            res.add(EditDesc('\n修改了心愿是否保密为'));
            // res.add(EditDesc(value, isKey: true));
            break;
        }
      });
      if (res.isEmpty) {
        return null;
      }
      // 第一个不换行
      final firstDesc = EditDesc(res[0].value.substring(1));
      res[0] = firstDesc;
      if (index > 2) {
        res.add(EditDesc(localizations.opOtherInfo));
      }

      return Pair(res, index > 2 ? 3 : index);
    }
    if (opDoneStep != null) {
      List<EditDesc> res = [];
      res.add(EditDesc(opDoneStep!.done ? localizations.opDoneStep : localizations.opUndoneStep, isKey: true));
      res.add(EditDesc('${localizations.opSteps}${opDoneStep!.index + 1}'));
      return Pair(res, 1);
    }
    if (opRepeatCount != null) {
      List<EditDesc> res = [];
      res.add(EditDesc('${opRepeatCount!.fromCount}', isKey: true));
      res.add(EditDesc(' -> '));
      res.add(EditDesc('${opRepeatCount!.toCount}', isKey: true));
      return Pair(res, 1);
    }
    return null;
  }
}

class EditDesc {
  final String value;
  final bool isKey;
  final Color? color;

  EditDesc(this.value, {this.isKey = false, this.color});
}

enum EditType {
  name,
  wishType,
  colorType,
  note,
  checkInTime,
  checkInPeriod,
  // checkedTimeList,
  endTime,
  // done,
  stepList,
  repeatCount,
  // actualRepeatCount,
  isSecret,
  // createdTime,
  // modifiedTime,
}

class OpEdit {
  final Map<dynamic, dynamic> editMap;

  OpEdit(this.editMap);

  @override
  String toString() {
    return json.encode(editMap.map((key, value) => MapEntry(key.index.toString(), value)));
  }

  factory OpEdit.fromMap(String value) {
    return OpEdit(
      json.decode(value).map((key, value) => MapEntry(EditType.values[int.parse(key)], value)),
    );
  }
}

class OpDoneStep {
  final int index;
  final bool done;

  OpDoneStep(this.index, this.done);

  Map<String, dynamic> toMap() {
    return {
      'index': index,
      'done': done,
    };
  }

  @override
  String toString() {
    return json.encode(toMap());
  }

  factory OpDoneStep.fromValue(String value) {
    final map = json.decode(value);
    return OpDoneStep(map['index'], map['done']);
  }
}

class OpRepeatCount {
  final int fromCount;
  final int toCount;

  OpRepeatCount(this.fromCount, this.toCount);

  toMap() {
    return {
      'from': fromCount,
      'to': toCount,
    };
  }

  @override
  String toString() {
    return json.encode(toMap());
  }

  factory OpRepeatCount.fromValue(String value) {
    final map = json.decode(value);
    return OpRepeatCount(map['from'], map['to']);
  }
}
