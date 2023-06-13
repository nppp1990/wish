import 'dart:math';

import 'package:flutter/material.dart';

class RadiusLine extends StatelessWidget {
  final double width;
  final double height;
  final Color? color;

  const RadiusLine({super.key, required this.width, required this.height, this.color});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(width, height),
      painter: RadiusLinePainter(color),
    );
  }
}

class RadiusLinePainter extends CustomPainter {
  final Color? color;

  RadiusLinePainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    Path path = Path();
    path.addArc(
      Rect.fromCenter(
        center: Offset(size.width, size.width),
        width: 2 * size.width,
        height: 2 * size.width,
      ),
      // 0.2 到 0.8 之间 弧度为0.3
      pi,
      // pi * 0.1,
      pi / 2,
    );
    path.moveTo(0, size.width);
    path.lineTo(0, size.height);

    Paint paint = Paint()
      ..isAntiAlias = true
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..color = color ?? Colors.black;
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}