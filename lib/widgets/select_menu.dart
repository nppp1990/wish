import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/wish_localizations.dart';
import 'package:wish/data/wish_data.dart';
import 'package:wish/utils/example.dart';

class MenuItem<T> {
  final String name;
  final T value;

  MenuItem({required this.name, required this.value});
}

class SelectRadioGroup<T> extends StatefulWidget {
  final List<MenuItem<T>> items;
  final int initialIndex;
  final ValueChanged<MenuItem<T>>? onChanged;
  final ValueSetter<BaseExample> onLabelClicked;
  final bool showRadio;

  const SelectRadioGroup({
    Key? key,
    required this.items,
    this.onChanged,
    this.initialIndex = -1,
    required this.onLabelClicked,
    this.showRadio = true,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SelectRadioGroupState();
}

class _SelectRadioGroupState extends State<SelectRadioGroup> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  _select(int index) {
    setState(() {
      _currentIndex = index;
      widget.onChanged?.call(widget.items[_currentIndex]);
    });
  }

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      if (widget.showRadio)
        Row(
          children: [
            for (int index = 0; index < widget.items.length; index++)
              Expanded(
                child: Row(
                  children: [
                    Transform.scale(
                      scale: 1.2,
                      child: Radio(
                        activeColor: colorScheme.primary,
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        value: index,
                        groupValue: _currentIndex,
                        onChanged: (value) {
                          _select(index);
                        },
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        _select(index);
                      },
                      child: Text(
                        widget.items[index].name,
                        style: TextStyle(
                            fontSize: 16,
                            color: colorScheme.primary.withOpacity(_currentIndex == index ? 1 : 0.6),
                            fontWeight: _currentIndex == index ? FontWeight.w900 : FontWeight.w600),
                      ),
                    )
                  ],
                ),
              )
          ],
        ),
      _RefreshText(
        radioIndex: _currentIndex,
        onLabelClicked: widget.onLabelClicked,
      )
    ]);
  }
}

class _RefreshText extends StatefulWidget {
  final int radioIndex;
  final ValueSetter<BaseExample> onLabelClicked;

  const _RefreshText({
    required this.radioIndex,
    required this.onLabelClicked,
  });

  @override
  State<StatefulWidget> createState() => _RefreshTextState();
}

class _RefreshTextState extends State<_RefreshText> with SingleTickerProviderStateMixin {
  late String _showText;
  late int _lastIndex;
  late AnimationController _controller;
  late dynamic _randomTemplate;

  @override
  void initState() {
    super.initState();
    _randomTemplate = ExampleGenerate.generateByIndex(WishType.values[widget.radioIndex]);
    _lastIndex = _randomTemplate.first;
    _showText = _randomTemplate.second.title;

    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 300));
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _randomTemplate = ExampleGenerate.generateByIndex(WishType.values[widget.radioIndex], lastIndex: _lastIndex);
          _lastIndex = _randomTemplate.first;
          _showText = _randomTemplate.second.title;
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  void didUpdateWidget(covariant _RefreshText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.radioIndex != widget.radioIndex) {
      setState(() {
        _randomTemplate = ExampleGenerate.generateByIndex(WishType.values[widget.radioIndex]);
        _lastIndex = _randomTemplate.first;
        _showText = _randomTemplate.second.title;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      TextButton(
        style: TextButton.styleFrom(
          minimumSize: Size.zero,
          padding: const EdgeInsets.all(3),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        onPressed: () {
          widget.onLabelClicked.call(_randomTemplate.second);
        },
        child: Text('${WishLocalizations.of(context)!.egLabel}$_showText',
            style: TextStyle(color: colorScheme.primary.withOpacity(0.6), fontSize: 14)),
      ),
      const SizedBox(
        width: 2,
      ),
      GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            _controller.forward(from: 0);
          },
          child: Padding(
            padding: const EdgeInsets.only(right: 20, left: 2, top: 5, bottom: 15),
            child: RotationTransition(
              turns: CurvedAnimation(parent: _controller, curve: Curves.linear),
              child: Icon(
                Icons.refresh,
                size: 16,
                color: colorScheme.primary.withOpacity(0.6),
              ),
            ),
          )),
    ]);
  }
}
