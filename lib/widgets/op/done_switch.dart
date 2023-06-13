import 'package:flutter/material.dart';

typedef CanToggle = bool Function(bool value);

class DoneSwitch extends StatefulWidget {
  final double switchScale;
  final double textSize;
  final double contentPadding;
  final String openText;
  final String closeText;
  final bool initValue;
  final ValueChanged<bool>? onChanged;
  final CanToggle? toggleable;

  const DoneSwitch({
    super.key,
    this.switchScale = 1.5,
    this.textSize = 18,
    this.contentPadding = 6,
    required this.openText,
    required this.closeText,
    this.initValue = false,
    this.toggleable,
    this.onChanged,
  });

  @override
  State<StatefulWidget> createState() => _DoneSwitchState();
}

class _DoneSwitchState extends State<DoneSwitch> {
  bool _done = false;

  @override
  void initState() {
    super.initState();
    _done = widget.initValue;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          _done ? widget.closeText : widget.openText,
          style: TextStyle(
            fontSize: widget.textSize,
            color: _done ? Colors.black : Colors.grey,
          ),
        ),
        SizedBox(
          width: widget.contentPadding,
        ),
        Transform.scale(
          scale: widget.switchScale,
          child: Switch(
              // 大小
              value: _done,
              activeColor: Colors.black,
              // activeTrackColor: Colors.greenAccent,
              // inactiveThumbColor: Colors.
              // inactiveTrackColor: Colors.grey.withOpacity(0.5),
              onChanged: onChanged
          ),
        )
      ],
    );
  }

  void onChanged(bool value) {
    if (widget.toggleable?.call(_done) == false) {
      return;
    }
    setState(() {
      _done = value;
      widget.onChanged?.call(value);
    });
  }
}