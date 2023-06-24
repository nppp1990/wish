import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:pie_chart/pie_chart.dart';
import 'package:wish/data/data_base_helper.dart';
import 'package:wish/data/wish_op.dart';
import 'package:wish/data/wish_review.dart';
import 'package:wish/utils/timeUtils.dart';
import 'package:wish/widgets/card_item.dart';
import 'package:wish/widgets/common/animation_layout.dart';
import 'package:wish/widgets/common/wish_loading.dart';
import 'package:wish/widgets/op/op_list.dart';
import 'package:flutter_gen/gen_l10n/wish_localizations.dart';

class ReviewPage extends StatelessWidget {
  const ReviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: ReviewPageView(),
    );
  }
}

class ReviewPageView extends StatefulWidget {
  const ReviewPageView({super.key});

  @override
  State<StatefulWidget> createState() => _ReviewPageViewState();
}

class _ReviewPageViewState extends State<ReviewPageView> {
  WishLoadingType _loadingType = WishLoadingType.loading;
  List<WishOp>? _opList;
  WishStatics? _wishStatics;
  late TimeType _timeType = TimeType.latestWeek;
  DateTimeRange? _dateTimeRange;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  get _loadingRange {
    switch (_timeType) {
      case TimeType.latestWeek:
        return DateTimeRange(start: DateTime.now().subtract(const Duration(days: 7)), end: DateTime.now());
      case TimeType.latestMonth:
        return DateTimeRange(start: DateTime.now().subtract(const Duration(days: 30)), end: DateTime.now());
      case TimeType.today:
        return DateTimeRange(start: DateTime.now(), end: DateTime.now());
      case TimeType.custom:
        return _dateTimeRange;
    }
  }

  loadData() async {
    setState(() {
      _loadingType = WishLoadingType.loading;
    });

    var res = await DatabaseHelper.instance.getReviewInfo(_loadingRange);
    if (res == null) {
      setState(() {
        _loadingType = WishLoadingType.error;
      });
    } else {
      setState(() {
        _loadingType = WishLoadingType.success;
        _opList = res.second;
        _wishStatics = WishStatics.fromWishList(res.first);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        _buildSliverAppBar(context),
        if (_loadingType == WishLoadingType.success)
          SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              sliver: SliverToBoxAdapter(
                child: _SummaryCard(
                  totalCount: _wishStatics!.total,
                  doneCount: _wishStatics!.done,
                  delayCount: _wishStatics!.delay!,
                ),
              )),
        if (_loadingType == WishLoadingType.success)
          SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              sliver: SliverToBoxAdapter(
                child: ItemWrap(
                    itemLabel: getLabelShow(context, _timeType, _dateTimeRange, false),
                    onLabelPressed: () {
                      _showTimeDialog(_timeType);
                    },
                    child: _buildChart(context, _opList!)),
              )),
        if (_loadingType == WishLoadingType.success && (_opList?.isNotEmpty ?? false))
          SliverPadding(
            padding: const EdgeInsets.all(20),
            sliver: OpList(
              option: OpListOption(showEdit: false, showName: true),
              list: _opList!,
            ),
          ),
      ],
    );
  }

  Widget _buildSliverAppBar(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    var localizations = WishLocalizations.of(context)!;
    return SliverAppBar(
        expandedHeight: 160,
        elevation: 5,
        pinned: true,
        flexibleSpace: FlexibleSpaceBar(
          //伸展处布局
          titlePadding: const EdgeInsets.only(left: 55, bottom: 15, right: 30),
          //标题边距
          collapseMode: CollapseMode.parallax,
          //视差效果
          title: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              return Text(
                localizations.reviewTitle,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: constraints.maxHeight > 90 ? colorScheme.secondary : colorScheme.primary,
                ),
              );
            },
          ),
          stretchModes: const [StretchMode.blurBackground, StretchMode.zoomBackground],
          expandedTitleScale: 30 / 20,
          background: Container(
              color: const Color(0xff545454),
              child: Stack(
                children: [
                  Positioned(
                    bottom: 35,
                    right: 20,
                    child: UpAnimationLayout(
                      autoStartTime: const Duration(milliseconds: 500),
                      duration: const Duration(milliseconds: 500),
                      upOffset: 0.2,
                      child: Text(
                        localizations.reviewHeaderText,
                        style: const TextStyle(fontSize: 16, color: Colors.white70, fontWeight: FontWeight.w400),
                      ),
                    ),
                  ),
                  if (_loadingType == WishLoadingType.loading)
                    Positioned(
                        left: 120,
                        bottom: 15,
                        child: Transform.scale(
                            scale: 0.65,
                            child: const CircularProgressIndicator(
                              color: Colors.white70,
                              strokeWidth: 8,
                            ))),
                ],
              )),
        ));
  }

  Widget _buildChart(BuildContext context, List<WishOp> opList) {
    WishLocalizations localizations = WishLocalizations.of(context)!;

    int createCount = 0;
    Map<int, bool> pausedMap = {};
    Map<int, bool> doneMap = {};
    int deleteCount = 0;

    for (var opItem in opList) {
      if (opItem.opType == WishOpType.create) {
        createCount++;
      } else if (opItem.opType == WishOpType.delete) {
        deleteCount++;
      } else if (opItem.opType == WishOpType.done) {
        doneMap[opItem.wishId] = opItem.isDone!;
      } else if (opItem.opType == WishOpType.pause) {
        pausedMap[opItem.wishId] = opItem.isPaused!;
      }
    }

    int doneCount = doneMap.values.where((element) => element).length;
    int unDoneCount = doneMap.length - doneCount;
    int pausedCount = pausedMap.values.where((element) => element).length;

    final dataMap = <String, double>{
      'create': createCount.toDouble(),
      'done': doneCount.toDouble(),
      'undone': unDoneCount.toDouble(),
      'pause': pausedCount.toDouble(),
      'delete': deleteCount.toDouble(),
    };

    final legendLabels = <String, String>{
      'create': localizations.reviewCreateLabel(createCount),
      'done': localizations.reviewDoneLabel(doneCount),
      'undone': localizations.reviewUndoneLabel(unDoneCount),
      'pause': localizations.reviewPauseLabel(pausedCount),
      'delete': localizations.reviewDeleteLabel(deleteCount),
    };

    var colorScheme = Theme.of(context).colorScheme;
    final colorList = <Color>[
      colorScheme.primary.withOpacity(0.86),
      Colors.green,
      colorScheme.primary.withOpacity(0.12),
      Colors.yellow,
      Colors.red,
    ];

    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: PieChart(
        // key: ValueKey(key),
        dataMap: dataMap,
        animationDuration: const Duration(milliseconds: 800),
        chartLegendSpacing: 40,
        chartRadius: math.min(MediaQuery.of(context).size.width / 3.2, 300),
        colorList: colorList,
        initialAngleInDegree: 0,
        chartType: ChartType.ring,
        // centerText: _showCenterText ? "HYBRID" : null,
        legendLabels: legendLabels,
        legendOptions: const LegendOptions(
          showLegendsInRow: false,
          legendPosition: LegendPosition.left,
          // showLegends: _showLegends,
          legendShape: BoxShape.circle,
          legendTextStyle: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 14,
          ),
        ),
        chartValuesOptions: const ChartValuesOptions(
          showChartValuesInPercentage: true,
          showChartValuesOutside: true,
        ),
        ringStrokeWidth: 32,
        emptyColor: const Color(0xff545454),
        baseChartColor: Colors.transparent,
      ),
    );
  }

  String getLabelShow(BuildContext context, TimeType timeType, DateTimeRange? range, bool showPrefix) {
    if (timeType == TimeType.custom && range != null) {
      if (showPrefix) {
        return '${WishLocalizations.of(context)!.custom}(${TimeUtils.getShowDate(range.start)} ~ ${TimeUtils.getShowDate(range.end)})';
      } else {
        return '${TimeUtils.getShowDate(range.start)} ~ ${TimeUtils.getShowDate(range.end)}';
      }
    } else {
      return timeType.getShowTitle(context);
    }
  }

  _showTimeDialog(TimeType curType) async {
    buildItem(TimeType itemType, bool selected) {
      return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          Navigator.pop(context, itemType);
        },
        child: SizedBox(
          height: 40,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(getLabelShow(context, itemType, _dateTimeRange, true),
                  style: TextStyle(fontSize: 15, fontWeight: selected ? FontWeight.w700 : FontWeight.w500)),
            ],
          ),
        ),
      );
    }

    var res = await showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (context) {
          return Container(
            margin: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
            padding: const EdgeInsets.only(left: 20, right: 20, bottom: 3),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), color: Colors.white),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    WishLocalizations.of(context)!.reviewTimeDialogTitle,
                    style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 20),
                  ),
                ),
                buildItem(TimeType.today, curType == TimeType.today),
                const Divider(height: 1, thickness: 1, color: Color(0xfff0f0f0)),
                buildItem(TimeType.latestWeek, curType == TimeType.latestWeek),
                const Divider(height: 1, thickness: 1, color: Color(0xfff0f0f0)),
                buildItem(TimeType.latestMonth, curType == TimeType.latestMonth),
                const Divider(height: 1, thickness: 1, color: Color(0xfff0f0f0)),
                buildItem(TimeType.custom, curType == TimeType.custom),
              ],
            ),
          );
        });
    if (res == TimeType.custom) {
      DateTimeRange? range = await _showCustomTimeDialog(_dateTimeRange);
      if (range == null) {
        return;
      }
      if (range == _dateTimeRange) {
        return;
      }
      setState(() {
        _timeType = TimeType.custom;
        _dateTimeRange = range;
        loadData();
      });
    } else {
      if (_timeType == res) {
        return;
      }
      setState(() {
        _dateTimeRange = null;
        _timeType = res;
        loadData();
      });
    }
  }

  _showCustomTimeDialog(DateTimeRange? dateTimeRange) async {
    DateTime firstDate = DateTime(2023, 6, 10);
    DateTime lastDate = DateTime.now();
    return await showDateRangePicker(
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            brightness: Brightness.light,
            colorScheme: const ColorScheme.light(primary: Colors.black),
            buttonTheme: const ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child!,
        );
      },
      context: context,
      firstDate: firstDate,
      lastDate: lastDate,
      initialDateRange: dateTimeRange,
      // helpText: '选择时间段',
      // cancelText: '取消',
      // confirmText: '确定',
      // saveText: "确定",
      // fieldEndLabelText: '结束时间',
      // fieldStartLabelText: '开始时间',
      // fieldStartHintText: '开始时间',
      // fieldEndHintText: '结束时间',
    );
  }
}

enum TimeType {
  today,
  latestWeek,
  latestMonth,
  custom;

  getShowTitle(BuildContext context) {
    var localizations = WishLocalizations.of(context)!;
    switch (this) {
      case TimeType.today:
        return localizations.timeToday;
      case TimeType.latestWeek:
        return localizations.timeLatestWeek;
      case TimeType.latestMonth:
        return localizations.timeLatestMonth;
      case TimeType.custom:
        return localizations.custom;
    }
  }
}

class _SummaryCard extends StatelessWidget {
  final int totalCount;
  final int doneCount;
  final int delayCount;

  const _SummaryCard({required this.totalCount, required this.doneCount, required this.delayCount});

  @override
  Widget build(BuildContext context) {
    var localizations = WishLocalizations.of(context)!;
    return ItemWrap(
      itemLabel: localizations.reviewWishSummary,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ItemWrapLabelRow(
            label: localizations.reviewWishTotal,
            value: totalCount.toString(),
            isLabelGray: true,
          ),
          const SizedBox(height: 6),
          ItemWrapLabelRow(
            label: localizations.reviewDoneWish,
            value: doneCount.toString(),
            isLabelGray: true,
          ),
          const SizedBox(height: 6),
          ItemWrapLabelRow(
            label: localizations.reviewDelayWish,
            value: delayCount.toString(),
            isLabelGray: true,
          ),
        ],
      ),
    );
  }
}

enum LegendShape { circle, rectangle }
