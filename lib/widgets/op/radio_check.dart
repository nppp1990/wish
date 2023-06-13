import 'package:flutter/material.dart';

class RadioCheck extends StatefulWidget {
  final bool initValue;
  final String? desc;
  final ValueChanged<bool>? onChanged;

  const RadioCheck({super.key, this.initValue = false, this.desc, this.onChanged});

  @override
  State<StatefulWidget> createState() => _RadioCheckState();
}

class _RadioCheckState extends State<RadioCheck> {
  late bool _value;

  @override
  void initState() {
    super.initState();
    _value = widget.initValue;
  }

  @override
  Widget build(BuildContext context) {
    Widget? titleChild;
    if (widget.desc != null) {
      final TextStyle style;
      if (_value) {
        style = const TextStyle(
          fontSize: 16,
          color: Colors.black38,
          fontWeight: FontWeight.w700,
          decoration: TextDecoration.lineThrough,
          decorationColor: Colors.black38,
          decorationThickness: 3,
        );
      } else {
        style = const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w700,
        );
      }
      titleChild = Transform.translate(
          offset: const Offset(-16, 0),
          child: Text(
            widget.desc!,
            style: style,
          ));
    }

    return MergeSemantics(
      child: SizedBox(
        child: ListTile(
          onTap: _select,
          contentPadding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            side: const BorderSide(color: Colors.black, width: 1),
            borderRadius: BorderRadius.circular(5),
          ),
          leading: Transform.scale(
            scale: 1.2,
            child: Radio(
                toggleable: true,
                value: _value,
                groupValue: true,
                onChanged: (v) {
                  _select();
                }),
          ),
          title: titleChild,
        ),
      ),
    );
  }

  _select() {
    setState(() {
      _value = !_value;
    });
    widget.onChanged?.call(_value);
  }
}