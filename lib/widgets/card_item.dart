import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';

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
          top: -5,
          child: Container(
            color: Colors.white,
            child: TextButton(
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              onPressed: () {},
              child: Text(
                itemLabel,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ))
    ]);
  }
}

class ItemWrapLabelRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isLabelGray;
  final Widget? extra;
  final double labelWidth = 90;

  const ItemWrapLabelRow({super.key, required this.label, required this.value, this.isLabelGray = false, this.extra});

  @override
  Widget build(BuildContext context) {
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