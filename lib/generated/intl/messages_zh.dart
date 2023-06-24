// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a zh locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'zh';

  static String m0(day) => "每 ${day} 天一次";

  static String m1(count) => "创建 ${count}";

  static String m2(count) => "删除 ${count}";

  static String m3(count) => "完成 ${count}";

  static String m4(count) => "暂停 ${count}";

  static String m5(count) => "重启 ${count}";

  static String m6(day) => "心愿已过期${day}天";

  static String m7(day) => "心愿剩余${day}天";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "afterTomorrow": MessageLookupByLibrary.simpleMessage("后天"),
        "allWish": MessageLookupByLibrary.simpleMessage("所有心愿"),
        "beforeYesterday": MessageLookupByLibrary.simpleMessage("前天"),
        "cancel": MessageLookupByLibrary.simpleMessage("取消"),
        "checkInCount": MessageLookupByLibrary.simpleMessage("已打卡次数"),
        "checkInPeriodHint": MessageLookupByLibrary.simpleMessage("选择打卡间隔天数"),
        "checkInPeriodLabel": MessageLookupByLibrary.simpleMessage("间隔天数："),
        "checkInTaskLabel": MessageLookupByLibrary.simpleMessage("打卡任务"),
        "createCheckInTaskTitle":
            MessageLookupByLibrary.simpleMessage("创建打卡任务"),
        "createRepeatTaskTitle": MessageLookupByLibrary.simpleMessage("创建重复任务"),
        "createWishTitle": MessageLookupByLibrary.simpleMessage("创建心愿"),
        "createdAt": MessageLookupByLibrary.simpleMessage("创建于"),
        "custom": MessageLookupByLibrary.simpleMessage("自定义"),
        "days": MessageLookupByLibrary.simpleMessage("天"),
        "delete": MessageLookupByLibrary.simpleMessage("删除"),
        "desireLabel": MessageLookupByLibrary.simpleMessage("心想事成"),
        "dialogExitContent":
            MessageLookupByLibrary.simpleMessage("退出后，当前编辑内容将不会被保存"),
        "dialogExitTitle": MessageLookupByLibrary.simpleMessage("是否退出编辑？"),
        "doneLabel": MessageLookupByLibrary.simpleMessage("已完成"),
        "edit": MessageLookupByLibrary.simpleMessage("编辑"),
        "editErrorForName": MessageLookupByLibrary.simpleMessage("请填写心愿名"),
        "editErrorForPeriod": MessageLookupByLibrary.simpleMessage("请填写间隔天数"),
        "editErrorForSteps": MessageLookupByLibrary.simpleMessage("心愿步骤不能为空"),
        "editErrorForTime": MessageLookupByLibrary.simpleMessage("请填写打卡时间"),
        "editWishTitle": MessageLookupByLibrary.simpleMessage("编辑心愿"),
        "egLabel": MessageLookupByLibrary.simpleMessage("例如："),
        "endTimePickerHint": MessageLookupByLibrary.simpleMessage("选择心愿截止日期"),
        "endTimePickerLabel": MessageLookupByLibrary.simpleMessage("截止日期："),
        "exit": MessageLookupByLibrary.simpleMessage("退出"),
        "helloWorld": MessageLookupByLibrary.simpleMessage("哈哈哈哈"),
        "inputCheckInHint": MessageLookupByLibrary.simpleMessage("选择打卡时间"),
        "inputCheckInLabel": MessageLookupByLibrary.simpleMessage("打卡时间："),
        "localeEn": MessageLookupByLibrary.simpleMessage("英文"),
        "menuCheckIn": MessageLookupByLibrary.simpleMessage("打卡"),
        "menuCreateCheckInTask": MessageLookupByLibrary.simpleMessage("创建打卡任务"),
        "menuCreateRepeatTask": MessageLookupByLibrary.simpleMessage("创建重复任务"),
        "menuCreateWish": MessageLookupByLibrary.simpleMessage("创建心愿"),
        "menuDelete": MessageLookupByLibrary.simpleMessage("删除"),
        "menuDone": MessageLookupByLibrary.simpleMessage("完成"),
        "menuEdit": MessageLookupByLibrary.simpleMessage("编辑"),
        "menuTimes": MessageLookupByLibrary.simpleMessage("次数"),
        "menuUndone": MessageLookupByLibrary.simpleMessage("取消完成"),
        "modifiedAt": MessageLookupByLibrary.simpleMessage("修改于"),
        "nameInputHint": MessageLookupByLibrary.simpleMessage("写一个好记的心愿名"),
        "nameInputLabel": MessageLookupByLibrary.simpleMessage("心愿名"),
        "noteInputHint":
            MessageLookupByLibrary.simpleMessage("记录这个愿望的初衷，或者写几句激励自己的话吧"),
        "noteInputLabel": MessageLookupByLibrary.simpleMessage("备注"),
        "opBeginTime": MessageLookupByLibrary.simpleMessage("开始时间"),
        "opCardTitle": MessageLookupByLibrary.simpleMessage("进度更新"),
        "opChangeFrom": MessageLookupByLibrary.simpleMessage("修改了"),
        "opChangeTo": MessageLookupByLibrary.simpleMessage("为"),
        "opCheckInPeriod": MessageLookupByLibrary.simpleMessage("打卡周期"),
        "opCheckInTime": MessageLookupByLibrary.simpleMessage("打卡时间"),
        "opCheckInTimeLabel": MessageLookupByLibrary.simpleMessage("打卡时间"),
        "opCheckTimesLabel": MessageLookupByLibrary.simpleMessage("打卡次数"),
        "opCheckedIn": MessageLookupByLibrary.simpleMessage("已打卡"),
        "opColor": MessageLookupByLibrary.simpleMessage("颜色"),
        "opDeadline": MessageLookupByLibrary.simpleMessage("截止时间"),
        "opDoing": MessageLookupByLibrary.simpleMessage("进行中"),
        "opDoneStep": MessageLookupByLibrary.simpleMessage("完成了"),
        "opDoneTimes": MessageLookupByLibrary.simpleMessage("已完成次数"),
        "opEndTime": MessageLookupByLibrary.simpleMessage("截止时间"),
        "opHistoryTitle": MessageLookupByLibrary.simpleMessage("心愿足迹"),
        "opLastCheckInLabel": MessageLookupByLibrary.simpleMessage("上次打卡"),
        "opModifiedStep": MessageLookupByLibrary.simpleMessage("修改了步骤"),
        "opModifyNote": MessageLookupByLibrary.simpleMessage("修改了备注"),
        "opName": MessageLookupByLibrary.simpleMessage("名字"),
        "opNoCheckedIn": MessageLookupByLibrary.simpleMessage("未打卡"),
        "opNoEnd": MessageLookupByLibrary.simpleMessage("无期限"),
        "opNote": MessageLookupByLibrary.simpleMessage("备注"),
        "opOtherInfo": MessageLookupByLibrary.simpleMessage("等信息"),
        "opPauseCheckInLabel": MessageLookupByLibrary.simpleMessage("暂停打卡"),
        "opPauseTip": MessageLookupByLibrary.simpleMessage("暂停后，将不会再提醒打卡"),
        "opPaused": MessageLookupByLibrary.simpleMessage("已暂停"),
        "opPeriodDetail": m0,
        "opPeriodLabel": MessageLookupByLibrary.simpleMessage("打卡间隔"),
        "opRepeatCount": MessageLookupByLibrary.simpleMessage("重复次数"),
        "opSteps": MessageLookupByLibrary.simpleMessage("步骤"),
        "opStepsTip": MessageLookupByLibrary.simpleMessage(
            "未设置计划步骤，可点击右下角按钮、直接完成或取消完成心愿"),
        "opSuffix": MessageLookupByLibrary.simpleMessage("了"),
        "opTargetTimes": MessageLookupByLibrary.simpleMessage("目标次数"),
        "opTimeCardTitle": MessageLookupByLibrary.simpleMessage("心愿时间"),
        "opTimeContinuous": MessageLookupByLibrary.simpleMessage("已持续"),
        "opTimesUnit": MessageLookupByLibrary.simpleMessage("次"),
        "opTitleCheckIn": MessageLookupByLibrary.simpleMessage("打卡一次"),
        "opTitleCreateWish": MessageLookupByLibrary.simpleMessage("许下了心愿"),
        "opTitleDelWish": MessageLookupByLibrary.simpleMessage("丢下了心愿"),
        "opTitleDoneWish": MessageLookupByLibrary.simpleMessage("完成了心愿"),
        "opTitleModifyWish": MessageLookupByLibrary.simpleMessage("修改了心愿"),
        "opTitlePauseCheckIn": MessageLookupByLibrary.simpleMessage("暂停了打卡任务"),
        "opTitleResumeCheckIn": MessageLookupByLibrary.simpleMessage("恢复了打卡任务"),
        "opTitleUndoneWish": MessageLookupByLibrary.simpleMessage("取消完成心愿"),
        "opTitleUpdateCount": MessageLookupByLibrary.simpleMessage("更新了次数"),
        "opTitleUpdatedSteps": MessageLookupByLibrary.simpleMessage("更新了步骤"),
        "opTodayCheckIn": MessageLookupByLibrary.simpleMessage("今日打卡"),
        "opType": MessageLookupByLibrary.simpleMessage("类型"),
        "opUndoneStep": MessageLookupByLibrary.simpleMessage("取消完成了"),
        "radioCheckIn": MessageLookupByLibrary.simpleMessage("打卡任务"),
        "radioRepeat": MessageLookupByLibrary.simpleMessage("重复任务"),
        "radioWish": MessageLookupByLibrary.simpleMessage("心想事成"),
        "repeatTaskLabel": MessageLookupByLibrary.simpleMessage("重复任务"),
        "reviewCreateLabel": m1,
        "reviewDelayWish": MessageLookupByLibrary.simpleMessage("已延期"),
        "reviewDeleteLabel": m2,
        "reviewDoneLabel": m3,
        "reviewDoneWish": MessageLookupByLibrary.simpleMessage("已完成心愿"),
        "reviewHeaderText":
            MessageLookupByLibrary.simpleMessage("光写下心愿还不够\n还要付出努力实现哦"),
        "reviewLabel": MessageLookupByLibrary.simpleMessage("回顾"),
        "reviewPauseLabel": m4,
        "reviewTimeDialogTitle": MessageLookupByLibrary.simpleMessage("请选择时间段"),
        "reviewTitle": MessageLookupByLibrary.simpleMessage("回顾"),
        "reviewUndoneLabel": m5,
        "reviewWishSummary": MessageLookupByLibrary.simpleMessage("所有心愿概览"),
        "reviewWishTotal": MessageLookupByLibrary.simpleMessage("心愿总数"),
        "save": MessageLookupByLibrary.simpleMessage("保存"),
        "setting": MessageLookupByLibrary.simpleMessage("设置"),
        "settingsDarkTheme": MessageLookupByLibrary.simpleMessage("深色"),
        "settingsLightTheme": MessageLookupByLibrary.simpleMessage("浅色"),
        "settingsLocale": MessageLookupByLibrary.simpleMessage("语言区域"),
        "settingsSystemDefault": MessageLookupByLibrary.simpleMessage("系统"),
        "settingsTheme": MessageLookupByLibrary.simpleMessage("主题背景"),
        "sort": MessageLookupByLibrary.simpleMessage("排序"),
        "sortByCreatedTime": MessageLookupByLibrary.simpleMessage("创建时间"),
        "sortByModifyTime": MessageLookupByLibrary.simpleMessage("修改时间"),
        "sortByName": MessageLookupByLibrary.simpleMessage("名称"),
        "sortDialogTitle": MessageLookupByLibrary.simpleMessage("排序方式"),
        "stepAddBtn": MessageLookupByLibrary.simpleMessage("添加步骤"),
        "stepDelTip":
            MessageLookupByLibrary.simpleMessage("删除已完成的步骤无法恢复，确定删除吗？"),
        "stepHint": MessageLookupByLibrary.simpleMessage("请输入步骤"),
        "stepTips": MessageLookupByLibrary.simpleMessage("做好规划、一步一步完成的心愿"),
        "timeExpired": m6,
        "timeLatestMonth": MessageLookupByLibrary.simpleMessage("最近一个月"),
        "timeLatestWeek": MessageLookupByLibrary.simpleMessage("最近一周"),
        "timeNoLimit": MessageLookupByLibrary.simpleMessage("无期限"),
        "timeRemainingDay": m7,
        "timeToday": MessageLookupByLibrary.simpleMessage("今天"),
        "today": MessageLookupByLibrary.simpleMessage("今天"),
        "tomorrow": MessageLookupByLibrary.simpleMessage("明天"),
        "typeCheckIn": MessageLookupByLibrary.simpleMessage("打卡"),
        "typeRepeat": MessageLookupByLibrary.simpleMessage("重复"),
        "typeWish": MessageLookupByLibrary.simpleMessage("心愿"),
        "weekday1": MessageLookupByLibrary.simpleMessage("周一"),
        "weekday2": MessageLookupByLibrary.simpleMessage("周二"),
        "weekday3": MessageLookupByLibrary.simpleMessage("周三"),
        "weekday4": MessageLookupByLibrary.simpleMessage("周四"),
        "weekday5": MessageLookupByLibrary.simpleMessage("周五"),
        "weekday6": MessageLookupByLibrary.simpleMessage("周六"),
        "weekday7": MessageLookupByLibrary.simpleMessage("周日"),
        "wishBlack": MessageLookupByLibrary.simpleMessage("黑色"),
        "wishBlue": MessageLookupByLibrary.simpleMessage("蓝色"),
        "wishBrown": MessageLookupByLibrary.simpleMessage("棕色"),
        "wishGreen": MessageLookupByLibrary.simpleMessage("绿色"),
        "wishGrey": MessageLookupByLibrary.simpleMessage("灰色"),
        "wishOrange": MessageLookupByLibrary.simpleMessage("橙色"),
        "wishPink": MessageLookupByLibrary.simpleMessage("粉色"),
        "wishPurple": MessageLookupByLibrary.simpleMessage("紫色"),
        "wishRed": MessageLookupByLibrary.simpleMessage("红色"),
        "wishYellow": MessageLookupByLibrary.simpleMessage("黄色"),
        "yesterday": MessageLookupByLibrary.simpleMessage("昨天")
      };
}
