import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:wish/data/data_base_helper.dart';
import 'package:wish/data/event_manager.dart';
import 'package:wish/data/wish_data.dart';
import 'package:wish/themes/gallery_theme_data.dart';
import 'package:wish/utils/dialogs.dart';
import 'package:wish/utils/example.dart';
import 'package:wish/utils/struct.dart';
import 'package:wish/widgets/label.dart';
import 'package:wish/widgets/picker.dart';
import 'package:wish/widgets/select_menu.dart';
import 'package:wish/widgets/switch_num.dart';

const Color hintColor = Colors.grey;
final Color labelColor = Colors.black.withOpacity(0.6);

enum WishPageType {
  create,
  edit,
  open;
}

enum PageFrom {
  op,
  list,
  other,
}

class EditPage extends StatelessWidget {
  final GlobalKey<_EditPageViewState> _pageKey = GlobalKey();
  final WishPageType pageType;
  final WishData? wishData;

  // create模式时 有可能传入wishType
  final WishType? wishType;
  final PageFrom? from;
  final int? index;

  EditPage({super.key, required this.pageType, this.wishData, this.index, this.from, this.wishType});

  @override
  Widget build(BuildContext context) {
    var showActionBtn = pageType == WishPageType.create || pageType == WishPageType.edit;
    final String title;
    if (pageType == WishPageType.edit) {
      title = '编辑心愿';
    } else {
      if (wishType == WishType.repeat) {
        title = '创建重复任务';
      } else if (wishType == WishType.checkIn) {
        title = '创建打卡任务';
      } else {
        title = '创建心愿';
      }
    }
    List<Widget> actions;
    if (pageType == WishPageType.create) {
      actions = [
        TextButton(
            onPressed: save,
            child: const Text(
              '保存',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
            )),
      ];
    } else {
      //  弹出删除和保存
      actions = [
        IconButton(
          onPressed: () {
            delete(context, wishData!);
          },
          icon: const Tooltip(message: '删除', child: Icon(Icons.delete_outline)),
        ),
        IconButton(onPressed: save, icon: const Tooltip(message: '保存', child: Icon(Icons.save_outlined)))
      ];
    }

    return Scaffold(
        appBar: AppBar(
          actions: actions,
          title: Text(title),
        ),
        floatingActionButton: showActionBtn
            ? FloatingActionButton(
                onPressed: save,
                child: const Icon(
                  size: 30,
                  Icons.save,
                  color: Colors.white,
                ),
              )
            : null,
        body: WillPopScope(
          onWillPop: () async {
            if (_pageKey.currentState!._canBack()) {
              return true;
            }
            final exit = await showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                      title: const Text('是否退出编辑？'),
                      content: const Text('退出后，当前编辑内容将不会被保存'),
                      actions: [
                        TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(true);
                            },
                            child: const Text('退出')),
                        TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(false);
                            },
                            child: const Text('取消')),
                      ],
                    ));
            return exit;
          },
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 15, bottom: 15),
            child: EditPageView(
              key: _pageKey,
              index: index,
              wishData: wishData,
              pageType: pageType,
              wishType: wishType,
              pageFrom: from,
            ),
          ),
        ));
  }

  save() {
    return _pageKey.currentState?.save();
  }

  delete(BuildContext context, WishData wish) {
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              title: Text(
                '删除心愿${wish.name}',
              ),
              content: const Text('确定删除吗？'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: const Text('取消'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                  child: const Text(
                    '确定',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ],
            )).then((value) async {
      if (value) {
        final id = wishData!.id!;
        int res = await DatabaseHelper.instance.deleteWish(wishData!);
        if (res <= 0 && context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('删除失败'),
              duration: Duration(milliseconds: 500),
            ),
          );
          return;
        }
        eventBus.fire(DeleteWishEvent(index!, id));
        if (context.mounted) {
          Navigator.of(context).pop();
        }
      }
    });
  }
}

class EditPageView extends StatefulWidget {
  final int? index;
  final WishData? wishData;
  final WishType? wishType;
  final PageFrom? pageFrom;
  final WishPageType pageType;

  const EditPageView({super.key, this.index, this.wishData, required this.pageType, this.pageFrom, this.wishType});

  @override
  State<StatefulWidget> createState() => _EditPageViewState();
}

class _EditPageViewState extends State<EditPageView> {
  late int _currentType;
  final GlobalKey<_NameInputState> _nameInputKey = GlobalKey();
  final GlobalKey<_StepLayoutState> _stepLayoutKey = GlobalKey();
  final GlobalKey<WishSwitcherState> _switchKey = GlobalKey();
  final GlobalKey<CheckInTimePickerState> _dayTimeKey = GlobalKey();
  final GlobalKey<IntervalTimePickerState> _periodDaysKey = GlobalKey();
  final GlobalKey<DatePickerState> _endDateKey = GlobalKey();
  final GlobalKey _descKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _currentType = widget.wishType?.index ?? (widget.wishData?.wishType.index ?? WishType.wish.index);
  }

  @override
  Widget build(BuildContext context) {
    var isCreateMode = widget.pageType == WishPageType.create;
    debugPrint('init checkInTime: ${widget.wishData?.periodDays}');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            NameInput(
              key: _nameInputKey,
              initName: widget.wishData?.name,
              initColorType: widget.wishData?.colorType,
            ),
            if (isCreateMode)
              const SizedBox(
                height: 30,
              ),
            if (isCreateMode)
              SelectRadioGroup<WishType>(
                items: [
                  MenuItem(value: WishType.wish, name: '心想事成'),
                  MenuItem(value: WishType.repeat, name: '重复任务'),
                  MenuItem(value: WishType.checkIn, name: '打卡任务'),
                ],
                initialIndex: _currentType,
                onChanged: (MenuItem item) {
                  setState(() {
                    _currentType = item.value.index;
                  });
                },
                onLabelClicked: (template) {
                  _nameInputKey.currentState?.refresh(template.title);
                  if (_currentType == WishType.wish.index) {
                    _stepLayoutKey.currentState?.refresh((template as WishExample).steps);
                  } else if (_currentType == WishType.repeat.index) {
                    _switchKey.currentState?.refresh((template as RepeatWishExample).repeatCount);
                  } else {
                    _periodDaysKey.currentState?.refresh((template as CheckInWishExample).periodDays);
                  }
                },
                showRadio: isCreateMode && widget.wishType == null,
              ),
            SizedBox(
              height: isCreateMode ? 5 : 20,
            ),
            if (_currentType == 0)
              StepLayout(
                key: _stepLayoutKey,
                stepList: widget.wishData?.stepList,
              )
            else if (_currentType == 1)
              Row(
                children: [
                  const Expanded(
                    child: Label(text: '重复次数'),
                  ),
                  WishSwitcher(
                    initCount: widget.wishData?.repeatCount ?? 1,
                    min: 1,
                    key: _switchKey,
                  ),
                ],
              )
            else if (_currentType == 2) ...[
              IntervalTimePicker(key: _periodDaysKey, periodDays: widget.wishData?.periodDays),
              const SizedBox(
                height: 15,
              ),
              CheckInTimePicker(
                key: _dayTimeKey,
                initTime: widget.wishData?.checkInTime,
              ),
            ],
            const SizedBox(
              height: 15,
            ),
            DatePicker(
              key: _endDateKey,
              initDate: widget.wishData?.endTime,
            ),
            const SizedBox(
              height: 30,
            ),
            DescInput(
              key: _descKey,
              initDesc: widget.wishData?.note,
            ),
          ],
        )
      ],
    );
  }

  bool _canBack() {
    if (widget.pageType == WishPageType.create) {
      return _nameInputKey.currentState?.getResult().first.isEmpty ?? false;
    }
    if (widget.pageType == WishPageType.edit) {
      var currentData = _getCurrentWishData();
      if (currentData.diff(widget.wishData)) {
        return false;
      }
      return true;
    }
    return true;
  }

  bool valid() {
    if (_nameInputKey.currentState!.getResult().first.isEmpty) {
      return false;
    }

    if (_currentType == WishType.wish.index) {
      // 步骤列表的内容不能为空
      return _stepLayoutKey.currentState?.getResult().every((element) => element.desc.isNotEmpty) ?? true;
    }

    if (_currentType == WishType.checkIn.index) {
      var days = _periodDaysKey.currentState!.getResult();
      var checkInTime = _dayTimeKey.currentState!.getResult();
      return days != null && days > 0 && checkInTime != null;
    }
    return true;
  }

  WishData _getCurrentWishData() {
    var dateTime = DateTime.now();
    var nameResult = _nameInputKey.currentState!.getResult();
    return WishData(
      nameResult.first,
      id: widget.wishData?.id,
      colorType: nameResult.second,
      wishType: WishType.values[_currentType],
      checkInTime: _dayTimeKey.currentState?.getResult(),
      repeatCount: _switchKey.currentState?.getResult(),
      periodDays: _periodDaysKey.currentState?.getResult(),
      stepList: _stepLayoutKey.currentState?.getResult(),
      endTime: _endDateKey.currentState?.getResult(),
      note: (_descKey.currentWidget as ResultMixin).getResult(),
      modifiedTime: dateTime,
      createdTime: widget.wishData?.createdTime ?? dateTime,
    );
  }

  save() async {
    if (valid()) {
      var wishData = _getCurrentWishData();
      final int res;
      if (widget.pageType == WishPageType.create) {
        res = await DatabaseHelper.instance.insertWish(wishData);
      } else {
        res = await DatabaseHelper.instance.updateWish(wishData, widget.wishData!);
      }
      if (res > 0) {
        if (!context.mounted) {
          return;
        }
        if (widget.index == null) {
          eventBus.fire(AddEvent());
        } else {
          eventBus.fire(UpdateWishEvent(widget.index!, wishData.id!));
        }

        Navigator.pop(context, widget.pageFrom);
      }
      return;
    }
    var nameResult = _nameInputKey.currentState!.getResult();
    if (nameResult.first.isEmpty) {
      DialogUtils.showToast(context, '请填写心愿名');
      return -1;
    }

    if (_currentType == WishType.wish.index) {
      DialogUtils.showToast(context, '心愿步骤不能为空');
      return -1;
    }

    if (_currentType == WishType.checkIn.index) {
      if (_dayTimeKey.currentState?.getResult() == null) {
        DialogUtils.showToast(context, '请填写打卡时间');
      } else {
        DialogUtils.showToast(context, '请填写间隔天数');
      }
      return -1;
    }
    return -1;
  }
}

class NameInput extends StatefulWidget {
  final String? initName;
  final ColorType? initColorType;

  const NameInput({super.key, this.initName, this.initColorType});

  @override
  State<StatefulWidget> createState() => _NameInputState();
}

class _NameInputState extends State<NameInput> with ResultMixin<Pair<String, ColorType>>, RefreshState<String> {
  late TextEditingController _nameController;
  final GlobalKey<ColorPickerState> _colorPickerKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initName);
  }

  @override
  Widget build(BuildContext context) {
    bool isLight = Theme.of(context).brightness == Brightness.light;
    var colorScheme = Theme.of(context).colorScheme;
    return Row(
      children: [
        Expanded(
          child: TextField(
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
            // 设置padding
            controller: _nameController,
            decoration: InputDecoration(
              labelStyle: TextStyle(color: colorScheme.primary.withOpacity(0.6)),
              hintStyle: TextStyle(color: isLight ? Colors.grey : const Color(0XFF808080)),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  width: 3,
                  color: isLight ? colorScheme.primary : GalleryThemeData.darkGreenBorderColor,
                ),
                borderRadius: const BorderRadius.all(Radius.circular(10)),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  width: 2,
                  color: colorScheme.primary.withOpacity(0.6),
                ),
                borderRadius: const BorderRadius.all(Radius.circular(10)),
              ),
              suffixIcon: _nameController.value.text.isNotEmpty
                  ? IconButton(
                      onPressed: () {
                        setState(() {
                          _nameController.clear();
                        });
                      },
                      icon: Icon(
                        Icons.clear,
                        color: colorScheme.primary,
                        size: 24,
                      ),
                    )
                  : null,
              hintText: '写一个好记的心愿名',
              labelText: '心愿名',
            ),
            onChanged: (value) {
              setState(() {});
            },
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        ColorPicker(
          colorType: widget.initColorType,
          key: _colorPickerKey,
          size: 36,
        ),
      ],
    );
  }

  @override
  Pair<String, ColorType> getResult() {
    return Pair(_nameController.value.text, _colorPickerKey.currentState!.getResult());
  }

  clear() {
    setState(() {
      _nameController.clear();
    });
  }

  @override
  void refresh(String value) {
    setState(() {
      _nameController.text = value;
    });
  }
}

class DescInput extends StatelessWidget with ResultMixin<String> {
  final String? initDesc;

  final TextEditingController _descController = TextEditingController();

  DescInput({super.key, this.initDesc}) {
    if (initDesc != null) {
      _descController.value = TextEditingValue(text: initDesc!);
    }
  }

  @override
  String getResult() {
    return _descController.value.text;
  }

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    var isLight = Theme.of(context).brightness == Brightness.light;
    return TextField(
      controller: _descController,
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
      maxLines: 7,
      maxLength: 200,
      keyboardType: TextInputType.multiline,
      decoration: InputDecoration(
        labelStyle: TextStyle(color: colorScheme.primary.withOpacity(0.6)),
        hintStyle: TextStyle(color: isLight ? Colors.grey : const Color(0XFF808080)),
        contentPadding: const EdgeInsets.all(16),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            width: 3,
            color: isLight ? colorScheme.primary : GalleryThemeData.darkGreenBorderColor,
          ),
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            width: 2,
            color: colorScheme.primary.withOpacity(0.6),
          ),
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ),
        hintText: '记录这个愿望的初衷，或者写几句激励自己的话吧',
        labelText: '备注',
      ),
    );
  }
}

class StepLayout extends StatefulWidget {
  final List<WishStep>? stepList;

  const StepLayout({super.key, this.stepList});

  @override
  State<StatefulWidget> createState() => _StepLayoutState();
}

class _StepLayoutState extends State<StepLayout>
    with SingleTickerProviderStateMixin, ResultMixin<List<WishStep>>, RefreshState<List<String>?> {
  final List<GlobalKey<_StepInputState>> _keyList = [];
  final List<WishStep> _currentStep = [];
  int itemSize = 0;
  bool _firstLoad = true;

  @override
  void initState() {
    super.initState();
    if (widget.stepList != null) {
      itemSize = widget.stepList!.length;
      for (int i = 0; i < itemSize; i++) {
        _keyList.add(GlobalKey());
        _currentStep.add(widget.stepList![i]);
      }
    }
  }

  int _findFocusIndex() {
    for (int i = 0; i < itemSize; i++) {
      if (_keyList[i].currentState!._focusNode.hasFocus) {
        return i;
      }
    }
    return -1;
  }

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    final content = Column(
      children: [
        Row(
          children: [
            const Expanded(child: Label(text: '做好规划、一步一步完成的心愿')),
            OutlinedButton(
                style: OutlinedButton.styleFrom(
                  side: BorderSide(width: 2, color: colorScheme.primary),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(6)),
                  ),
                ),
                onPressed: () {
                  setState(() {
                    var focusIndex = _findFocusIndex();
                    itemSize++;
                    if (focusIndex == -1) {
                      _currentStep.add(WishStep('', false));
                      _keyList.add(GlobalKey());
                    } else {
                      _currentStep.insert(focusIndex + 1, WishStep('', false));
                      _keyList.insert(focusIndex + 1, GlobalKey());
                    }
                  });
                },
                child: const Text('添加步骤')),
          ],
        ),
        for (int i = 0; i < itemSize; i++)
          StepInput(
            key: _keyList[i],
            value: _currentStep[i].desc,
            done: _currentStep[i].done,
            step: i + 1,
            deleteCallback: () async {
              setState(() {
                _currentStep.removeAt(i);
                _keyList.removeAt(i);
                itemSize--;
              });
            },
            canDelete: () {
              if (_currentStep[i].done) {
                return DialogUtils.showModal(context, '删除', '取消', content: '删除已完成的步骤无法恢复，确定删除吗？', yesColor: Colors.red);
              }
              return Future.value(true);
            },
            needRequestFocus: !_firstLoad,
          )
      ],
    );
    _firstLoad = false;
    return content;
  }

  @override
  List<WishStep> getResult() {
    return _keyList.map((e) => e.currentState!.getResult()).toList();
  }

  @override
  void refresh(List<String>? value) {
    if (value == null) {
      return;
    }
    setState(() {
      itemSize = value.length;
      _currentStep.clear();
      _keyList.clear();
      for (int i = 0; i < itemSize; i++) {
        _keyList.add(GlobalKey());
        _currentStep.add(WishStep(value[i], false));
      }
    });
  }
}

class StepInput extends StatefulWidget {
  final int step;
  final double? height;
  final String? value;
  final bool done;
  final bool needRequestFocus;
  final VoidCallback deleteCallback;
  final AsyncValueGetter<bool?>? canDelete;

  const StepInput(
      {super.key,
      required this.step,
      this.height = 36,
      this.value,
      this.done = false,
      this.needRequestFocus = false,
      required this.deleteCallback,
      this.canDelete});

  @override
  State<StatefulWidget> createState() => _StepInputState();
}

class _StepInputState extends State<StepInput> with SingleTickerProviderStateMixin, ResultMixin<WishStep> {
  late AnimationController _controller;
  late FocusNode _focusNode;
  late TextEditingController _textEditingController;

  @override
  WishStep getResult() {
    return WishStep(_textEditingController.value.text, widget.done);
  }

  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController(text: widget.value);
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 200));
    _focusNode = FocusNode();
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed && widget.needRequestFocus) {
        _focusNode.requestFocus();
      }
      if (status == AnimationStatus.dismissed) {
        widget.deleteCallback.call();
      }
    });
    _controller.forward();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var colorTheme = Theme.of(context).colorScheme;
    return SizeTransition(
        sizeFactor: _controller,
        axis: Axis.vertical,
        child: SizedBox(
          height: widget.height,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 12, bottom: 2),
                child: Text('${widget.step}.', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w900)),
              ),
              Expanded(
                  child: TextField(
                controller: _textEditingController,
                focusNode: _focusNode,
                style: TextStyle(
                  color: widget.done ? colorTheme.primary.withOpacity(0.38) : colorTheme.primary,
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                  decoration: widget.done ? TextDecoration.lineThrough : null,
                  decorationColor: Colors.black38,
                  decorationThickness: 2,
                ),
                decoration: InputDecoration(
                  hintStyle: const TextStyle(color: hintColor),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: colorTheme.primary.withOpacity(0.6), width: 2),
                  ),
                  border: UnderlineInputBorder(
                    borderSide: BorderSide(color: colorTheme.primary),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: colorTheme.primary, width: 2),
                  ),
                  contentPadding: const EdgeInsets.only(bottom: 4, left: 2, right: 2),
                  hintText: '请输入步骤',
                ),
              )),
              IconButton(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                constraints: const BoxConstraints(),
                onPressed: () {
                  if (widget.canDelete != null) {
                    widget.canDelete!().then((value) {
                      if (value == true) {
                        _controller.reverse(from: 1);
                      }
                    });
                    return;
                  }
                  _controller.reverse(from: 1);
                },
                icon: Icon(
                  Icons.delete_forever_outlined,
                  color: colorTheme.primary,
                  size: 24,
                ),
              )
            ],
          ),
        ));
  }
}
