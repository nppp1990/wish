import 'dart:async';
import 'dart:convert';

import 'package:wish/data/wish_data.dart';
import 'package:wish/data/wish_op.dart';
import 'package:wish/data/wish_review.dart';
import 'package:wish/utils/struct.dart';
import 'package:wish/utils/timeUtils.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  static const String dbName = 'wish';

  // 根据WishData的字段名定义表名和字段名
  static const String tableWish = 'wish';
  static const String fieldColumnId = '_id';
  static const String filedName = 'name';
  static const String fieldWishType = 'wishType';
  static const String fieldColorType = 'colorType';
  static const String fieldNote = 'note';
  static const String fieldCheckInTime = 'checkInTime';
  static const String fieldPeriodDays = 'periodDays';
  static const String fieldCheckedTimeList = 'checkedTimeList';
  static const String fieldEndTime = 'endTime';
  static const String fieldDone = 'done';
  static const String fieldPaused = 'paused';
  static const String fieldStepList = 'stepList';
  static const String fieldRepeatCount = 'repeatCount';
  static const String fieldActualRepeatCount = 'actualRepeatCount';
  static const String fieldIsSecret = 'isSecret';
  static const String fieldCreatedTime = 'createdTime';
  static const String fieldModifiedTime = 'modifiedTime';

  static const String tableWishOption = 'wishOption';
  static const String optionId = '_id';
  static const String optionType = 'type';
  static const String optionTime = 'time';
  static const String optionWishId = 'wishId';
  static const String optionWishName = 'name';
  static const String optionWishType = 'wishType';
  static const String optionEdit = 'edit';
  static const String optionDoneStep = 'doneStep';
  static const String optionRepeatCount = 'repeatCount';
  static const String optionDone = 'done';
  static const String optionPaused = 'paused';

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await _initDB('$dbName.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future<void> _createDB(Database db, int version) async {
    // 根据WishData 创建表
    await db.execute('''
      CREATE TABLE $tableWish (
        $fieldColumnId INTEGER PRIMARY KEY AUTOINCREMENT,
        $filedName TEXT not null,
        $fieldWishType INTEGER not null,
        $fieldColorType INTEGER not null,
        $fieldNote TEXT,
        $fieldCheckInTime INTEGER,
        $fieldCheckedTimeList TEXT,
        $fieldPeriodDays INTEGER,
        $fieldEndTime INTEGER,
        $fieldDone INTEGER,
        $fieldPaused INTEGER,
        $fieldStepList TEXT,
        $fieldRepeatCount INTEGER,
        $fieldActualRepeatCount INTEGER,
        $fieldIsSecret INTEGER,
        $fieldCreatedTime INTEGER,
        $fieldModifiedTime INTEGER
      )
    ''');
    // 创建表tableWishOption
    await db.execute('''
      CREATE TABLE $tableWishOption (
        $optionId INTEGER PRIMARY KEY AUTOINCREMENT,
        $optionType INTEGER not null,
        $optionTime INTEGER not null,
        $optionWishId INTEGER not null,
        $optionWishName TEXT not null,
        $optionWishType INTEGER not null,
        $optionEdit TEXT,
        $optionDoneStep TEXT,
        $optionRepeatCount TEXT,
        $optionDone INTEGER,
        $optionPaused INTEGER
      )
    ''');
  }

  Future<int> deleteWish(WishData wishData) async {
    try {
      final db = await database;
      return await db.transaction((txn) async {
        var res = await txn.delete(tableWish, where: '$fieldColumnId = ?', whereArgs: [wishData.id]);
        // 插入一条删除记录
        await txn.insert(tableWishOption, {
          optionType: WishOpType.delete.index,
          ...getOpGeneralMap(wishData, DateTime.now()),
        });
        return res;
      });
    } catch (e) {
      print('deleteWish error: $e');
      return -1;
    }
  }

  // >0 表示成功
  Future<int> insertWish(WishData wishData) async {
    try {
      final db = await database;
      return await db.transaction((txn) async {
        final id = await txn.insert(tableWish, wishData.toMap());
        // 插入一条create记录
        await txn.insert(tableWishOption, {
          optionType: WishOpType.create.index,
          ...getOpGeneralMap(wishData, wishData.createdTime!, wishId: id),
        });
        return id;
      });
    } catch (e) {
      print('insertWish error: $e');
      return -1;
    }
  }

  Map<String, dynamic> getOpGeneralMap(WishData wishData, DateTime nowTime, {int? wishId}) {
    return {
      optionTime: nowTime.millisecondsSinceEpoch ~/ 1000,
      optionWishId: wishId ?? wishData.id,
      optionWishName: wishData.name,
      optionWishType: wishData.wishType.index,
    };
  }

  Future<int> updateActualRepeatCount(WishData wishData, int? oldCount, int newCount) async {
    try {
      final db = await database;
      final nowTime = DateTime.now();
      // 更新fieldActualRepeatCount和fieldModifiedTime
      return await db.transaction((txn) async {
        final res = await txn.rawUpdate('''
        UPDATE $tableWish
          SET $fieldActualRepeatCount = ?, $fieldModifiedTime = ?
          WHERE $fieldColumnId = ?
          ''', [newCount, TimeUtils.getTimeStamp(nowTime), wishData.id]);
        // 插入一条update记录
        await txn.insert(tableWishOption, {
          optionType: WishOpType.updateCount.index,
          optionRepeatCount: OpRepeatCount(
            oldCount ?? 0,
            newCount,
          ).toString(),
          ...getOpGeneralMap(wishData, nowTime),
        });
        return res;
      });
    } catch (e) {
      print('updateActualRepeatCount error: $e');
      return -1;
    }
  }

  // 返回update count >0 表示成功
  Future<int> updateWish(WishData wishData, WishData oldWish) async {
    Map<EditType, dynamic> diffRes = {};
    if (wishData.name != oldWish.name) {
      diffRes[EditType.name] = wishData.name;
    }
    if (wishData.wishType != oldWish.wishType) {
      diffRes[EditType.wishType] = wishData.wishType.index;
    }
    if (wishData.endTime != oldWish.endTime) {
      diffRes[EditType.endTime] = wishData.endTime!.millisecondsSinceEpoch ~/ 1000;
    }
    if (wishData.checkInTime != oldWish.checkInTime) {
      diffRes[EditType.checkInTime] = TimeUtils.getCheckInTime(wishData.checkInTime);
    }
    if (wishData.periodDays != oldWish.periodDays) {
      diffRes[EditType.checkInPeriod] = wishData.periodDays;
    }
    // if (wishData.checkedTimeList != oldWish.checkedTimeList) {
    //   diffRes[EditType.end] = wishData.checkedTimeList;
    // }

    // if (wishData.done != oldWish.done) {
    //   diffRes[EditType.done] = wishData.done;
    // }
    if (WishData.diffSteps(wishData.stepList, oldWish.stepList)) {
      diffRes[EditType.stepList] = wishData.stepList?.length ?? 0;
    }
    if (wishData.repeatCount != oldWish.repeatCount) {
      diffRes[EditType.repeatCount] = wishData.repeatCount;
    }
    if (wishData.isSecret != oldWish.isSecret) {
      diffRes[EditType.isSecret] = wishData.isSecret;
    }
    if (wishData.colorType != oldWish.colorType) {
      diffRes[EditType.colorType] = wishData.colorType.index;
    }
    if (wishData.note != oldWish.note) {
      diffRes[EditType.note] = wishData.note;
    }
    // print('---diff:$diffRes');

    try {
      final db = await database;
      return await db.transaction((txn) async {
        final res =
            await txn.update(tableWish, wishData.toMap(), where: '$fieldColumnId = ?', whereArgs: [wishData.id]);
        // 插入一条update记录
        await txn.insert(tableWishOption, {
          optionType: WishOpType.edit.index,
          optionEdit: OpEdit(diffRes).toString(),
          ...getOpGeneralMap(wishData, wishData.modifiedTime!),
        });
        return res;
      });
    } catch (e) {
      print('update wish error:$e');
      return -1;
    }
  }

  Future<int> handleDoneOp(WishData wishData, bool done) async {
    try {
      final db = await database;
      final nowTime = DateTime.now();
      return await db.transaction((txn) async {
        await txn.rawUpdate('''
        UPDATE $tableWish
          SET $fieldDone = ?, $fieldModifiedTime = ?
          WHERE $fieldColumnId = ?
          ''', [done ? 1 : 0, TimeUtils.getTimeStamp(nowTime), wishData.id]);
        // 插入一条done操作
        return await txn.insert(tableWishOption, {
          optionType: WishOpType.done.index,
          optionDone: done,
          ...getOpGeneralMap(wishData, nowTime),
        });
      });
    } catch (e) {
      print('handle done op error:$e');
      return -1;
    }
  }

  Future<int> handlePauseOp(WishData wishData, bool paused) async {
    try {
      final db = await database;
      final nowTime = DateTime.now();
      return await db.transaction((txn) async {
        await txn.rawUpdate('''
        UPDATE $tableWish
          SET $fieldPaused = ?, $fieldModifiedTime = ?
          WHERE $fieldColumnId = ?
          ''', [paused ? 1 : 0, TimeUtils.getTimeStamp(nowTime), wishData.id]);
        // 插入一条done操作
        return await txn.insert(tableWishOption, {
          optionType: WishOpType.pause.index,
          optionPaused: paused,
          ...getOpGeneralMap(wishData, nowTime),
        });
      });
    } catch (e) {
      print('handle paused op error:$e');
      return -1;
    }
  }

  Future<int> handleDoneStep(WishData wishData, List<WishStep> stepList, int index) async {
    try {
      final db = await database;
      final nowTime = DateTime.now();
      return await db.transaction((txn) async {
        await txn.rawUpdate('''
        UPDATE $tableWish
          SET $fieldModifiedTime = ?, $fieldStepList = ?
          WHERE $fieldColumnId = ?
          ''', [TimeUtils.getTimeStamp(nowTime), json.encode(stepList.map((e) => e.toMap()).toList()), wishData.id]);

        return await txn.insert(tableWishOption, {
          optionType: WishOpType.doneStep.index,
          optionDoneStep: OpDoneStep(index, stepList[index].done).toString(),
          ...getOpGeneralMap(wishData, nowTime),
        });
      });
    } catch (e) {
      return -1;
    }
  }

  Future<int> handleCheckIn(WishData wishData) async {
    try {
      final db = await database;
      final nowTime = DateTime.now();
      List<DateTime> checkedTimeList = wishData.checkedTimeList ?? [];
      checkedTimeList.add(nowTime);

      return await db.transaction((txn) async {
        await txn.rawUpdate('''
        UPDATE $tableWish
          SET $fieldModifiedTime = ?, $fieldCheckedTimeList = ?
          WHERE $fieldColumnId = ?
          ''', [
          TimeUtils.getTimeStamp(nowTime),
          json.encode(checkedTimeList.map((e) => TimeUtils.getDbTime(e)).toList()),
          wishData.id
        ]);

        return await txn.insert(tableWishOption, {
          optionType: WishOpType.checkIn.index,
          ...getOpGeneralMap(wishData, nowTime),
        });
      });
    } catch (e) {
      return -1;
    }
  }

  Future<int> handleUpdateRepeat(WishData wishData, int oldCount, int count) async {
    // 插入一条doneStep操作
    try {
      final db = await database;
      final nowTime = DateTime.now();
      return await db.transaction((txn) async {
        await txn.rawUpdate('''
        UPDATE $tableWish
          SET $fieldModifiedTime = ?, $fieldActualRepeatCount = ?
          WHERE $fieldColumnId = ?
          ''', [TimeUtils.getTimeStamp(nowTime), count, wishData.id]);

        return await txn.insert(tableWishOption, {
          optionType: WishOpType.updateCount.index,
          optionRepeatCount: OpRepeatCount(oldCount, count).toString(),
          ...getOpGeneralMap(wishData, nowTime),
        });
      });
    } catch (e) {
      print('update repeat error:$e');
      return -1;
    }
  }

  String getOrderBy(SortType sortType, bool isAsc) {
    switch (sortType) {
      case SortType.name:
        return '$filedName ${isAsc ? 'ASC' : 'DESC'}';
      case SortType.modifiedTime:
        return '$fieldModifiedTime ${isAsc ? 'ASC' : 'DESC'}';
      case SortType.createdTime:
      default:
        return '$fieldCreatedTime ${isAsc ? 'ASC' : 'DESC'}';
    }
  }

  Future<List<WishOp>?> getOpListByWish(WishData wishData) async {
    try {
      final db = await database;
      final result = await db.query(tableWishOption,
          where: '$optionWishId = ?', whereArgs: [wishData.id], orderBy: '$optionTime DESC');
      return result.map((json) => WishOp.fromMap(json)).toList();
    } catch (e) {
      return null;
    }
  }

  Future<List<WishData>?> getAllWish(SortType sortType, bool isAsc) async {
    try {
      final db = await database;
      final result = await db.query(tableWish, orderBy: getOrderBy(sortType, isAsc));
      return result.map((json) => WishData.fromMap(json)).toList();
    } catch (e) {
      print('---getAllWish error:$e');
      return null;
    }
  }

  Future<WishData?> getWishById(int id) async {
    try {
      final db = await database;
      final result = await db.query(tableWish, where: '$fieldColumnId = ?', whereArgs: [id]);
      return result.map((json) => WishData.fromMap(json)).toList()[0];
    } catch (e) {
      return null;
    }
  }

  Future<List<WishData>?> getWishListByType(WishType type, SortType sortType, bool isAsc) async {
    try {
      final db = await database;
      final result = await db.query(tableWish,
          where: '$fieldWishType = ?', whereArgs: [type.index], orderBy: getOrderBy(sortType, isAsc));
      return result.map((json) => WishData.fromMap(json)).toList();
    } catch (e) {
      return null;
    }
  }

  Future<List<WishData>?> getWishDoneList(SortType sortType, bool isAsc) async {
    try {
      final db = await database;
      final result =
          await db.query(tableWish, where: '$fieldDone = ?', whereArgs: [1], orderBy: getOrderBy(sortType, isAsc));
      return result.map((json) => WishData.fromMap(json)).toList();
    } catch (e) {
      return null;
    }
  }

  getWishStatus() async {
    final db = await database;
    var time1 = DateTime.now().millisecondsSinceEpoch;
    var list = await getAllWish(SortType.modifiedTime, false);
    var totalCount2 = 0;
    var doneCount2 = 0;
    var delayCount = 0;
    for (var wish in list!) {
      totalCount2++;
      if (wish.done) {
        doneCount2++;
      }
    }
    print('totalCount:$totalCount2, doneCount:$doneCount2, deleteCount:');

    print('---get1:${DateTime.now().millisecondsSinceEpoch - time1}');
    var time2 = DateTime.now().millisecondsSinceEpoch;
    var totalCount = Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM $tableWish'));
    var doneCount = Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM $tableWish WHERE $fieldDone = 1'));
    // var deleteCount = Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM $tableWishOption WHERE $optionType = ${WishOpType.delete.index}'));
    print('totalCount:$totalCount, doneCount:$doneCount, deleteCount:');
    print('---get2:${DateTime.now().millisecondsSinceEpoch - time2}');
  }

  Future<Pair<List<WishData>, List<WishOp>>?> getReviewInfo(DateTime? fromTime, DateTime? toTime) async {
    final db = await database;
    try {
      return await db.transaction((txn) async {
        final res1 = await txn.query(tableWish);
        var wishList = res1.map((json) => WishData.fromMap(json)).toList();

        // fromTime到toTime之间的操作、排除掉edit
        final String where;
        final List<int?> whereArgs;
        if (fromTime != null && toTime != null) {
          where = '$optionTime >= ? AND $optionTime <= ? AND $optionType != ?';
          whereArgs = [
            TimeUtils.getTimeStamp(fromTime),
            TimeUtils.getTimeStamp(toTime),
            WishOpType.edit.index,
          ];
        } else {
          where = '$optionType != ?';
          whereArgs = [
            WishOpType.edit.index,
          ];
        }
        final res2 = await txn.query(tableWishOption, where: where, whereArgs: whereArgs, orderBy: '$optionTime DESC');
        final opList = res2.map((json) => WishOp.fromMap(json)).toList();
        return Pair(wishList, opList);
      });
    } catch (e) {
      return null;
    }
  }
}
