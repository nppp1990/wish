import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:wish/data/style/wish_options.dart';

class ItemWrap extends StatelessWidget {
  final String itemLabel;
  final Widget child;
  final EdgeInsets padding;
  final VoidCallback? onLabelPressed;

  const ItemWrap(
      {super.key,
      required this.child,
      required this.itemLabel,
      this.padding = const EdgeInsets.all(14),
      this.onLabelPressed});

  @override
  Widget build(BuildContext context) {
    Widget labelView;
    var colorScheme = Theme.of(context).colorScheme;
    if (onLabelPressed == null) {
      labelView = Positioned(
          left: 20,
          top: 0,
          child: Container(
            color: colorScheme.secondary,
            child: Text(
              itemLabel,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
          ));
    } else {
      labelView = Positioned(
          left: 20,
          top: -5,
          child: Container(
            color: colorScheme.secondary,
            child: TextButton(
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              onPressed: onLabelPressed,
              child: Text(
                itemLabel,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ));
    }

    return Stack(children: [
      Padding(
        padding: const EdgeInsets.only(top: 14),
        child: DottedBorder(
          borderType: BorderType.RRect,
          dashPattern: const [8, 4],
          color: colorScheme.primary,
          radius: const Radius.circular(12),
          padding: padding,
          child: child,
        ),
      ),
      labelView,
    ]);
  }
}

class ItemWrapLabelRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isLabelGray;
  final Widget? extra;

  const ItemWrapLabelRow(
      {super.key, required this.label, required this.value, this.isLabelGray = false, this.extra});

  @override
  Widget build(BuildContext context) {
    double labelWidth = HookData.instance.labelWidth;
    if (isLabelGray) {
      return Row(
        children: [
          SizedBox(
              width: labelWidth, child: Text(label, style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 16))),
          Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
          if (extra != null) extra!,
        ],
      );
    } else {
      return Row(
        children: [
          SizedBox(
              width: labelWidth, child: Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700))),
          Text(value, style: const TextStyle(fontSize: 16, color: Colors.grey)),
        ],
      );
    }
  }
}
