import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:wish/data/data_base_helper.dart';
import 'package:wish/data/wish_data.dart';
import 'package:wish/utils/timeUtils.dart';
import 'package:wish/widgets/picker.dart';

enum WishOpType {
  create,
  delete,
  edit,
  done,
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
  final OpEdit? opEdit; // edit
  final OpDoneStep? opDoneStep; // doneStep
  final OpRepeatCount? opRepeatCount; // updateCount

  WishOp(this.opType, this.time, this.wishId, this.wishName, this.wishType, this.opEdit,
      this.opDoneStep, this.opRepeatCount, this.isDone);

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
    };
  }

  factory WishOp.fromMap(Map<String, dynamic> map) {
    return WishOp(
      WishOpType.values[map[DatabaseHelper.optionType]],
      DateTime.fromMillisecondsSinceEpoch(map[DatabaseHelper.optionTime] * 1000),
      map[DatabaseHelper.optionWishId],
      map[DatabaseHelper.optionWishName],
      WishType.values[map[DatabaseHelper.optionWishType]],
      map[DatabaseHelper.optionEdit] == null
          ? null
          : OpEdit.fromMap(map[DatabaseHelper.optionEdit]),
      map[DatabaseHelper.optionDoneStep] == null
          ? null
          : OpDoneStep.fromValue(map[DatabaseHelper.optionDoneStep]),
      map[DatabaseHelper.optionRepeatCount] == null
          ? null
          : OpRepeatCount.fromValue(map[DatabaseHelper.optionRepeatCount]),
      map[DatabaseHelper.optionDone] == null ? null : map[DatabaseHelper.optionDone] == 1,
    );
  }

  String getShowTime() {
    return time.toLocal().toString().substring(0, 16);
  }

  String getShowTitle1() {
    switch (opType) {
      case WishOpType.create:
        return '许下了心愿：$wishName';
      case WishOpType.delete:
        return '丢下了心愿：$wishName';
      case WishOpType.edit:
        return '修改了心愿：$wishName';
      case WishOpType.done:
        return isDone! ? '完成了心愿' : '取消完成心愿';
      case WishOpType.doneStep:
        return '更新了步骤';
      case WishOpType.checkIn:
        return '打卡一次';
      case WishOpType.updateCount:
        return '更新了次数';
    }
  }

  bool breakAddTitle(int index, List<EditDesc> res, key, value) {
    if (index <= 2) {
      return false;
    }
    if (index == 3) {
      res.add(EditDesc('\n修改了'));
    }
    switch (key) {
      case EditType.name:
        res.add(EditDesc('名字', isKey: true));
        res.add(EditDesc(' '));
        break;
      case EditType.wishType:
        res.add(EditDesc('类型', isKey: true));
        res.add(EditDesc(' '));
        break;
      case EditType.colorType:
        res.add(EditDesc('颜色', isKey: true));
        res.add(EditDesc(' '));
        break;
      case EditType.note:
        res.add(EditDesc('备注', isKey: true));
        res.add(EditDesc(' '));
        break;
      case EditType.checkInTime:
        res.add(EditDesc('打卡时间', isKey: true));
        res.add(EditDesc(' '));
        break;
      case EditType.checkInPeriod:
        res.add(EditDesc('打卡周期', isKey: true));
        res.add(EditDesc(' '));
        break;
      case EditType.endTime:
        res.add(EditDesc('截止时间', isKey: true));
        res.add(EditDesc(' '));
        break;
      case EditType.stepList:
        res.add(EditDesc('步骤', isKey: true));
        res.add(EditDesc(' '));
        break;
      case EditType.repeatCount:
        res.add(EditDesc('次数', isKey: true));
        res.add(EditDesc(' '));
        break;
      case EditType.isSecret:
        res.add(EditDesc('是否保密', isKey: true));
        res.add(EditDesc(' '));
        break;
    }
    return true;
  }

  _addPreInfo(List<EditDesc> res, String key, {String? value}) {
    res.add(EditDesc('\n修改了'));
    res.add(EditDesc(key, isKey: true));
    res.add(EditDesc('为'));
    if (value != null) {
      res.add(EditDesc(value, isKey: true));
    }
  }

  List<EditDesc>? getShowTitle2() {
    if (opEdit != null && opEdit!.editMap.isNotEmpty) {
      List<EditDesc> res = [];
      int index = 0;
      opEdit!.editMap.forEach((key, value) {
        switch (key) {
          case EditType.name:
            index++;
            if (breakAddTitle(index, res, key, value)) {
              break;
            }
            _addPreInfo(res, '名字', value: value);
            break;
          case EditType.wishType:
            index++;
            if (breakAddTitle(index, res, key, value)) {
              break;
            }
            _addPreInfo(res, '类型', value: WishType.values[value].name);
            break;
          case EditType.colorType:
            index++;
            if (breakAddTitle(index, res, key, value)) {
              break;
            }
            _addPreInfo(res, '颜色');
            res.add(EditDesc(ColorType.values[value].toString(),
                isKey: true, color: ColorType.values[value].toColor()));
            break;
          case EditType.note:
            index++;
            if (breakAddTitle(index, res, key, value)) {
              break;
            }
            res.add(EditDesc('\n修改了备注'));
            break;
          case EditType.checkInTime:
            index++;
            if (breakAddTitle(index, res, key, value)) {
              break;
            }
            _addPreInfo(res, '打卡时间', value: TimeUtils.getShowDateFromTimeStr(value));
            break;
          case EditType.checkInPeriod:
            index++;
            if (breakAddTitle(index, res, key, value)) {
              break;
            }
            _addPreInfo(res, '打卡周期', value: '$value天');
            break;
          case EditType.endTime:
            index++;
            if (breakAddTitle(index, res, key, value)) {
              break;
            }
            _addPreInfo(res, '截止时间', value: TimeUtils.getShowDateFromTimeStr(value));
            break;
          case EditType.stepList:
            index++;
            if (breakAddTitle(index, res, key, value)) {
              break;
            }
            res.add(EditDesc('\n修改了步骤'));
            break;
          case EditType.repeatCount:
            index++;
            if (breakAddTitle(index, res, key, value)) {
              break;
            }
            _addPreInfo(res, '重复次数', value: value.toString());
            break;
          case EditType.isSecret:
            index++;
            if (breakAddTitle(index, res, key, value)) {
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
        res.add(EditDesc('等信息'));
      }

      return res;
    }
    if (opDoneStep != null) {
      List<EditDesc> res = [];
      res.add(EditDesc(opDoneStep!.done ? '完成了' : '取消完成了', isKey: true));
      res.add(EditDesc('步骤${opDoneStep!.index + 1}'));
      return res;
    }
    if (opRepeatCount != null) {
      List<EditDesc> res = [];
      res.add(EditDesc('${opRepeatCount!.fromCount}', isKey: true));
      res.add(EditDesc(' -> '));
      res.add(EditDesc('${opRepeatCount!.toCount}', isKey: true));
      return res;
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
    print('---value：$value');
    print(
        '---eee:${json.decode(value).map((key, value) => MapEntry(EditType.values[int.parse(key)], value))}');
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
