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
  late TimeType _timeType = TimeType.lastWeek;
  DateTimeRange? _dateTimeRange;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  get _loadingRange {
    switch (_timeType) {
      case TimeType.lastWeek:
        return DateTimeRange(
            start: DateTime.now().subtract(const Duration(days: 7)),
            end: DateTime.now());
      case TimeType.lastMonth:
        return DateTimeRange(
            start: DateTime.now().subtract(const Duration(days: 30)),
            end: DateTime.now());
      case TimeType.today:
        return DateTimeRange(
            start: DateTime.now(),
            end: DateTime.now());
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
                    itemLabel: getLabelShow(_timeType, _dateTimeRange, false),
                    onLabelPressed: () {
                      _showTimeDialog(_timeType);
                    },
                    child: _buildChart(_opList!)),
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
                '回顾',
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
                  const Positioned(
                    bottom: 30,
                    right: 20,
                    child: UpAnimationLayout(
                      autoStartTime: Duration(milliseconds: 500),
                      duration: Duration(milliseconds: 500),
                      upOffset: 0.2,
                      child: Text(
                        '光写下心愿还不够\n还要付出努力实现哦',
                        style: TextStyle(fontSize: 16, color: Colors.white70, fontWeight: FontWeight.w400),
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

  Widget _buildChart(List<WishOp> opList) {
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

    int doneCount = doneMap.values
        .where((element) => element)
        .length;
    int unDoneCount = doneMap.length - doneCount;
    int pausedCount = pausedMap.values
        .where((element) => element)
        .length;

    final dataMap = <String, double>{
      'create': createCount.toDouble(),
      'done': doneCount.toDouble(),
      'undone': unDoneCount.toDouble(),
      'pause': pausedCount.toDouble(),
      'delete': deleteCount.toDouble(),
    };

    final legendLabels = <String, String>{
      'create': '创建 $createCount',
      'done': '完成 $doneCount',
      'undone': '重启 $unDoneCount',
      'pause': '暂停 $pausedCount',
      'delete': '删除 $deleteCount',
    };

    bool isLight = Theme.of(context).brightness == Brightness.light;
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
        chartRadius: math.min(MediaQuery
            .of(context)
            .size
            .width / 3.2, 300),
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

  String getLabelShow(TimeType timeType, DateTimeRange? range, bool showPrefix) {
    if (timeType == TimeType.custom && range != null) {
      if (showPrefix) {
        return '自定义(${TimeUtils.getShowDate(range.start)} ~ ${TimeUtils.getShowDate(range.end)})';
      } else {
        return '${TimeUtils.getShowDate(range.start)} ~ ${TimeUtils.getShowDate(range.end)}';
      }
    } else {
      return timeType.toString();
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
              Text(getLabelShow(itemType, _dateTimeRange, true),
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
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    '请选择时间段',
                    style: TextStyle(fontWeight: FontWeight.w800, fontSize: 20),
                  ),
                ),
                buildItem(TimeType.today, curType == TimeType.today),
                const Divider(height: 1, thickness: 1, color: Color(0xfff0f0f0)),
                buildItem(TimeType.lastWeek, curType == TimeType.lastWeek),
                const Divider(height: 1, thickness: 1, color: Color(0xfff0f0f0)),
                buildItem(TimeType.lastMonth, curType == TimeType.lastMonth),
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
      // initialDateRange: DateTimeRange(
      //   start: start,
      //   end: end,
      // ),
      helpText: '选择时间段',
      cancelText: '取消',
      confirmText: '确定',
      saveText: "确定",
      // fieldEndLabelText: '结束时间',
      // fieldStartLabelText: '开始时间',
      fieldStartHintText: '开始时间',
      fieldEndHintText: '结束时间',
    );
  }
}

enum TimeType {
  today,
  lastWeek,
  lastMonth,
  custom;

  @override
  toString() {
    switch (this) {
      case TimeType.today:
        return '今天';
      case TimeType.lastWeek:
        return '最近一周';
      case TimeType.lastMonth:
        return '最近一月';
      case TimeType.custom:
        return '自定义';
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
    return ItemWrap(
      itemLabel: '所有星愿概览',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ItemWrapLabelRow(
            label: '心愿总数',
            value: totalCount.toString(),
            isLabelGray: true,
          ),
          const SizedBox(height: 6),
          ItemWrapLabelRow(
            label: '已完成心愿',
            value: doneCount.toString(),
            isLabelGray: true,
          ),
          const SizedBox(height: 6),
          ItemWrapLabelRow(
            label: '已延期',
            value: delayCount.toString(),
            isLabelGray: true,
          ),
        ],
      ),
    );
  }
}

enum LegendShape { circle, rectangle }

class TestPage extends StatefulWidget {
  const TestPage({Key? key}) : super(key: key);

  @override
  TestPageState createState() => TestPageState();
}

class TestPageState extends State<TestPage> {
  @override
  void initState() {
    super.initState();
  }

  final dataMap = <String, double>{
    "Flutter": 5,
    "React": 3,
    "Xamarin": 2,
    "Ionic": 2,
  };

  final legendLabels = <String, String>{
    "Flutter": "Flutter legend",
    "React": "React legend",
    "Xamarin": "Xamarin legend",
    "Ionic": "Ionic legend",
  };

  final colorList = <Color>[
    const Color(0xfffdcb6e),
    const Color(0xff0984e3),
    const Color(0xfffd79a8),
    const Color(0xffe17055),
    const Color(0xff6c5ce7),
  ];

  final gradientList = <List<Color>>[
    [
      const Color.fromRGBO(223, 250, 92, 1),
      const Color.fromRGBO(129, 250, 112, 1),
    ],
    [
      const Color.fromRGBO(129, 182, 205, 1),
      const Color.fromRGBO(91, 253, 199, 1),
    ],
    [
      const Color.fromRGBO(175, 63, 62, 1.0),
      const Color.fromRGBO(254, 154, 92, 1),
    ]
  ];
  ChartType? _chartType = ChartType.disc;
  bool _showCenterText = true;
  double? _ringStrokeWidth = 32;
  double? _chartLegendSpacing = 32;

  bool _showLegendsInRow = false;
  bool _showLegends = true;
  bool _showLegendLabel = false;

  bool _showChartValueBackground = true;
  bool _showChartValues = true;
  bool _showChartValuesInPercentage = false;
  bool _showChartValuesOutside = false;

  bool _showGradientColors = false;

  LegendShape? _legendShape = LegendShape.circle;
  LegendPosition? _legendPosition = LegendPosition.right;

  int key = 0;

  @override
  Widget build(BuildContext context) {
    final chart = PieChart(
      key: ValueKey(key),
      dataMap: dataMap,
      animationDuration: const Duration(milliseconds: 800),
      chartLegendSpacing: _chartLegendSpacing!,
      chartRadius: math.min(MediaQuery
          .of(context)
          .size
          .width / 3.2, 300),
      colorList: colorList,
      initialAngleInDegree: 0,
      chartType: _chartType!,
      centerText: _showCenterText ? "HYBRID" : null,
      legendLabels: _showLegendLabel ? legendLabels : {},
      legendOptions: LegendOptions(
        showLegendsInRow: _showLegendsInRow,
        legendPosition: _legendPosition!,
        showLegends: _showLegends,
        legendShape: _legendShape == LegendShape.circle ? BoxShape.circle : BoxShape.rectangle,
        legendTextStyle: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      chartValuesOptions: ChartValuesOptions(
        showChartValueBackground: _showChartValueBackground,
        showChartValues: _showChartValues,
        showChartValuesInPercentage: _showChartValuesInPercentage,
        showChartValuesOutside: _showChartValuesOutside,
      ),
      ringStrokeWidth: _ringStrokeWidth!,
      emptyColor: Colors.grey,
      gradientList: _showGradientColors ? gradientList : null,
      emptyColorGradient: const [
        Color(0xff6c5ce7),
        Colors.blue,
      ],
      baseChartColor: Colors.transparent,
    );
    final settings = SingleChildScrollView(
      child: Card(
        margin: const EdgeInsets.all(12),
        child: Column(
          children: [
            SwitchListTile(
              value: _showGradientColors,
              title: const Text("Show Gradient Colors"),
              onChanged: (val) {
                setState(() {
                  _showGradientColors = val;
                });
              },
            ),
            ListTile(
              title: Text(
                'Pie Chart Options'.toUpperCase(),
                style: Theme
                    .of(context)
                    .textTheme
                    .overline!
                    .copyWith(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ListTile(
              title: const Text("chartType"),
              trailing: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: DropdownButton<ChartType>(
                  value: _chartType,
                  items: const [
                    DropdownMenuItem(
                      value: ChartType.disc,
                      child: Text("disc"),
                    ),
                    DropdownMenuItem(
                      value: ChartType.ring,
                      child: Text("ring"),
                    ),
                  ],
                  onChanged: (val) {
                    setState(() {
                      _chartType = val;
                    });
                  },
                ),
              ),
            ),
            ListTile(
              title: const Text("ringStrokeWidth"),
              trailing: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: DropdownButton<double>(
                  value: _ringStrokeWidth,
                  disabledHint: const Text("select chartType.ring"),
                  items: const [
                    DropdownMenuItem(
                      value: 16,
                      child: Text("16"),
                    ),
                    DropdownMenuItem(
                      value: 32,
                      child: Text("32"),
                    ),
                    DropdownMenuItem(
                      value: 48,
                      child: Text("48"),
                    ),
                  ],
                  onChanged: (_chartType == ChartType.ring)
                      ? (val) {
                    setState(() {
                      _ringStrokeWidth = val;
                    });
                  }
                      : null,
                ),
              ),
            ),
            SwitchListTile(
              value: _showCenterText,
              title: const Text("showCenterText"),
              onChanged: (val) {
                setState(() {
                  _showCenterText = val;
                });
              },
            ),
            ListTile(
              title: const Text("chartLegendSpacing"),
              trailing: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: DropdownButton<double>(
                  value: _chartLegendSpacing,
                  disabledHint: const Text("select chartType.ring"),
                  items: const [
                    DropdownMenuItem(
                      value: 16,
                      child: Text("16"),
                    ),
                    DropdownMenuItem(
                      value: 32,
                      child: Text("32"),
                    ),
                    DropdownMenuItem(
                      value: 48,
                      child: Text("48"),
                    ),
                    DropdownMenuItem(
                      value: 64,
                      child: Text("64"),
                    ),
                  ],
                  onChanged: (val) {
                    setState(() {
                      _chartLegendSpacing = val;
                    });
                  },
                ),
              ),
            ),
            ListTile(
              title: Text(
                'Legend Options'.toUpperCase(),
                style: Theme
                    .of(context)
                    .textTheme
                    .overline!
                    .copyWith(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SwitchListTile(
              value: _showLegends,
              title: const Text("showLegends"),
              onChanged: (val) {
                setState(() {
                  _showLegends = val;
                });
              },
            ),
            SwitchListTile(
              value: _showLegendsInRow,
              title: const Text("showLegendsInRow"),
              onChanged: (val) {
                setState(() {
                  _showLegendsInRow = val;
                });
              },
            ),
            SwitchListTile(
              value: _showLegendLabel,
              title: const Text("showLegendLabels"),
              onChanged: (val) {
                setState(() {
                  _showLegendLabel = val;
                });
              },
            ),
            ListTile(
              title: const Text("legendShape"),
              trailing: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: DropdownButton<LegendShape>(
                  value: _legendShape,
                  items: const [
                    DropdownMenuItem(
                      value: LegendShape.circle,
                      child: Text("BoxShape.circle"),
                    ),
                    DropdownMenuItem(
                      value: LegendShape.rectangle,
                      child: Text("BoxShape.rectangle"),
                    ),
                  ],
                  onChanged: (val) {
                    setState(() {
                      _legendShape = val;
                    });
                  },
                ),
              ),
            ),
            ListTile(
              title: const Text("legendPosition"),
              trailing: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: DropdownButton<LegendPosition>(
                  value: _legendPosition,
                  items: const [
                    DropdownMenuItem(
                      value: LegendPosition.left,
                      child: Text("left"),
                    ),
                    DropdownMenuItem(
                      value: LegendPosition.right,
                      child: Text("right"),
                    ),
                    DropdownMenuItem(
                      value: LegendPosition.top,
                      child: Text("top"),
                    ),
                    DropdownMenuItem(
                      value: LegendPosition.bottom,
                      child: Text("bottom"),
                    ),
                  ],
                  onChanged: (val) {
                    setState(() {
                      _legendPosition = val;
                    });
                  },
                ),
              ),
            ),
            ListTile(
              title: Text(
                'Chart values Options'.toUpperCase(),
                style: Theme
                    .of(context)
                    .textTheme
                    .overline!
                    .copyWith(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SwitchListTile(
              value: _showChartValueBackground,
              title: const Text("showChartValueBackground"),
              onChanged: (val) {
                setState(() {
                  _showChartValueBackground = val;
                });
              },
            ),
            SwitchListTile(
              value: _showChartValues,
              title: const Text("showChartValues"),
              onChanged: (val) {
                setState(() {
                  _showChartValues = val;
                });
              },
            ),
            SwitchListTile(
              value: _showChartValuesInPercentage,
              title: const Text("showChartValuesInPercentage"),
              onChanged: (val) {
                setState(() {
                  _showChartValuesInPercentage = val;
                });
              },
            ),
            SwitchListTile(
              value: _showChartValuesOutside,
              title: const Text("showChartValuesOutside"),
              onChanged: (val) {
                setState(() {
                  _showChartValuesOutside = val;
                });
              },
            ),
          ],
        ),
      ),
    );
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pie Chart @apgapg"),
        actions: [
          ElevatedButton(
            onPressed: () {
              setState(() {
                key = key + 1;
              });
            },
            child: Text("Reload".toUpperCase()),
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (_, constraints) {
          if (constraints.maxWidth >= 600) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  flex: 3,
                  fit: FlexFit.tight,
                  child: chart,
                ),
                Flexible(
                  flex: 2,
                  fit: FlexFit.tight,
                  child: settings,
                )
              ],
            );
          } else {
            return SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(
                      vertical: 32,
                    ),
                    child: chart,
                  ),
                  settings,
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
