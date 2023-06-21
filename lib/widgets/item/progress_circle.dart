import 'package:flutter/material.dart';

class ProgressCircle extends StatelessWidget {
  final Color color;
  final double value;
  final double size;
  final String? doneText;

  const ProgressCircle(
      {super.key,
      this.color = Colors.black,
      required this.value,
      required this.size,
      this.doneText});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          width: size,
          height: size,
          child: CircularProgressIndicator(
            strokeWidth: 3,
            value: value,
            backgroundColor: color.withOpacity(0.2),
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
        // value百分比
        Text(
          // value转换成10%
          value.toInt() == 1
              ? doneText ?? '${(value * 100).toInt()}%'
              : '${(value * 100).toInt()}%',
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w900),
        ),
      ],
    );
  }
}

class DoneProgressLayout extends StatelessWidget {
  const DoneProgressLayout({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}
