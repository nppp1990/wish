// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
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
  String get localeName => 'en';

  static String m0(day) => "Every ${day} days";

  static String m1(count) => "Create ${count}";

  static String m2(count) => "Delete ${count}";

  static String m3(count) => "Done ${count}";

  static String m4(count) => "Pause ${count}";

  static String m5(count) => "Undone ${count}";

  static String m6(day) => "Expired for ${day} days";

  static String m7(day) => "Wish for ${day} remaining";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "afterTomorrow": MessageLookupByLibrary.simpleMessage("After Tomorrow"),
        "allWish": MessageLookupByLibrary.simpleMessage("Wish List"),
        "beforeYesterday":
            MessageLookupByLibrary.simpleMessage("Before Yesterday"),
        "cancel": MessageLookupByLibrary.simpleMessage("Cancel"),
        "checkInCount": MessageLookupByLibrary.simpleMessage("Check in times"),
        "checkInPeriodHint":
            MessageLookupByLibrary.simpleMessage("Select the check in period"),
        "checkInPeriodLabel": MessageLookupByLibrary.simpleMessage("Period: "),
        "checkInTaskLabel":
            MessageLookupByLibrary.simpleMessage("CheckIn Task"),
        "createCheckInTaskTitle":
            MessageLookupByLibrary.simpleMessage("Create CheckIn Task"),
        "createRepeatTaskTitle":
            MessageLookupByLibrary.simpleMessage("Create Repeat Task"),
        "createWishTitle": MessageLookupByLibrary.simpleMessage("Create Wish"),
        "createdAt": MessageLookupByLibrary.simpleMessage("created at "),
        "custom": MessageLookupByLibrary.simpleMessage("custom"),
        "days": MessageLookupByLibrary.simpleMessage("days"),
        "delete": MessageLookupByLibrary.simpleMessage("Delete"),
        "desireLabel": MessageLookupByLibrary.simpleMessage("Desire"),
        "dialogExitContent": MessageLookupByLibrary.simpleMessage(
            "After exiting, the current editing content will not be saved"),
        "dialogExitTitle": MessageLookupByLibrary.simpleMessage(
            "Do you want to exit editing?"),
        "doneLabel": MessageLookupByLibrary.simpleMessage("Done List"),
        "edit": MessageLookupByLibrary.simpleMessage("edit"),
        "editErrorForName":
            MessageLookupByLibrary.simpleMessage("please enter the wish name"),
        "editErrorForPeriod": MessageLookupByLibrary.simpleMessage(
            "please select the check in period"),
        "editErrorForSteps": MessageLookupByLibrary.simpleMessage(
            "step content cannot be empty"),
        "editErrorForTime": MessageLookupByLibrary.simpleMessage(
            "please select the check in time"),
        "editWishTitle": MessageLookupByLibrary.simpleMessage("Edit Wish"),
        "egLabel": MessageLookupByLibrary.simpleMessage("e.g. "),
        "endTimePickerHint":
            MessageLookupByLibrary.simpleMessage("Select Wish Deadline"),
        "endTimePickerLabel":
            MessageLookupByLibrary.simpleMessage("Deadline: "),
        "exit": MessageLookupByLibrary.simpleMessage("Exit"),
        "helloWorld": MessageLookupByLibrary.simpleMessage("Hello World!"),
        "inputCheckInHint":
            MessageLookupByLibrary.simpleMessage("Select the check in time"),
        "inputCheckInLabel": MessageLookupByLibrary.simpleMessage("Check in: "),
        "localeEn": MessageLookupByLibrary.simpleMessage("English"),
        "menuCheckIn": MessageLookupByLibrary.simpleMessage("Check In"),
        "menuCreateCheckInTask":
            MessageLookupByLibrary.simpleMessage("Create CheckIn Task"),
        "menuCreateRepeatTask":
            MessageLookupByLibrary.simpleMessage("Create Repeat Task"),
        "menuCreateWish": MessageLookupByLibrary.simpleMessage("Create Wish"),
        "menuDelete": MessageLookupByLibrary.simpleMessage("Delete"),
        "menuDone": MessageLookupByLibrary.simpleMessage("Done"),
        "menuEdit": MessageLookupByLibrary.simpleMessage("Edit"),
        "menuTimes": MessageLookupByLibrary.simpleMessage("Times"),
        "menuUndone": MessageLookupByLibrary.simpleMessage("Undone"),
        "modifiedAt": MessageLookupByLibrary.simpleMessage("modified at "),
        "nameInputHint":
            MessageLookupByLibrary.simpleMessage("write a memorable wish name"),
        "nameInputLabel": MessageLookupByLibrary.simpleMessage("Wish Name"),
        "noteInputHint": MessageLookupByLibrary.simpleMessage(
            "record the original intention of this wish, or write a few words to motivate yourself"),
        "noteInputLabel": MessageLookupByLibrary.simpleMessage("Note"),
        "opBeginTime": MessageLookupByLibrary.simpleMessage("Start time"),
        "opCardTitle": MessageLookupByLibrary.simpleMessage("Progress"),
        "opChangeFrom": MessageLookupByLibrary.simpleMessage("changed "),
        "opChangeTo": MessageLookupByLibrary.simpleMessage(" to "),
        "opCheckInPeriod":
            MessageLookupByLibrary.simpleMessage("check in period"),
        "opCheckInTime": MessageLookupByLibrary.simpleMessage("check in time"),
        "opCheckInTimeLabel":
            MessageLookupByLibrary.simpleMessage("Check in time"),
        "opCheckTimesLabel":
            MessageLookupByLibrary.simpleMessage("Check in times"),
        "opCheckedIn": MessageLookupByLibrary.simpleMessage("checked"),
        "opColor": MessageLookupByLibrary.simpleMessage("color"),
        "opDeadline": MessageLookupByLibrary.simpleMessage("deadline"),
        "opDoing": MessageLookupByLibrary.simpleMessage("doing"),
        "opDoneStep": MessageLookupByLibrary.simpleMessage("completed "),
        "opDoneTimes": MessageLookupByLibrary.simpleMessage("Completed"),
        "opEndTime": MessageLookupByLibrary.simpleMessage("End time"),
        "opHistoryTitle":
            MessageLookupByLibrary.simpleMessage("Wish Operation History"),
        "opLastCheckInLabel":
            MessageLookupByLibrary.simpleMessage("Last check in"),
        "opModifiedStep": MessageLookupByLibrary.simpleMessage("modified step"),
        "opModifyNote": MessageLookupByLibrary.simpleMessage("modified note"),
        "opName": MessageLookupByLibrary.simpleMessage("name"),
        "opNoCheckedIn": MessageLookupByLibrary.simpleMessage("uncheck"),
        "opNoEnd": MessageLookupByLibrary.simpleMessage("Indefinitely"),
        "opNote": MessageLookupByLibrary.simpleMessage("note"),
        "opOtherInfo": MessageLookupByLibrary.simpleMessage(" and other info"),
        "opPauseCheckInLabel":
            MessageLookupByLibrary.simpleMessage("Pause check in"),
        "opPauseTip": MessageLookupByLibrary.simpleMessage(
            "After pausing, there will be no further reminder to clock in"),
        "opPaused": MessageLookupByLibrary.simpleMessage("paused"),
        "opPeriodDetail": m0,
        "opPeriodLabel":
            MessageLookupByLibrary.simpleMessage("Check in period"),
        "opRepeatCount": MessageLookupByLibrary.simpleMessage("repeat count"),
        "opSteps": MessageLookupByLibrary.simpleMessage("step"),
        "opStepsTip": MessageLookupByLibrary.simpleMessage(
            "No steps have been set, you can click the button in the bottom right corner to directly complete or cancel the completion of your wish"),
        "opSuffix": MessageLookupByLibrary.simpleMessage(" "),
        "opTargetTimes": MessageLookupByLibrary.simpleMessage("Target"),
        "opTimeCardTitle": MessageLookupByLibrary.simpleMessage("Wish Time"),
        "opTimeContinuous": MessageLookupByLibrary.simpleMessage("Continuous"),
        "opTimesUnit": MessageLookupByLibrary.simpleMessage(" "),
        "opTitleCheckIn":
            MessageLookupByLibrary.simpleMessage("Checked in once"),
        "opTitleCreateWish":
            MessageLookupByLibrary.simpleMessage("Made the wish "),
        "opTitleDelWish":
            MessageLookupByLibrary.simpleMessage("Deleted the wish "),
        "opTitleDoneWish":
            MessageLookupByLibrary.simpleMessage("Completed the wish"),
        "opTitleModifyWish":
            MessageLookupByLibrary.simpleMessage("Modified the wish "),
        "opTitlePauseCheckIn":
            MessageLookupByLibrary.simpleMessage("Paused the check in task"),
        "opTitleResumeCheckIn":
            MessageLookupByLibrary.simpleMessage("Resumed the check in task"),
        "opTitleUndoneWish": MessageLookupByLibrary.simpleMessage(
            "Canceled completion of the wish"),
        "opTitleUpdateCount":
            MessageLookupByLibrary.simpleMessage("Updated the repeat count"),
        "opTitleUpdatedSteps":
            MessageLookupByLibrary.simpleMessage("Updated the steps"),
        "opTodayCheckIn": MessageLookupByLibrary.simpleMessage("Check in"),
        "opType": MessageLookupByLibrary.simpleMessage("type"),
        "opUndoneStep":
            MessageLookupByLibrary.simpleMessage("canceled completion "),
        "radioCheckIn": MessageLookupByLibrary.simpleMessage("CheckIn"),
        "radioRepeat": MessageLookupByLibrary.simpleMessage("Repeat"),
        "radioWish": MessageLookupByLibrary.simpleMessage("Wish"),
        "repeatTaskLabel": MessageLookupByLibrary.simpleMessage("Repeat Task"),
        "reviewCreateLabel": m1,
        "reviewDelayWish": MessageLookupByLibrary.simpleMessage("Delay Wish"),
        "reviewDeleteLabel": m2,
        "reviewDoneLabel": m3,
        "reviewDoneWish": MessageLookupByLibrary.simpleMessage("Done Wish"),
        "reviewHeaderText": MessageLookupByLibrary.simpleMessage(
            "Write down your wishes.\nWork hard to achieve them"),
        "reviewLabel": MessageLookupByLibrary.simpleMessage("Review"),
        "reviewPauseLabel": m4,
        "reviewTimeDialogTitle": MessageLookupByLibrary.simpleMessage(
            "Please select the review time"),
        "reviewTitle": MessageLookupByLibrary.simpleMessage("Review"),
        "reviewUndoneLabel": m5,
        "reviewWishSummary":
            MessageLookupByLibrary.simpleMessage("All Wish Summary"),
        "reviewWishTotal": MessageLookupByLibrary.simpleMessage("Total"),
        "save": MessageLookupByLibrary.simpleMessage("Save"),
        "setting": MessageLookupByLibrary.simpleMessage("Setting"),
        "settingsDarkTheme": MessageLookupByLibrary.simpleMessage("Dark"),
        "settingsLightTheme": MessageLookupByLibrary.simpleMessage("Light"),
        "settingsLocale": MessageLookupByLibrary.simpleMessage("Locale"),
        "settingsSystemDefault": MessageLookupByLibrary.simpleMessage("System"),
        "settingsTheme": MessageLookupByLibrary.simpleMessage("Theme"),
        "sort": MessageLookupByLibrary.simpleMessage("Sort"),
        "sortByCreatedTime":
            MessageLookupByLibrary.simpleMessage("Create Time"),
        "sortByModifyTime":
            MessageLookupByLibrary.simpleMessage("Modified Time"),
        "sortByName": MessageLookupByLibrary.simpleMessage("Name"),
        "sortDialogTitle": MessageLookupByLibrary.simpleMessage("Sort order"),
        "stepAddBtn": MessageLookupByLibrary.simpleMessage("add steps"),
        "stepDelTip": MessageLookupByLibrary.simpleMessage(
            "Deleting completed steps cannot be restored. Are you sure you want to delete it?"),
        "stepHint":
            MessageLookupByLibrary.simpleMessage("enter the step content"),
        "stepTips": MessageLookupByLibrary.simpleMessage(
            "Make a good plan, and then complete it step by step"),
        "timeExpired": m6,
        "timeLatestMonth": MessageLookupByLibrary.simpleMessage("Latest Month"),
        "timeLatestWeek": MessageLookupByLibrary.simpleMessage("Latest Week"),
        "timeNoLimit":
            MessageLookupByLibrary.simpleMessage("Indefinite period"),
        "timeRemainingDay": m7,
        "timeToday": MessageLookupByLibrary.simpleMessage("Today"),
        "today": MessageLookupByLibrary.simpleMessage("Today"),
        "tomorrow": MessageLookupByLibrary.simpleMessage("Tomorrow"),
        "typeCheckIn": MessageLookupByLibrary.simpleMessage("CheckIn"),
        "typeRepeat": MessageLookupByLibrary.simpleMessage("Repeat"),
        "typeWish": MessageLookupByLibrary.simpleMessage("Wish"),
        "weekday1": MessageLookupByLibrary.simpleMessage("Monday"),
        "weekday2": MessageLookupByLibrary.simpleMessage("Tuesday"),
        "weekday3": MessageLookupByLibrary.simpleMessage("Wednesday"),
        "weekday4": MessageLookupByLibrary.simpleMessage("Thursday"),
        "weekday5": MessageLookupByLibrary.simpleMessage("Friday"),
        "weekday6": MessageLookupByLibrary.simpleMessage("Saturday"),
        "weekday7": MessageLookupByLibrary.simpleMessage("Sunday"),
        "wishBlack": MessageLookupByLibrary.simpleMessage("black"),
        "wishBlue": MessageLookupByLibrary.simpleMessage("blue"),
        "wishBrown": MessageLookupByLibrary.simpleMessage("brown"),
        "wishGreen": MessageLookupByLibrary.simpleMessage("green"),
        "wishGrey": MessageLookupByLibrary.simpleMessage("grey"),
        "wishOrange": MessageLookupByLibrary.simpleMessage("orange"),
        "wishPink": MessageLookupByLibrary.simpleMessage("pink"),
        "wishPurple": MessageLookupByLibrary.simpleMessage("purple"),
        "wishRed": MessageLookupByLibrary.simpleMessage("red"),
        "wishYellow": MessageLookupByLibrary.simpleMessage("yellow"),
        "yesterday": MessageLookupByLibrary.simpleMessage("Yesterday")
      };
}
