import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wish/utils/struct.dart';
import 'package:wish/utils/timeUtils.dart';

class IntervalTimePicker extends StatefulWidget {
  final int? periodDays;

  const IntervalTimePicker({super.key, this.periodDays});

  @override
  State<StatefulWidget> createState() => IntervalTimePickerState();
}

class IntervalTimePickerState extends State<IntervalTimePicker>
    with ResultMixin<int?>, RefreshState<int> {
  late FocusNode _focusNode;
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _controller = TextEditingController(text: widget.periodDays?.toString());
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  int? getResult() {
    return int.tryParse(_controller.text);
  }

  @override
  void refresh(int value) {
    setState(() {
      _controller.text = value.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        height: 36,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(Icons.hourglass_bottom_outlined, size: 30, color: Colors.black),
            const SizedBox(width: 6),
            const Text('间隔天数：', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900)),
            Expanded(
                child: Transform.translate(
              offset: const Offset(0, -5),
              child: SizedBox(
                child: TextField(
                  controller: _controller,
                  focusNode: _focusNode,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w900),
                  decoration: const InputDecoration(
                      contentPadding: EdgeInsets.only(bottom: 0, left: 5),
                      hintText: '选择打卡间隔天数',
                      hintStyle: TextStyle(color: Colors.grey, fontWeight: FontWeight.w700),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black, width: 1),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black, width: 1),
                      ),
                      disabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black, width: 1),
                      )),
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                ),
              ),
            )),
          ],
        ),
      ),
      onTap: () {
        setState(() {
          FocusScope.of(context).requestFocus(_focusNode);
        });
      },
    );
  }
}

class CheckInTimePicker extends StatefulWidget {
  final TimeOfDay? initTime;

  const CheckInTimePicker({super.key, this.initTime});

  @override
  State<StatefulWidget> createState() => CheckInTimePickerState();
}

class CheckInTimePickerState extends State<CheckInTimePicker> with ResultMixin<TimeOfDay> {
  TimeOfDay? _currentTime;

  @override
  void initState() {
    super.initState();
    _currentTime = widget.initTime;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          const Icon(Icons.timer_outlined, color: Colors.black, size: 30),
          const SizedBox(width: 6),
          const Text('打卡时间：',
              style: TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.w900)),
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 5),
                child: Text(
                  _currentTime != null ? TimeUtils.getShowTime(_currentTime!) : '选择每日打卡时间',
                  style: TextStyle(
                      fontSize: 16,
                      color: _currentTime == null ? Colors.grey : Colors.black,
                      fontWeight: _currentTime == null ? FontWeight.w700 : FontWeight.w900),
                ),
              ),
              const Divider(height: 1, thickness: 1, color: Colors.black),
            ],
          )),
        ],
      ),
      onTap: () {
        showTime(context);
      },
    );
  }

  void showTime(context) async {
    TimeOfDay? t = await showTimePicker(
        context: context,
        initialTime: _currentTime ?? TimeOfDay.now(),
        helpText: '选择截止时间',
        cancelText: '取消',
        confirmText: '确定');
    if (t != null) {
      setState(() {
        _currentTime = t;
      });
    }
  }

  @override
  TimeOfDay? getResult() {
    return _currentTime;
  }
}

class DatePicker extends StatefulWidget {
  final DateTime? initDate;

  const DatePicker({super.key, this.initDate});

  @override
  State<StatefulWidget> createState() => DatePickerState();
}

class DatePickerState extends State<DatePicker> with ResultMixin<DateTime> {
  DateTime? _currentDate;

  @override
  void initState() {
    super.initState();
    _currentDate = widget.initDate;
  }

  @override
  DateTime? getResult() => _currentDate;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          const Icon(Icons.date_range_outlined, color: Colors.black, size: 30),
          const SizedBox(width: 6),
          const Text('截止日期：',
              style: TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.w900)),
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 5),
                child: Text(
                  _currentDate != null ? TimeUtils.getShowDate(_currentDate!) : '选择心愿截止日期',
                  style: TextStyle(
                      fontSize: 16,
                      color: _currentDate == null ? Colors.grey : Colors.black,
                      fontWeight: _currentDate == null ? FontWeight.w600 : FontWeight.w900),
                ),
              ),
              const Divider(
                color: Colors.black,
                height: 1,
                thickness: 1,
              ),
            ],
          ))
        ],
      ),
      onTap: () {
        showDate(context);
      },
    );
  }

  void showDate(BuildContext context) async {
    DateTime? time = await showDatePicker(
        context: context,
        helpText: '选择心愿的截止日期',
        cancelText: '取消',
        confirmText: '确定',
        initialDate: _currentDate ?? DateTime.now(),
        firstDate: DateTime(DateTime.now().year),
        lastDate: DateTime(DateTime.now().year + 10));
    if (time == null) {
      return;
    }
    setState(() {
      _currentDate = time;
    });
  }
}

class ColorCircle extends StatelessWidget {
  final Color color;
  final bool isSelected;
  final double size;

  const ColorCircle({super.key, required this.color, this.isSelected = false, this.size = 30});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.all(Radius.circular(size * 0.4)),
            )),
        Visibility(
            visible: isSelected,
            child: Container(
              width: size * 0.3,
              height: size * 0.3,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
            ))
      ],
    );
  }
}

enum ColorType {
  black,
  red,
  orange,
  yellow,
  green,
  blue,
  purple,
  pink,
  brown,
  grey;

  static const List<Color> colors = [
    Colors.black,
    Colors.red,
    Colors.orange,
    Colors.yellow,
    Colors.green,
    Colors.blue,
    Colors.purple,
    Colors.pink,
    Colors.brown,
    Colors.grey,
  ];

  static const List<String> showColors = [
    '黑色',
    '红色',
    '橙色',
    '黄色',
    '绿色',
    '蓝色',
    '紫色',
    '粉色',
    '棕色',
    '灰色',
  ];

  static ColorType fromColorIndex(int value) {
    return ColorType.values[value];
  }

  Color toColor() {
    return colors[index];
  }

  @override
  toString() => showColors[index];
}

class ColorPicker extends StatefulWidget {
  final ColorType? colorType;
  final double size;

  const ColorPicker({super.key, this.colorType, required this.size});

  @override
  State<StatefulWidget> createState() => ColorPickerState();
}

class ColorPickerState extends State<ColorPicker> with ResultMixin<ColorType> {
  late ColorType _currentColor;

  @override
  void initState() {
    super.initState();
    _currentColor = widget.colorType ?? ColorType.black;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showColorPicker(context);
      },
      child: ColorCircle(
        color: _currentColor.toColor(),
        size: widget.size,
      ),
    );
  }

  void showColorPicker(BuildContext context) {
    showModalBottomSheet(context: context, builder: _buildColorSheet);
  }

  Widget _buildColorSheet(BuildContext context) {
    return GridView.count(
      crossAxisCount: 5,
      shrinkWrap: true,
      children: List.generate(ColorType.values.length, (index) {
        return InkWell(
          child: ColorCircle(
            color: ColorType.values[index].toColor(),
            size: widget.size,
            isSelected: _currentColor == ColorType.values[index],
          ),
          onTap: () {
            setState(() {
              _currentColor = ColorType.values[index];
              // 关闭底部弹窗
              Navigator.pop(context);
            });
          },
        );
      }),
    );
  }

  @override
  ColorType getResult() {
    return _currentColor;
  }
}
