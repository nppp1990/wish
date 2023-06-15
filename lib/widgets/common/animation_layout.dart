import 'package:flutter/material.dart';

typedef AnimateCallback = void Function(AnimationController controller);

class UpAnimationLayout extends StatefulWidget {
  final AnimateCallback? callback;
  final AnimationStatusListener? statusListener;
  final Widget child;
  final double upOffset;
  final Duration duration;
  final Duration? autoStartTime;

  const UpAnimationLayout(
      {super.key,
      required this.child,
      this.callback,
      this.statusListener,
      this.upOffset = 0.5,
      this.duration = const Duration(milliseconds: 500),
      this.autoStartTime});

  @override
  State<StatefulWidget> createState() => _UpAnimationLayoutState();
}

class _UpAnimationLayoutState extends State<UpAnimationLayout> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration)
      ..addListener(() {
        widget.callback?.call(_controller);
      })
      ..addStatusListener(widget.statusListener ?? (status) {});
    if (widget.autoStartTime != null) {
      Future.delayed(widget.autoStartTime!, () {
        _controller.forward();
      });
    }
  }

  void start() {
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
        position: Tween(begin: Offset(0, widget.upOffset), end: Offset.zero).animate(_controller),
        child: FadeTransition(opacity: Tween(begin: 0.0, end: 1.0).animate(_controller), child: widget.child));
  }
}
