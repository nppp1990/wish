import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/wish_localizations.dart';
import 'package:wish/data/style/wish_options.dart';
import 'package:wish/utils/struct.dart';
import 'package:wish/utils/timeUtils.dart';

class IntervalTimePicker extends StatefulWidget {
  final int? periodDays;

  const IntervalTimePicker({super.key, this.periodDays});

  @override
  State<StatefulWidget> createState() => IntervalTimePickerState();
}

class IntervalTimePickerState extends State<IntervalTimePicker> with ResultMixin<int?>, RefreshState<int> {
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
    var colorScheme = Theme.of(context).colorScheme;
    var localizations = WishLocalizations.of(context)!;
    Widget labelWidgt;
    if (HookData.instance.pickerLabelWidth == null) {
      labelWidgt =
          Text(localizations.checkInPeriodLabel, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900));
    } else {
      labelWidgt = SizedBox(
        width: HookData.instance.pickerLabelWidth,
        child:
            Text(localizations.checkInPeriodLabel, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900)),
      );
    }
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        height: 36,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(Icons.hourglass_bottom_outlined, size: 30, color: colorScheme.primary),
            const SizedBox(width: 6),
            labelWidgt,
            Expanded(
                child: Transform.translate(
              offset: const Offset(0, -5),
              child: SizedBox(
                child: TextField(
                  controller: _controller,
                  focusNode: _focusNode,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(fontWeight: FontWeight.w900),
                  decoration: InputDecoration(
                      contentPadding: const EdgeInsets.only(bottom: 0, left: 5),
                      hintText: localizations.checkInPeriodHint,
                      hintStyle: const TextStyle(color: Colors.grey, fontWeight: FontWeight.w700),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: colorScheme.primary, width: 1),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: colorScheme.primary, width: 1),
                      ),
                      disabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: colorScheme.primary, width: 1),
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
    var colorScheme = Theme.of(context).colorScheme;
    var isLight = colorScheme.brightness == Brightness.light;
    var localizations = WishLocalizations.of(context)!;
    Widget labelWidget;
    if (HookData.instance.pickerLabelWidth == null) {
      labelWidget =
          Text(localizations.inputCheckInLabel, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900));
    } else {
      labelWidget = SizedBox(
        width: HookData.instance.pickerLabelWidth,
        child: Text(localizations.inputCheckInLabel, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900)),
      );
    }
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Icon(Icons.timer_outlined, color: colorScheme.primary, size: 30),
          const SizedBox(width: 6),
          labelWidget,
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 5),
                child: Text(
                  _currentTime != null ? TimeUtils.getShowTime(_currentTime!) : localizations.inputCheckInHint,
                  style: TextStyle(
                      fontSize: 16,
                      color: _currentTime == null
                          ? (isLight ? Colors.grey : const Color(0XFF808080))
                          : colorScheme.primary,
                      fontWeight: _currentTime == null ? FontWeight.w700 : FontWeight.w900),
                ),
              ),
              Divider(height: 1, thickness: 1, color: colorScheme.primary),
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
    var colorTheme = Theme.of(context).colorScheme;
    var isLight = colorTheme.brightness == Brightness.light;
    var localizations = WishLocalizations.of(context)!;
    Widget labelWidget;
    if (HookData.instance.pickerLabelWidth == null) {
      labelWidget = Text(localizations.endTimePickerLabel,
          style: TextStyle(fontSize: 16, color: colorTheme.primary, fontWeight: FontWeight.w900));
    } else {
      labelWidget = SizedBox(
        width: HookData.instance.pickerLabelWidth,
        child: Text(localizations.endTimePickerLabel,
            style: TextStyle(fontSize: 16, color: colorTheme.primary, fontWeight: FontWeight.w900)),
      );
    }
    return InkWell(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Icon(Icons.date_range_outlined, color: colorTheme.primary, size: 30),
          const SizedBox(width: 6),
          labelWidget,
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 5),
                child: Text(
                  _currentDate != null ? TimeUtils.getShowDate(_currentDate!) : localizations.endTimePickerHint,
                  style: TextStyle(
                      fontSize: 16,
                      color:
                          _currentDate == null ? (isLight ? Colors.grey : const Color(0XFF808080)) : colorTheme.primary,
                      fontWeight: _currentDate == null ? FontWeight.w600 : FontWeight.w900),
                ),
              ),
              Divider(
                color: colorTheme.primary,
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
        helpText: WishLocalizations.of(context)!.endTimePickerHint,
        // cancelText: '取消',
        // confirmText: '确定',
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

  static ColorType fromColorIndex(int value) {
    return ColorType.values[value];
  }

  Color toColor() {
    return colors[index];
  }

  getShowStr(BuildContext context) {
    var localizations = WishLocalizations.of(context)!;
    switch (this) {
      case ColorType.black:
        return localizations.wishBlack;
      case ColorType.red:
        return localizations.wishRed;
      case ColorType.orange:
        return localizations.wishOrange;
      case ColorType.yellow:
        return localizations.wishYellow;
      case ColorType.green:
        return localizations.wishGreen;
      case ColorType.blue:
        return localizations.wishBlue;
      case ColorType.purple:
        return localizations.wishPurple;
      case ColorType.pink:
        return localizations.wishPink;
      case ColorType.brown:
        return localizations.wishBrown;
      case ColorType.grey:
        return localizations.wishGrey;
    }
  }
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
