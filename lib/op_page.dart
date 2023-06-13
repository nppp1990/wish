import 'dart:async';

import 'package:flutter/material.dart';
import 'package:wish/data/data_base_helper.dart';
import 'package:wish/data/event_manager.dart';
import 'package:wish/data/wish_data.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:wish/data/wish_op.dart';
import 'package:wish/edit_page.dart';
import 'package:wish/router/router_utils.dart';
import 'package:wish/utils/timeUtils.dart';
import 'package:wish/widgets/op/done_switch.dart';
import 'package:wish/widgets/op/op_list.dart';
import 'package:wish/widgets/op/radio_check.dart';
import 'package:wish/widgets/op/radius_line.dart';
import 'package:wish/widgets/switch_num.dart';

const double labelWidth = 90.0;

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

  Future<bool?> _showDoneChangedDialog(
      BuildContext context, WishData wishData, bool curStatus, dynamic opResult) {
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

  Future<bool?> _showDoneSureDialog(BuildContext context,
      {required String title, String? content}) {
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
                  color: Colors.black.withOpacity(0.2),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(left: 40, right: 20, top: 10),
                child: Text(
                  '心愿足迹',
                  style: TextStyle(
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
    return SliverAppBar(
      expandedHeight: 110,
      actions: [
        Tooltip(
          message: '编辑',
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
          titlePadding: const EdgeInsets.only(left: 55, bottom: 15),
          //标题边距
          collapseMode: CollapseMode.parallax,
          //视差效果
          title: Text(
            widget.itemData.name,
            maxLines: 1,
            overflow: TextOverflow.fade,
            style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w700),
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

class ItemWrapLabelRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isLabelGray;

  const ItemWrapLabelRow(
      {super.key, required this.label, required this.value, this.isLabelGray = false});

  @override
  Widget build(BuildContext context) {
    if (isLabelGray) {
      return Row(
        children: [
          SizedBox(
              width: labelWidth,
              child:
                  Text(label, style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 16))),
          Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
        ],
      );
    } else {
      return Row(
        children: [
          SizedBox(
              width: labelWidth,
              child:
                  Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700))),
          Text(value, style: const TextStyle(fontSize: 16, color: Colors.grey)),
        ],
      );
    }
  }
}

class ItemWrap extends StatelessWidget {
  final String itemLabel;
  final Widget child;
  final EdgeInsets padding;

  const ItemWrap(
      {super.key,
      required this.child,
      required this.itemLabel,
      this.padding = const EdgeInsets.all(14)});

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Padding(
        padding: const EdgeInsets.only(top: 14),
        child: DottedBorder(
          borderType: BorderType.RRect,
          dashPattern: const [8, 4],
          color: Colors.black,
          radius: const Radius.circular(12),
          padding: padding,
          child: child,
        ),
      ),
      Positioned(
          left: 20,
          top: 0,
          child: Container(
            color: Colors.white,
            child: Text(
              itemLabel,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
          ))
    ]);
  }
}

class TimeCard extends StatelessWidget {
  final WishData itemData;

  const TimeCard({super.key, required this.itemData});

  @override
  Widget build(BuildContext context) {
    return ItemWrap(
        itemLabel: '心愿时间',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ItemWrapLabelRow(
              label: '开始时间',
              value: getDate(itemData.createdTime!),
              isLabelGray: true,
            ),
            const SizedBox(height: 6),
            ItemWrapLabelRow(
              label: '截止时间',
              value: itemData.endTime == null ? '无期限' : getDate(itemData.endTime!),
              isLabelGray: true,
            ),
            const SizedBox(height: 6),
            ItemWrapLabelRow(
              label: '已持续',
              value: '${DateTime.now().difference(itemData.createdTime!).inDays + 1} 天',
              isLabelGray: true,
            ),
          ],
        ));
  }

  String getDate(DateTime date) {
    // 今天、昨天、前天、明天、后天、周一、周二、周三、周四、周五、周六、周日
    int days = DateTime.now().difference(date).inDays;
    final String desc;

    switch (days) {
      case 0:
        desc = '今天';
        break;
      case 1:
        desc = '昨天';
        break;
      case 2:
        desc = '前天';
        break;
      case -1:
        desc = '明天';
        break;
      case -2:
        desc = '后天';
        break;
      default:
        desc = getWeek(date);
        break;
    }
    return '${date.year}-${date.month}-${date.day} $desc';
  }

  static const List<String> _weekList = ['一', '二', '三', '四', '五', '六', '日'];

  String getWeek(DateTime date) {
    return '周${_weekList[date.weekday - 1]}';
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
      padding = const EdgeInsets.only(top: 14, right: 14, bottom: 0, left: 14);
    } else {
      padding = const EdgeInsets.all(14);
    }

    return ItemWrap(
      itemLabel: '进度更新',
      padding: padding,
      child: _buildContent(),
    );
  }

  _handleDoneStep(int stepIndex) async {
    var res =
        await DatabaseHelper.instance.handleDoneStep(widget.itemData, _generateSteps(), stepIndex);
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
    if (widget.itemData.wishType == WishType.wish) {
      if (widget.itemData.stepList == null || widget.itemData.stepList!.isEmpty) {
        return const SizedBox(
            width: double.infinity,
            child: Text('未设置计划步骤，可点击右下角按钮、直接完成或取消完成心愿',
                style: TextStyle(fontSize: 16, color: Colors.grey)));
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
          ItemWrapLabelRow(label: '目标次数', value: '${widget.itemData.repeatCount}次'),
          Row(
            children: [
              const SizedBox(
                  width: labelWidth,
                  child:
                      Text('已完成次数', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700))),
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

  _handleCheckIn() async {
    var res = await DatabaseHelper.instance.handleCheckIn(widget.itemData);
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

    return Column(
      children: [
        ItemWrapLabelRow(label: '打卡间隔', value: '每 ${widget.itemData.periodDays} 天一次'),
        const SizedBox(
          height: 6,
        ),
        ItemWrapLabelRow(label: '打卡时间', value: TimeUtils.getShowTime(widget.itemData.checkInTime!)),
        const SizedBox(
          height: 6,
        ),
        ItemWrapLabelRow(label: '打卡次数', value: '${_preCheckInCount + (_todayCheckIn ? 1 : 0)} 次'),
        if (days != null) ...[
          const SizedBox(
            height: 6,
          ),
          ItemWrapLabelRow(
              label: '上次打卡', value: _getLatestCheckin(days, widget.itemData.periodDays!)),
        ],
        Transform.translate(
          offset: const Offset(0, -6),
          child: Row(
            children: [
              const SizedBox(
                  width: labelWidth,
                  child: Text('今日打卡', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700))),
              DoneSwitch(
                openText: '未打卡',
                closeText: '已打卡',
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
        )
      ],
    );
  }

  String _getLatestCheckin(int days, int periodDays) {
    if (periodDays < days) {
      return '${TimeUtils.getShowDate(widget.itemData.checkedTimeList!.last)}  已超过$periodDays天未打卡了';
    }
    switch (days) {
      case 0:
        return '今天';
      case 1:
        return '昨天';
      case 2:
        return '前天';
      default:
        return TimeUtils.getShowDate(widget.itemData.checkedTimeList!.last);
    }
  }
}
