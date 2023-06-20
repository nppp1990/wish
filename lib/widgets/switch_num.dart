import 'package:flutter/material.dart';
import 'package:wish/utils/struct.dart';

class WishSwitcher extends StatefulWidget {
  final int? initCount;
  final ValueChanged<int>? onChanged;
  final int min;

  const WishSwitcher({super.key, this.initCount, this.onChanged, this.min = 0});

  @override
  State<StatefulWidget> createState() => WishSwitcherState();
}

class WishSwitcherState extends State<WishSwitcher> with ResultMixin<int>, RefreshState<int> {
  late int _count;

  get count => _count;

  @override
  void initState() {
    super.initState();
    _count = widget.initCount ?? 0;
  }

  @override
  int getResult() => count;

  @override
  void refresh(int value) {
    setState(() {
      _count = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      children: <Widget>[
        _buildMinusBtn(),
        SizedBox(
          width: 40,
          child: _buildAnimatedSwitcher(context),
        ),
        _buildAddBtn()
      ],
    );
  }

  Widget _buildAnimatedSwitcher(BuildContext context) {
    var primaryColor = Theme.of(context).colorScheme.primary;
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 400),
      transitionBuilder: (Widget child, Animation<double> animation) =>
          FadeTransition(
            opacity: animation,
            child: ScaleTransition(scale: animation, child: child),
          ),
      child: Text('$_count',
          key: ValueKey<int>(_count),
          style: TextStyle(
              color: _count == 0 ? primaryColor.withOpacity(0.6) : primaryColor,
              fontSize: 20,
              fontWeight: FontWeight.w900)),
    );
  }

  Widget _buildMinusBtn() {
    return MaterialButton(
        height: 36,
        minWidth: 45,
        padding: const EdgeInsets.all(0),
        textColor: Colors.white,
        elevation: 3,
        disabledColor: Colors.black.withOpacity(0.4),
        color: Colors.black,
        highlightColor: Colors.black.withOpacity(0.6),
        splashColor: Colors.grey,
        shape: CircleBorder(
          side: BorderSide(width: 2.0, color: Colors.white.withOpacity(0.6)),
        ),
        onPressed: _count > widget.min ? () => setState(() => _changeCount(_count - 1)) : null,
        child: const Icon(
          Icons.remove,
          color: Colors.white,
        ));
  }

  Widget _buildAddBtn() => MaterialButton(
      height: 36,
      minWidth: 45,
      padding: const EdgeInsets.all(0),
      textColor: Colors.white,
      elevation: 3,
      color: Colors.black,
      highlightColor: Colors.black.withOpacity(0.6),
      splashColor: Colors.grey,
      shape: CircleBorder(
        side: BorderSide(width: 2.0, color: Colors.white.withOpacity(0.6)),
      ),
      onPressed: () => setState(() => _changeCount(_count + 1)),
      child: const Icon(
        Icons.add,
        color: Colors.white,
      ));

  _changeCount(int count) {
    setState(() {
      widget.onChanged?.call(count);
      _count = count;
    });
  }
}
