import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/wish_localizations.dart';
import 'package:wish/data/data_base_helper.dart';
import 'package:wish/data/event_manager.dart';
import 'package:wish/data/style/wish_options.dart';
import 'package:wish/data/wish_data.dart';
import 'package:wish/data/wish_op.dart';
import 'package:wish/pages/edit_page.dart';
import 'package:wish/router/router_utils.dart';
import 'package:wish/utils/timeUtils.dart';
import 'package:wish/widgets/card_item.dart';
import 'package:wish/widgets/op/done_switch.dart';
import 'package:wish/widgets/op/op_list.dart';
import 'package:wish/widgets/op/radio_check.dart';
import 'package:wish/widgets/op/radius_line.dart';
import 'package:wish/widgets/switch_num.dart';

class OpPage extends StatefulWidget {
  final WishData itemData;
  final int index;

  const OpPage({super.key, required this.itemData, required this.index});

  @override
  State<StatefulWidget> createState() => _OpPageState();
}

class _OpPageState extends State<OpPage> {
  final GlobalKey<_OpPageViewState> opPageViewKey = GlobalKey<_OpPageViewState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: OpPageView(key: opPageViewKey, itemData: widget.itemData, index: widget.index),
      floatingActionButton: DoneFloatButton(
        wishData: widget.itemData,
        index: widget.index,
        canDone: () {
          return opPageViewKey.currentState!.getOpResult();
        },
      ),
    );
  }
}

class DoneFloatButton extends StatefulWidget {
  final ValueGetter<dynamic> canDone;
  final WishData wishData;
  final int index;

  const DoneFloatButton({
    super.key,
    required this.wishData,
    required this.canDone,
    required this.index,
  });

  @override
  State<StatefulWidget> createState() => _DoneFloatButtonState();
}

class _DoneFloatButtonState extends State<DoneFloatButton> {
  late bool _done;

  _handleDoneOp(bool done) async {
    var res = await DatabaseHelper.instance.handleDoneOp(widget.wishData, done);
    if (res > 0) {
      eventBus.fire(UpdateWishEvent(widget.index, widget.wishData.id!));
    }
  }

  @override
  void initState() {
    super.initState();
    _done = widget.wishData.done;
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      tooltip: _done ? '直接取消' : '取消完成',
      onPressed: () async {
        bool? res = await _showDoneChangedDialog(context, widget.wishData, _done, widget.canDone());
        if (res ?? false) {
          _handleDoneOp(!_done);
          setState(() {
            _done = !_done;
          });
        }
      },
      backgroundColor: Colors.white,
      child: Icon(
        size: 40,
        _done ? Icons.radio_button_checked_outlined : Icons.radio_button_unchecked_outlined,
        color: Colors.black,
      ),
    );
  }

  Future<bool?> _showDoneChangedDialog(BuildContext context, WishData wishData, bool curStatus, dynamic opResult) {
    if (curStatus) {
      return _showDoneSureDialog(context, title: '确定要取消完成吗？');
    }
    final String? content;
    if (wishData.wishType == WishType.wish) {
      if (wishData.stepList?.isNotEmpty ?? false) {
        var count = (opResult as List<bool>).where((element) => !element).length;
        if (count == 0) {
          content = null;
        } else {
          content = '心愿下还有$count个未完成的步骤';
        }
      } else {
        content = null;
      }
    } else {
      content = null;
    }
    return _showDoneSureDialog(context, title: '确定要完成心愿吗？', content: content);
  }

  Future<bool?> _showDoneSureDialog(BuildContext context, {required String title, String? content}) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(title),
            content: content == null ? null : Text(content),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: const Text('取消')),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                  child: const Text('确定')),
            ],
          );
        });
  }
}

class OpPageView extends StatefulWidget {
  final WishData itemData;
  final int index;

  const OpPageView({super.key, required this.itemData, required this.index});

  @override
  State<StatefulWidget> createState() => _OpPageViewState();
}

class _OpPageViewState extends State<OpPageView> {
  final GlobalKey<_OpCardState> _opCardKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        _buildSliverAppBar(context),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
            child: TimeCard(
              itemData: widget.itemData,
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
              child: OpCard(
                key: _opCardKey,
                itemData: widget.itemData,
                index: widget.index,
              )),
        ),
        SliverToBoxAdapter(
          child: SizedBox(
            child: Stack(children: [
              Padding(
                padding: const EdgeInsets.only(left: 26, top: 25),
                child: RadiusLine(
                  width: 15,
                  height: 40,
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 40, right: 20, top: 10),
                child: Text(
                  WishLocalizations.of(context)!.opHistoryTitle,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ]),
          ),
        ),
        _OpHistoryLayout(wishData: widget.itemData),
      ],
    );
  }

  Widget _buildSliverAppBar(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    return SliverAppBar(
      expandedHeight: 110,
      actions: [
        Tooltip(
          message: WishLocalizations.of(context)!.edit,
          child: IconButton(
              onPressed: () {
                _gotoEditPage(context, widget.index);
              },
              icon: const Icon(Icons.edit_outlined)),
        )
      ],
      elevation: 5,
      pinned: true,
      // backgroundColor: Colors.orange,
      flexibleSpace: FlexibleSpaceBar(
          //伸展处布局
          titlePadding: const EdgeInsets.only(left: 55, bottom: 15, right: 30),
          //标题边距
          collapseMode: CollapseMode.parallax,
          //视差效果
          title: Text(
            widget.itemData.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontWeight: FontWeight.w700, color: colorScheme.primary),
          ),
          stretchModes: const [StretchMode.blurBackground, StretchMode.zoomBackground],
          expandedTitleScale: 24 / 20,
          background: SizedBox(
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 12, left: 20),
                child: Container(
                  width: 10,
                  height: 36,
                  decoration: BoxDecoration(
                    color: widget.itemData.colorType.toColor(),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
          )),
    );
  }

  _gotoEditPage(BuildContext context, int? index) async {
    final res = await Navigator.push(
        context,
        Right2LeftRouter(
            child: EditPage(
          index: index,
          pageType: WishPageType.edit,
          wishData: curWish,
          from: PageFrom.op,
        )));
    if (res == PageFrom.op && context.mounted) {
      Navigator.of(context).pop();
    }
  }

  get curWish {
    if (widget.itemData.wishType == WishType.wish) {
      var stepResult = _opCardKey.currentState?.stepResult;
      // 如果更新了step需要把这个变化带入到curWish里，暂时只需要这个属性到编辑页
      if (stepResult?.isNotEmpty ?? false) {
        List<WishStep> stepList = [];
        for (var i = 0; i < widget.itemData.stepList!.length; i++) {
          stepList.add(WishStep(widget.itemData.stepList![i].desc, stepResult![i]));
        }
        return widget.itemData.copyWith(stepList: stepList);
      }
    }
    return widget.itemData;
  }

  dynamic getOpResult() {
    if (widget.itemData.wishType == WishType.wish) {
      return _opCardKey.currentState?.stepResult;
    }
    if (widget.itemData.wishType == WishType.checkIn) {
      return _opCardKey.currentState?.checkInCount;
    }
    return _opCardKey.currentState?.actualRepeatCount;
  }
}

class _OpHistoryLayout extends StatefulWidget {
  final WishData wishData;

  const _OpHistoryLayout({required this.wishData});

  @override
  State<StatefulWidget> createState() => _OpHistoryLayoutState();
}

class _OpHistoryLayoutState extends State<_OpHistoryLayout> {
  List<WishOp> list = [];

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData() async {
    var res = await DatabaseHelper.instance.getOpListByWish(widget.wishData);
    if (context.mounted && (res?.isNotEmpty ?? false)) {
      setState(() {
        list = res!;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return OpList(
      list: list,
      padding: const EdgeInsets.only(left: 13, right: 20),
    );
  }
}

class TimeCard extends StatelessWidget {
  final WishData itemData;

  const TimeCard({super.key, required this.itemData});

  @override
  Widget build(BuildContext context) {
    var localizations = WishLocalizations.of(context)!;
    return ItemWrap(
        itemLabel: localizations.opTimeCardTitle,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ItemWrapLabelRow(
              label: localizations.opBeginTime,
              value: getDate(localizations, itemData.createdTime!),
              isLabelGray: true,
            ),
            const SizedBox(height: 6),
            ItemWrapLabelRow(
              label: localizations.opEndTime,
              value: itemData.endTime == null ? localizations.opNoEnd : getDate(localizations, itemData.endTime!),
              isLabelGray: true,
            ),
            const SizedBox(height: 6),
            ItemWrapLabelRow(
              label: localizations.opTimeContinuous,
              value: '${DateTime.now().difference(itemData.createdTime!).inDays + 1} ${localizations.days}',
              isLabelGray: true,
            ),
          ],
        ));
  }

  String getDate(WishLocalizations localizations, DateTime date) {
    // 今天、昨天、前天、明天、后天、周一、周二、周三、周四、周五、周六、周日
    int days = DateTime.now().difference(date).inDays;
    final String desc;

    switch (days) {
      case 0:
        desc = localizations.today;
        break;
      case 1:
        desc = localizations.yesterday;
        break;
      case 2:
        desc = localizations.beforeYesterday;
        break;
      case -1:
        desc = localizations.tomorrow;
        break;
      case -2:
        desc = localizations.afterTomorrow;
        break;
      default:
        desc = getWeek(localizations, date);
        break;
    }
    return '${date.year}-${date.month}-${date.day} $desc';
  }

  String getWeek(WishLocalizations localizations, DateTime date) {
    switch (date.weekday) {
      case 1:
        return localizations.weekday1;
      case 2:
        return localizations.weekday2;
      case 3:
        return localizations.weekday3;
      case 4:
        return localizations.weekday4;
      case 5:
        return localizations.weekday5;
      case 6:
        return localizations.weekday6;
      case 7:
      default:
        return localizations.weekday7;
    }
  }
}

class OpCard extends StatefulWidget {
  final WishData itemData;
  final int index;

  const OpCard({super.key, required this.itemData, required this.index});

  @override
  State<StatefulWidget> createState() => _OpCardState();
}

class _OpCardState extends State<OpCard> {
  final List<bool> _stepRecord = [];
  final GlobalKey _key = GlobalKey();
  Timer? _countUpdateDebounce;
  late int _actualRepeatCount;

  @override
  void initState() {
    super.initState();
    if (widget.itemData.stepList != null) {
      for (var item in widget.itemData.stepList!) {
        _stepRecord.add(item.done);
      }
    }
    _actualRepeatCount = widget.itemData.actualRepeatCount ?? 0;
  }

  @override
  void dispose() {
    _countUpdateDebounce?.cancel();
    super.dispose();
  }

  List<bool> get stepResult => _stepRecord;

  int get checkInCount {
    var state = _key.currentState as _CheckInContentState;
    return state._preCheckInCount + (state._todayCheckIn ? 1 : 0);
  }

  int get actualRepeatCount {
    var state = _key.currentState as WishSwitcherState;
    return state.count;
  }

  @override
  Widget build(BuildContext context) {
    final EdgeInsets padding;
    if (widget.itemData.wishType == WishType.repeat) {
      padding = const EdgeInsets.only(top: 14, right: 14, bottom: 4, left: 14);
    } else if (widget.itemData.wishType == WishType.checkIn) {
      padding = const EdgeInsets.only(top: 14, right: 14, bottom: 12, left: 14);
    } else {
      padding = const EdgeInsets.all(14);
    }

    return ItemWrap(
      itemLabel: WishLocalizations.of(context)!.opCardTitle,
      padding: padding,
      child: _buildContent(),
    );
  }

  _handleDoneStep(int stepIndex) async {
    var res = await DatabaseHelper.instance.handleDoneStep(widget.itemData, _generateSteps(), stepIndex);
    if (res > 0) {
      eventBus.fire(UpdateWishEvent(widget.index, widget.itemData.id!));
    }
  }

  _handleUpdateRepeat(int oldCount, int newCount) async {
    var res = await DatabaseHelper.instance.handleUpdateRepeat(widget.itemData, oldCount, newCount);
    if (res > 0) {
      eventBus.fire(UpdateWishEvent(widget.index, widget.itemData.id!));
    }
  }

  Widget _buildContent() {
    var localizations = WishLocalizations.of(context)!;
    if (widget.itemData.wishType == WishType.wish) {
      if (widget.itemData.stepList == null || widget.itemData.stepList!.isEmpty) {
        return SizedBox(
            width: double.infinity,
            child: Text(localizations.opStepsTip, style: const TextStyle(fontSize: 16, color: Colors.grey)));
      } else {
        return Column(
          // 带index的遍历
          children: widget.itemData.stepList!
              .asMap()
              .map((i, step) => MapEntry(
                  i,
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
                    child: RadioCheck(
                      initValue: step.done,
                      desc: step.desc,
                      onChanged: (value) {
                        _stepRecord[i] = value;
                        _handleDoneStep(i);
                      },
                    ),
                  )))
              .values
              .toList(),
        );
      }
    }
    if (widget.itemData.wishType == WishType.repeat) {
      return Column(
        children: [
          ItemWrapLabelRow(
              label: localizations.opTargetTimes, value: '${widget.itemData.repeatCount}${localizations.opTimesUnit}'),
          Row(
            children: [
              SizedBox(
                  width: HookData.instance.labelWidth,
                  child: Text(localizations.opDoneTimes,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700))),
              Transform.scale(
                scale: 0.9,
                child: Transform.translate(
                  offset: const Offset(-10, 0),
                  child: WishSwitcher(
                    key: _key,
                    initCount: widget.itemData.actualRepeatCount,
                    onChanged: (value) {
                      // 更新数据库
                      if (_countUpdateDebounce?.isActive ?? false) {
                        _countUpdateDebounce!.cancel();
                      }
                      _countUpdateDebounce = Timer(const Duration(milliseconds: 500), () {
                        _handleUpdateRepeat(_actualRepeatCount, value);
                        _actualRepeatCount = value;
                      });
                    },
                  ),
                ),
              ),
            ],
          ),
        ],
      );
    }
    return CheckInContent(
      key: _key,
      itemData: widget.itemData,
      index: widget.index,
    );
  }

  List<WishStep> _generateSteps() {
    final List<WishStep> steps = [];
    for (var i = 0; i < _stepRecord.length; i++) {
      steps.add(WishStep(widget.itemData.stepList![i].desc, _stepRecord[i]));
    }
    return steps;
  }
}

class CheckInContent extends StatefulWidget {
  final WishData itemData;
  final int index;

  const CheckInContent({super.key, required this.itemData, required this.index});

  @override
  State<StatefulWidget> createState() => _CheckInContentState();
}

class _CheckInContentState extends State<CheckInContent> {
  late int _preCheckInCount;
  late bool _todayCheckIn;
  late bool _isPaused;

  _handleCheckIn() async {
    var res = await DatabaseHelper.instance.handleCheckIn(widget.itemData);
    if (res > 0) {
      eventBus.fire(UpdateWishEvent(widget.index, widget.itemData.id!));
    }
  }

  _handlePause(bool isPaused) async {
    var res = await DatabaseHelper.instance.handlePauseOp(widget.itemData, isPaused);
    if (res > 0) {
      eventBus.fire(UpdateWishEvent(widget.index, widget.itemData.id!));
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.itemData.checkedTimeList == null || widget.itemData.checkedTimeList!.isEmpty) {
      _preCheckInCount = 0;
      _todayCheckIn = false;
    } else {
      final latestTime = widget.itemData.checkedTimeList!.last;
      final isToday = DateTime.now().difference(latestTime).inDays == 0;
      if (isToday) {
        _preCheckInCount = widget.itemData.checkedTimeList!.length - 1;
        _todayCheckIn = true;
      } else {
        _preCheckInCount = widget.itemData.checkedTimeList!.length;
        _todayCheckIn = false;
      }
    }
    _isPaused = widget.itemData.paused;
  }

  @override
  Widget build(BuildContext context) {
    final latestTime = widget.itemData.checkedTimeList?.last;
    final int? days;
    if (latestTime == null) {
      days = null;
    } else {
      days = DateTime.now().difference(latestTime).inDays;
    }
    var localizations = WishLocalizations.of(context)!;

    return Column(
      children: [
        ItemWrapLabelRow(label: localizations.opPeriodLabel, value: localizations.opPeriodDetail(widget.itemData.periodDays!)),
        const SizedBox(
          height: 6,
        ),
        ItemWrapLabelRow(
            label: localizations.opCheckInTimeLabel, value: TimeUtils.getShowTime(widget.itemData.checkInTime!)),
        const SizedBox(
          height: 6,
        ),
        ItemWrapLabelRow(
            label: localizations.opCheckTimesLabel, value: '${_preCheckInCount + (_todayCheckIn ? 1 : 0)} ${localizations.opTimesUnit}'),
        if (days != null) ...[
          const SizedBox(
            height: 6,
          ),
          ItemWrapLabelRow(
              label: localizations.opLastCheckInLabel,
              value: _getLatestCheckIn(localizations, days, widget.itemData.periodDays!)),
        ],
        SizedBox(
          height: 34,
          child: Row(
            children: [
              SizedBox(
                  width: HookData.instance.labelWidth,
                  child: Text(localizations.opTodayCheckIn,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700))),
              DoneSwitch(
                labelWidth: HookData.instance.switchLabelWidth,
                noText: localizations.opNoCheckedIn,
                yesText: localizations.opCheckedIn,
                contentPadding: 0,
                initValue: _todayCheckIn,
                textSize: 16,
                switchScale: 1,
                onChanged: (v) {
                  setState(() {
                    _todayCheckIn = v;
                  });
                  _handleCheckIn();
                },
                toggleable: (value) => !value,
              ),
            ],
          ),
        ),
        SizedBox(
          height: 25,
          child: Row(
            children: [
              SizedBox(
                  width: HookData.instance.labelWidth,
                  child: Tooltip(
                    message: localizations.opPauseTip,
                    child: Text(localizations.opPauseCheckInLabel,
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                  )),
              DoneSwitch(
                labelWidth: HookData.instance.switchLabelWidth,
                noText: localizations.opPaused,
                yesText: localizations.opDoing,
                contentPadding: 0,
                initValue: !_isPaused,
                textSize: 16,
                switchScale: 1,
                onChanged: (v) {
                  setState(() {
                    _isPaused = !v;
                    _handlePause(_isPaused);
                  });
                },
                // toggleable: (value) => !value,
              ),
            ],
          ),
        )
      ],
    );
  }

  String _getLatestCheckIn(WishLocalizations localizations, int days, int periodDays) {
    if (periodDays < days) {
      return '${TimeUtils.getShowDate(widget.itemData.checkedTimeList!.last)}  已超过$periodDays天未打卡了';
    }
    switch (days) {
      case 0:
        return localizations.today;
      case 1:
        return localizations.yesterday;
      case 2:
        return localizations.beforeYesterday;
      default:
        return TimeUtils.getShowDate(widget.itemData.checkedTimeList!.last);
    }
  }
}
