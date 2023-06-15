import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:pie_chart/pie_chart.dart';
import 'package:wish/data/data_base_helper.dart';
import 'package:wish/data/wish_op.dart';
import 'package:wish/data/wish_review.dart';
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

  // late ScrollController _controller;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  loadData() async {
    setState(() {
      _loadingType = WishLoadingType.loading;
    });

    var res = await DatabaseHelper.instance.getReviewInfo(null, null);
    print('----res');
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
                child: ItemWrap(itemLabel: '过去一周', onLabelPressed: () {}, child: _buildChart(_opList!)),
              )),
        if (_loadingType == WishLoadingType.success)
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
                  color: constraints.maxHeight > 90 ? Colors.white : Colors.black,
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
      'create': '创建 $createCount',
      'done': '完成 $doneCount',
      'undone': '重启 $unDoneCount',
      'pause': '暂停 $pausedCount',
      'delete': '删除 $deleteCount',
    };

    final colorList = <Color>[
      const Color(0xDD000000),
      Colors.green,
      const Color(0x1F000000),
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
          // showChartValueBackground: _showChartValueBackground,
          // showChartValues: _showChartValues,
          showChartValuesInPercentage: true,
          showChartValuesOutside: true,
        ),
        ringStrokeWidth: 32,
        emptyColor: Colors.grey,
        // gradientList: _showGradientColors ? gradientList : null,
        emptyColorGradient: const [
          Color(0xff6c5ce7),
          Colors.blue,
        ],
        baseChartColor: Colors.transparent,
      ),
    );
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
      itemLabel: '数据概览',
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
      chartRadius: math.min(MediaQuery.of(context).size.width / 3.2, 300),
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
                style: Theme.of(context).textTheme.overline!.copyWith(
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
                style: Theme.of(context).textTheme.overline!.copyWith(
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
                style: Theme.of(context).textTheme.overline!.copyWith(
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
