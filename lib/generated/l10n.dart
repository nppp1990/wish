// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `e.g. `
  String get egLabel {
    return Intl.message(
      'e.g. ',
      name: 'egLabel',
      desc: '',
      args: [],
    );
  }

  /// `please select the check in period`
  String get editErrorForPeriod {
    return Intl.message(
      'please select the check in period',
      name: 'editErrorForPeriod',
      desc: '',
      args: [],
    );
  }

  /// `please select the check in time`
  String get editErrorForTime {
    return Intl.message(
      'please select the check in time',
      name: 'editErrorForTime',
      desc: '',
      args: [],
    );
  }

  /// `step content cannot be empty`
  String get editErrorForSteps {
    return Intl.message(
      'step content cannot be empty',
      name: 'editErrorForSteps',
      desc: '',
      args: [],
    );
  }

  /// `please enter the wish name`
  String get editErrorForName {
    return Intl.message(
      'please enter the wish name',
      name: 'editErrorForName',
      desc: '',
      args: [],
    );
  }

  /// `Select the check in time`
  String get inputCheckInHint {
    return Intl.message(
      'Select the check in time',
      name: 'inputCheckInHint',
      desc: '',
      args: [],
    );
  }

  /// `Check in: `
  String get inputCheckInLabel {
    return Intl.message(
      'Check in: ',
      name: 'inputCheckInLabel',
      desc: '',
      args: [],
    );
  }

  /// `Select the check in period`
  String get checkInPeriodHint {
    return Intl.message(
      'Select the check in period',
      name: 'checkInPeriodHint',
      desc: '',
      args: [],
    );
  }

  /// `Period: `
  String get checkInPeriodLabel {
    return Intl.message(
      'Period: ',
      name: 'checkInPeriodLabel',
      desc: '',
      args: [],
    );
  }

  /// `Select Wish Deadline`
  String get endTimePickerHint {
    return Intl.message(
      'Select Wish Deadline',
      name: 'endTimePickerHint',
      desc: '',
      args: [],
    );
  }

  /// `Deadline: `
  String get endTimePickerLabel {
    return Intl.message(
      'Deadline: ',
      name: 'endTimePickerLabel',
      desc: '',
      args: [],
    );
  }

  /// `enter the step content`
  String get stepHint {
    return Intl.message(
      'enter the step content',
      name: 'stepHint',
      desc: '',
      args: [],
    );
  }

  /// `Deleting completed steps cannot be restored. Are you sure you want to delete it?`
  String get stepDelTip {
    return Intl.message(
      'Deleting completed steps cannot be restored. Are you sure you want to delete it?',
      name: 'stepDelTip',
      desc: '',
      args: [],
    );
  }

  /// `add steps`
  String get stepAddBtn {
    return Intl.message(
      'add steps',
      name: 'stepAddBtn',
      desc: '',
      args: [],
    );
  }

  /// `Make a good plan, and then complete it step by step`
  String get stepTips {
    return Intl.message(
      'Make a good plan, and then complete it step by step',
      name: 'stepTips',
      desc: '',
      args: [],
    );
  }

  /// `Wish`
  String get radioWish {
    return Intl.message(
      'Wish',
      name: 'radioWish',
      desc: '',
      args: [],
    );
  }

  /// `Repeat`
  String get radioRepeat {
    return Intl.message(
      'Repeat',
      name: 'radioRepeat',
      desc: '',
      args: [],
    );
  }

  /// `CheckIn`
  String get radioCheckIn {
    return Intl.message(
      'CheckIn',
      name: 'radioCheckIn',
      desc: '',
      args: [],
    );
  }

  /// `Note`
  String get noteInputLabel {
    return Intl.message(
      'Note',
      name: 'noteInputLabel',
      desc: '',
      args: [],
    );
  }

  /// `record the original intention of this wish, or write a few words to motivate yourself`
  String get noteInputHint {
    return Intl.message(
      'record the original intention of this wish, or write a few words to motivate yourself',
      name: 'noteInputHint',
      desc: '',
      args: [],
    );
  }

  /// `write a memorable wish name`
  String get nameInputHint {
    return Intl.message(
      'write a memorable wish name',
      name: 'nameInputHint',
      desc: '',
      args: [],
    );
  }

  /// `Wish Name`
  String get nameInputLabel {
    return Intl.message(
      'Wish Name',
      name: 'nameInputLabel',
      desc: '',
      args: [],
    );
  }

  /// `After exiting, the current editing content will not be saved`
  String get dialogExitContent {
    return Intl.message(
      'After exiting, the current editing content will not be saved',
      name: 'dialogExitContent',
      desc: '',
      args: [],
    );
  }

  /// `Do you want to exit editing?`
  String get dialogExitTitle {
    return Intl.message(
      'Do you want to exit editing?',
      name: 'dialogExitTitle',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get cancel {
    return Intl.message(
      'Cancel',
      name: 'cancel',
      desc: '',
      args: [],
    );
  }

  /// `Exit`
  String get exit {
    return Intl.message(
      'Exit',
      name: 'exit',
      desc: '',
      args: [],
    );
  }

  /// `Delete`
  String get delete {
    return Intl.message(
      'Delete',
      name: 'delete',
      desc: '',
      args: [],
    );
  }

  /// `Save`
  String get save {
    return Intl.message(
      'Save',
      name: 'save',
      desc: '',
      args: [],
    );
  }

  /// `Edit Wish`
  String get editWishTitle {
    return Intl.message(
      'Edit Wish',
      name: 'editWishTitle',
      desc: '',
      args: [],
    );
  }

  /// `Create Wish`
  String get createWishTitle {
    return Intl.message(
      'Create Wish',
      name: 'createWishTitle',
      desc: '',
      args: [],
    );
  }

  /// `Create Repeat Task`
  String get createRepeatTaskTitle {
    return Intl.message(
      'Create Repeat Task',
      name: 'createRepeatTaskTitle',
      desc: '',
      args: [],
    );
  }

  /// `Create CheckIn Task`
  String get createCheckInTaskTitle {
    return Intl.message(
      'Create CheckIn Task',
      name: 'createCheckInTaskTitle',
      desc: '',
      args: [],
    );
  }

  /// `Every {day} days`
  String opPeriodDetail(Object day) {
    return Intl.message(
      'Every $day days',
      name: 'opPeriodDetail',
      desc: '',
      args: [day],
    );
  }

  /// `edit`
  String get edit {
    return Intl.message(
      'edit',
      name: 'edit',
      desc: '',
      args: [],
    );
  }

  /// `doing`
  String get opDoing {
    return Intl.message(
      'doing',
      name: 'opDoing',
      desc: '',
      args: [],
    );
  }

  /// `paused`
  String get opPaused {
    return Intl.message(
      'paused',
      name: 'opPaused',
      desc: '',
      args: [],
    );
  }

  /// `checked`
  String get opCheckedIn {
    return Intl.message(
      'checked',
      name: 'opCheckedIn',
      desc: '',
      args: [],
    );
  }

  /// `uncheck`
  String get opNoCheckedIn {
    return Intl.message(
      'uncheck',
      name: 'opNoCheckedIn',
      desc: '',
      args: [],
    );
  }

  /// `Last check in`
  String get opLastCheckInLabel {
    return Intl.message(
      'Last check in',
      name: 'opLastCheckInLabel',
      desc: '',
      args: [],
    );
  }

  /// `Pause check in`
  String get opPauseCheckInLabel {
    return Intl.message(
      'Pause check in',
      name: 'opPauseCheckInLabel',
      desc: '',
      args: [],
    );
  }

  /// `After pausing, there will be no further reminder to clock in`
  String get opPauseTip {
    return Intl.message(
      'After pausing, there will be no further reminder to clock in',
      name: 'opPauseTip',
      desc: '',
      args: [],
    );
  }

  /// `Check in`
  String get opTodayCheckIn {
    return Intl.message(
      'Check in',
      name: 'opTodayCheckIn',
      desc: '',
      args: [],
    );
  }

  /// `Check in times`
  String get opCheckTimesLabel {
    return Intl.message(
      'Check in times',
      name: 'opCheckTimesLabel',
      desc: '',
      args: [],
    );
  }

  /// `Check in time`
  String get opCheckInTimeLabel {
    return Intl.message(
      'Check in time',
      name: 'opCheckInTimeLabel',
      desc: '',
      args: [],
    );
  }

  /// `Check in period`
  String get opPeriodLabel {
    return Intl.message(
      'Check in period',
      name: 'opPeriodLabel',
      desc: '',
      args: [],
    );
  }

  /// `Wish Operation History`
  String get opHistoryTitle {
    return Intl.message(
      'Wish Operation History',
      name: 'opHistoryTitle',
      desc: '',
      args: [],
    );
  }

  /// ` `
  String get opTimesUnit {
    return Intl.message(
      ' ',
      name: 'opTimesUnit',
      desc: '',
      args: [],
    );
  }

  /// `Completed`
  String get opDoneTimes {
    return Intl.message(
      'Completed',
      name: 'opDoneTimes',
      desc: '',
      args: [],
    );
  }

  /// `Target`
  String get opTargetTimes {
    return Intl.message(
      'Target',
      name: 'opTargetTimes',
      desc: '',
      args: [],
    );
  }

  /// `Progress`
  String get opCardTitle {
    return Intl.message(
      'Progress',
      name: 'opCardTitle',
      desc: '',
      args: [],
    );
  }

  /// `No steps have been set, you can click the button in the bottom right corner to directly complete or cancel the completion of your wish`
  String get opStepsTip {
    return Intl.message(
      'No steps have been set, you can click the button in the bottom right corner to directly complete or cancel the completion of your wish',
      name: 'opStepsTip',
      desc: '',
      args: [],
    );
  }

  /// `Monday`
  String get weekday1 {
    return Intl.message(
      'Monday',
      name: 'weekday1',
      desc: '',
      args: [],
    );
  }

  /// `Tuesday`
  String get weekday2 {
    return Intl.message(
      'Tuesday',
      name: 'weekday2',
      desc: '',
      args: [],
    );
  }

  /// `Wednesday`
  String get weekday3 {
    return Intl.message(
      'Wednesday',
      name: 'weekday3',
      desc: '',
      args: [],
    );
  }

  /// `Thursday`
  String get weekday4 {
    return Intl.message(
      'Thursday',
      name: 'weekday4',
      desc: '',
      args: [],
    );
  }

  /// `Friday`
  String get weekday5 {
    return Intl.message(
      'Friday',
      name: 'weekday5',
      desc: '',
      args: [],
    );
  }

  /// `Saturday`
  String get weekday6 {
    return Intl.message(
      'Saturday',
      name: 'weekday6',
      desc: '',
      args: [],
    );
  }

  /// `Sunday`
  String get weekday7 {
    return Intl.message(
      'Sunday',
      name: 'weekday7',
      desc: '',
      args: [],
    );
  }

  /// `days`
  String get days {
    return Intl.message(
      'days',
      name: 'days',
      desc: '',
      args: [],
    );
  }

  /// `Today`
  String get today {
    return Intl.message(
      'Today',
      name: 'today',
      desc: '',
      args: [],
    );
  }

  /// `Yesterday`
  String get yesterday {
    return Intl.message(
      'Yesterday',
      name: 'yesterday',
      desc: '',
      args: [],
    );
  }

  /// `Tomorrow`
  String get tomorrow {
    return Intl.message(
      'Tomorrow',
      name: 'tomorrow',
      desc: '',
      args: [],
    );
  }

  /// `Before Yesterday`
  String get beforeYesterday {
    return Intl.message(
      'Before Yesterday',
      name: 'beforeYesterday',
      desc: '',
      args: [],
    );
  }

  /// `After Tomorrow`
  String get afterTomorrow {
    return Intl.message(
      'After Tomorrow',
      name: 'afterTomorrow',
      desc: '',
      args: [],
    );
  }

  /// `Wish Time`
  String get opTimeCardTitle {
    return Intl.message(
      'Wish Time',
      name: 'opTimeCardTitle',
      desc: '',
      args: [],
    );
  }

  /// `Start time`
  String get opBeginTime {
    return Intl.message(
      'Start time',
      name: 'opBeginTime',
      desc: '',
      args: [],
    );
  }

  /// `End time`
  String get opEndTime {
    return Intl.message(
      'End time',
      name: 'opEndTime',
      desc: '',
      args: [],
    );
  }

  /// `Indefinitely`
  String get opNoEnd {
    return Intl.message(
      'Indefinitely',
      name: 'opNoEnd',
      desc: '',
      args: [],
    );
  }

  /// `Continuous`
  String get opTimeContinuous {
    return Intl.message(
      'Continuous',
      name: 'opTimeContinuous',
      desc: '',
      args: [],
    );
  }

  /// `black`
  String get wishBlack {
    return Intl.message(
      'black',
      name: 'wishBlack',
      desc: '',
      args: [],
    );
  }

  /// `red`
  String get wishRed {
    return Intl.message(
      'red',
      name: 'wishRed',
      desc: '',
      args: [],
    );
  }

  /// `orange`
  String get wishOrange {
    return Intl.message(
      'orange',
      name: 'wishOrange',
      desc: '',
      args: [],
    );
  }

  /// `yellow`
  String get wishYellow {
    return Intl.message(
      'yellow',
      name: 'wishYellow',
      desc: '',
      args: [],
    );
  }

  /// `green`
  String get wishGreen {
    return Intl.message(
      'green',
      name: 'wishGreen',
      desc: '',
      args: [],
    );
  }

  /// `blue`
  String get wishBlue {
    return Intl.message(
      'blue',
      name: 'wishBlue',
      desc: '',
      args: [],
    );
  }

  /// `purple`
  String get wishPurple {
    return Intl.message(
      'purple',
      name: 'wishPurple',
      desc: '',
      args: [],
    );
  }

  /// `pink`
  String get wishPink {
    return Intl.message(
      'pink',
      name: 'wishPink',
      desc: '',
      args: [],
    );
  }

  /// `brown`
  String get wishBrown {
    return Intl.message(
      'brown',
      name: 'wishBrown',
      desc: '',
      args: [],
    );
  }

  /// `grey`
  String get wishGrey {
    return Intl.message(
      'grey',
      name: 'wishGrey',
      desc: '',
      args: [],
    );
  }

  /// `completed `
  String get opDoneStep {
    return Intl.message(
      'completed ',
      name: 'opDoneStep',
      desc: '',
      args: [],
    );
  }

  /// `canceled completion `
  String get opUndoneStep {
    return Intl.message(
      'canceled completion ',
      name: 'opUndoneStep',
      desc: '',
      args: [],
    );
  }

  /// `Made the wish `
  String get opTitleCreateWish {
    return Intl.message(
      'Made the wish ',
      name: 'opTitleCreateWish',
      desc: '',
      args: [],
    );
  }

  /// `Deleted the wish `
  String get opTitleDelWish {
    return Intl.message(
      'Deleted the wish ',
      name: 'opTitleDelWish',
      desc: '',
      args: [],
    );
  }

  /// `Modified the wish `
  String get opTitleModifyWish {
    return Intl.message(
      'Modified the wish ',
      name: 'opTitleModifyWish',
      desc: '',
      args: [],
    );
  }

  /// `Completed the wish`
  String get opTitleDoneWish {
    return Intl.message(
      'Completed the wish',
      name: 'opTitleDoneWish',
      desc: '',
      args: [],
    );
  }

  /// `Canceled completion of the wish`
  String get opTitleUndoneWish {
    return Intl.message(
      'Canceled completion of the wish',
      name: 'opTitleUndoneWish',
      desc: '',
      args: [],
    );
  }

  /// `Updated the steps`
  String get opTitleUpdatedSteps {
    return Intl.message(
      'Updated the steps',
      name: 'opTitleUpdatedSteps',
      desc: '',
      args: [],
    );
  }

  /// `Checked in once`
  String get opTitleCheckIn {
    return Intl.message(
      'Checked in once',
      name: 'opTitleCheckIn',
      desc: '',
      args: [],
    );
  }

  /// `Updated the repeat count`
  String get opTitleUpdateCount {
    return Intl.message(
      'Updated the repeat count',
      name: 'opTitleUpdateCount',
      desc: '',
      args: [],
    );
  }

  /// `Paused the check in task`
  String get opTitlePauseCheckIn {
    return Intl.message(
      'Paused the check in task',
      name: 'opTitlePauseCheckIn',
      desc: '',
      args: [],
    );
  }

  /// `Resumed the check in task`
  String get opTitleResumeCheckIn {
    return Intl.message(
      'Resumed the check in task',
      name: 'opTitleResumeCheckIn',
      desc: '',
      args: [],
    );
  }

  /// ` `
  String get opSuffix {
    return Intl.message(
      ' ',
      name: 'opSuffix',
      desc: '',
      args: [],
    );
  }

  /// ` and other info`
  String get opOtherInfo {
    return Intl.message(
      ' and other info',
      name: 'opOtherInfo',
      desc: '',
      args: [],
    );
  }

  /// `repeat count`
  String get opRepeatCount {
    return Intl.message(
      'repeat count',
      name: 'opRepeatCount',
      desc: '',
      args: [],
    );
  }

  /// `modified step`
  String get opModifiedStep {
    return Intl.message(
      'modified step',
      name: 'opModifiedStep',
      desc: '',
      args: [],
    );
  }

  /// `deadline`
  String get opDeadline {
    return Intl.message(
      'deadline',
      name: 'opDeadline',
      desc: '',
      args: [],
    );
  }

  /// `check in period`
  String get opCheckInPeriod {
    return Intl.message(
      'check in period',
      name: 'opCheckInPeriod',
      desc: '',
      args: [],
    );
  }

  /// `check in time`
  String get opCheckInTime {
    return Intl.message(
      'check in time',
      name: 'opCheckInTime',
      desc: '',
      args: [],
    );
  }

  /// `modified note`
  String get opModifyNote {
    return Intl.message(
      'modified note',
      name: 'opModifyNote',
      desc: '',
      args: [],
    );
  }

  /// `color`
  String get opColor {
    return Intl.message(
      'color',
      name: 'opColor',
      desc: '',
      args: [],
    );
  }

  /// `type`
  String get opType {
    return Intl.message(
      'type',
      name: 'opType',
      desc: '',
      args: [],
    );
  }

  /// `name`
  String get opName {
    return Intl.message(
      'name',
      name: 'opName',
      desc: '',
      args: [],
    );
  }

  /// `note`
  String get opNote {
    return Intl.message(
      'note',
      name: 'opNote',
      desc: '',
      args: [],
    );
  }

  /// `step`
  String get opSteps {
    return Intl.message(
      'step',
      name: 'opSteps',
      desc: '',
      args: [],
    );
  }

  /// `changed `
  String get opChangeFrom {
    return Intl.message(
      'changed ',
      name: 'opChangeFrom',
      desc: '',
      args: [],
    );
  }

  /// ` to `
  String get opChangeTo {
    return Intl.message(
      ' to ',
      name: 'opChangeTo',
      desc: '',
      args: [],
    );
  }

  /// `Edit`
  String get menuEdit {
    return Intl.message(
      'Edit',
      name: 'menuEdit',
      desc: '',
      args: [],
    );
  }

  /// `Done`
  String get menuDone {
    return Intl.message(
      'Done',
      name: 'menuDone',
      desc: '',
      args: [],
    );
  }

  /// `Undone`
  String get menuUndone {
    return Intl.message(
      'Undone',
      name: 'menuUndone',
      desc: '',
      args: [],
    );
  }

  /// `Delete`
  String get menuDelete {
    return Intl.message(
      'Delete',
      name: 'menuDelete',
      desc: '',
      args: [],
    );
  }

  /// `Check In`
  String get menuCheckIn {
    return Intl.message(
      'Check In',
      name: 'menuCheckIn',
      desc: '',
      args: [],
    );
  }

  /// `Times`
  String get menuTimes {
    return Intl.message(
      'Times',
      name: 'menuTimes',
      desc: '',
      args: [],
    );
  }

  /// `modified at `
  String get modifiedAt {
    return Intl.message(
      'modified at ',
      name: 'modifiedAt',
      desc: '',
      args: [],
    );
  }

  /// `created at `
  String get createdAt {
    return Intl.message(
      'created at ',
      name: 'createdAt',
      desc: '',
      args: [],
    );
  }

  /// `Check in times`
  String get checkInCount {
    return Intl.message(
      'Check in times',
      name: 'checkInCount',
      desc: '',
      args: [],
    );
  }

  /// `Wish for {day} remaining`
  String timeRemainingDay(Object day) {
    return Intl.message(
      'Wish for $day remaining',
      name: 'timeRemainingDay',
      desc: '',
      args: [day],
    );
  }

  /// `Expired for {day} days`
  String timeExpired(Object day) {
    return Intl.message(
      'Expired for $day days',
      name: 'timeExpired',
      desc: '',
      args: [day],
    );
  }

  /// `Indefinite period`
  String get timeNoLimit {
    return Intl.message(
      'Indefinite period',
      name: 'timeNoLimit',
      desc: '',
      args: [],
    );
  }

  /// `Sort order`
  String get sortDialogTitle {
    return Intl.message(
      'Sort order',
      name: 'sortDialogTitle',
      desc: '',
      args: [],
    );
  }

  /// `Review`
  String get reviewTitle {
    return Intl.message(
      'Review',
      name: 'reviewTitle',
      desc: '',
      args: [],
    );
  }

  /// `Write down your wishes.\nWork hard to achieve them`
  String get reviewHeaderText {
    return Intl.message(
      'Write down your wishes.\nWork hard to achieve them',
      name: 'reviewHeaderText',
      desc: '',
      args: [],
    );
  }

  /// `All Wish Summary`
  String get reviewWishSummary {
    return Intl.message(
      'All Wish Summary',
      name: 'reviewWishSummary',
      desc: '',
      args: [],
    );
  }

  /// `Total`
  String get reviewWishTotal {
    return Intl.message(
      'Total',
      name: 'reviewWishTotal',
      desc: '',
      args: [],
    );
  }

  /// `Done Wish`
  String get reviewDoneWish {
    return Intl.message(
      'Done Wish',
      name: 'reviewDoneWish',
      desc: '',
      args: [],
    );
  }

  /// `Delay Wish`
  String get reviewDelayWish {
    return Intl.message(
      'Delay Wish',
      name: 'reviewDelayWish',
      desc: '',
      args: [],
    );
  }

  /// `Today`
  String get timeToday {
    return Intl.message(
      'Today',
      name: 'timeToday',
      desc: '',
      args: [],
    );
  }

  /// `Latest Week`
  String get timeLatestWeek {
    return Intl.message(
      'Latest Week',
      name: 'timeLatestWeek',
      desc: '',
      args: [],
    );
  }

  /// `Latest Month`
  String get timeLatestMonth {
    return Intl.message(
      'Latest Month',
      name: 'timeLatestMonth',
      desc: '',
      args: [],
    );
  }

  /// `custom`
  String get custom {
    return Intl.message(
      'custom',
      name: 'custom',
      desc: '',
      args: [],
    );
  }

  /// `Please select the review time`
  String get reviewTimeDialogTitle {
    return Intl.message(
      'Please select the review time',
      name: 'reviewTimeDialogTitle',
      desc: '',
      args: [],
    );
  }

  /// `Create {count}`
  String reviewCreateLabel(Object count) {
    return Intl.message(
      'Create $count',
      name: 'reviewCreateLabel',
      desc: '',
      args: [count],
    );
  }

  /// `Done {count}`
  String reviewDoneLabel(Object count) {
    return Intl.message(
      'Done $count',
      name: 'reviewDoneLabel',
      desc: '',
      args: [count],
    );
  }

  /// `Undone {count}`
  String reviewUndoneLabel(Object count) {
    return Intl.message(
      'Undone $count',
      name: 'reviewUndoneLabel',
      desc: '',
      args: [count],
    );
  }

  /// `Pause {count}`
  String reviewPauseLabel(Object count) {
    return Intl.message(
      'Pause $count',
      name: 'reviewPauseLabel',
      desc: '',
      args: [count],
    );
  }

  /// `Delete {count}`
  String reviewDeleteLabel(Object count) {
    return Intl.message(
      'Delete $count',
      name: 'reviewDeleteLabel',
      desc: '',
      args: [count],
    );
  }

  /// `Hello World!`
  String get helloWorld {
    return Intl.message(
      'Hello World!',
      name: 'helloWorld',
      desc: '',
      args: [],
    );
  }

  /// `System`
  String get settingsSystemDefault {
    return Intl.message(
      'System',
      name: 'settingsSystemDefault',
      desc: '',
      args: [],
    );
  }

  /// `Theme`
  String get settingsTheme {
    return Intl.message(
      'Theme',
      name: 'settingsTheme',
      desc: '',
      args: [],
    );
  }

  /// `Create Repeat Task`
  String get menuCreateRepeatTask {
    return Intl.message(
      'Create Repeat Task',
      name: 'menuCreateRepeatTask',
      desc: '',
      args: [],
    );
  }

  /// `Create Wish`
  String get menuCreateWish {
    return Intl.message(
      'Create Wish',
      name: 'menuCreateWish',
      desc: '',
      args: [],
    );
  }

  /// `Create CheckIn Task`
  String get menuCreateCheckInTask {
    return Intl.message(
      'Create CheckIn Task',
      name: 'menuCreateCheckInTask',
      desc: '',
      args: [],
    );
  }

  /// `English`
  String get localeEn {
    return Intl.message(
      'English',
      name: 'localeEn',
      desc: '',
      args: [],
    );
  }

  /// `Dark`
  String get settingsDarkTheme {
    return Intl.message(
      'Dark',
      name: 'settingsDarkTheme',
      desc: '',
      args: [],
    );
  }

  /// `Light`
  String get settingsLightTheme {
    return Intl.message(
      'Light',
      name: 'settingsLightTheme',
      desc: '',
      args: [],
    );
  }

  /// `Locale`
  String get settingsLocale {
    return Intl.message(
      'Locale',
      name: 'settingsLocale',
      desc: '',
      args: [],
    );
  }

  /// `Setting`
  String get setting {
    return Intl.message(
      'Setting',
      name: 'setting',
      desc: '',
      args: [],
    );
  }

  /// `Sort`
  String get sort {
    return Intl.message(
      'Sort',
      name: 'sort',
      desc: '',
      args: [],
    );
  }

  /// `Wish List`
  String get allWish {
    return Intl.message(
      'Wish List',
      name: 'allWish',
      desc: '',
      args: [],
    );
  }

  /// `Desire`
  String get desireLabel {
    return Intl.message(
      'Desire',
      name: 'desireLabel',
      desc: '',
      args: [],
    );
  }

  /// `Repeat Task`
  String get repeatTaskLabel {
    return Intl.message(
      'Repeat Task',
      name: 'repeatTaskLabel',
      desc: '',
      args: [],
    );
  }

  /// `CheckIn Task`
  String get checkInTaskLabel {
    return Intl.message(
      'CheckIn Task',
      name: 'checkInTaskLabel',
      desc: '',
      args: [],
    );
  }

  /// `Done List`
  String get doneLabel {
    return Intl.message(
      'Done List',
      name: 'doneLabel',
      desc: '',
      args: [],
    );
  }

  /// `Review`
  String get reviewLabel {
    return Intl.message(
      'Review',
      name: 'reviewLabel',
      desc: '',
      args: [],
    );
  }

  /// `Name`
  String get sortByName {
    return Intl.message(
      'Name',
      name: 'sortByName',
      desc: '',
      args: [],
    );
  }

  /// `Create Time`
  String get sortByCreatedTime {
    return Intl.message(
      'Create Time',
      name: 'sortByCreatedTime',
      desc: '',
      args: [],
    );
  }

  /// `Modified Time`
  String get sortByModifyTime {
    return Intl.message(
      'Modified Time',
      name: 'sortByModifyTime',
      desc: '',
      args: [],
    );
  }

  /// `Wish`
  String get typeWish {
    return Intl.message(
      'Wish',
      name: 'typeWish',
      desc: '',
      args: [],
    );
  }

  /// `Repeat`
  String get typeRepeat {
    return Intl.message(
      'Repeat',
      name: 'typeRepeat',
      desc: '',
      args: [],
    );
  }

  /// `CheckIn`
  String get typeCheckIn {
    return Intl.message(
      'CheckIn',
      name: 'typeCheckIn',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'zh'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
