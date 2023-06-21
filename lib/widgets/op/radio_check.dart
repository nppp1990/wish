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
    var primaryColor = Theme.of(context).colorScheme.primary;

    if (widget.desc != null) {
      final TextStyle style;
      if (_value) {
        style = TextStyle(
          fontSize: 16,
          color: primaryColor.withOpacity(0.38),
          fontWeight: FontWeight.w700,
          decoration: TextDecoration.lineThrough,
          decorationColor: primaryColor.withOpacity(0.38),
          decorationThickness: 3,
        );
      } else {
        style = TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: primaryColor,
        );
      }
      titleChild = Transform.translate(
          offset: const Offset(-16, 0),
          child: Text(
            widget.desc!,
            style: style,
          ));
    }

    Color getColor(Set<MaterialState> states) {
      if (states.contains(MaterialState.selected)) {
        return primaryColor.withOpacity(0.38);
      } else {
        return primaryColor;
      }
    }

    return MergeSemantics(
      child: SizedBox(
        child: ListTile(
          onTap: _select,
          contentPadding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            side: BorderSide(color: primaryColor, width: 1),
            borderRadius: BorderRadius.circular(5),
          ),
          leading: Transform.scale(
            scale: 1.2,
            child: Radio(
                activeColor: primaryColor.withOpacity(0.38),
                fillColor: MaterialStateProperty.resolveWith(getColor),
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