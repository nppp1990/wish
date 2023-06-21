import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:wish/data/style/wish_options.dart';
import 'package:wish/widgets/common/settings_list_item.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);

  static const String routeName = '/setting';

  @override
  State<StatefulWidget> createState() => _SettingPageState();
}

enum _ExpandableSetting {
  textScale,
  textDirection,
  locale,
  platform,
  theme,
}

class _SettingPageState extends State<SettingPage> with SingleTickerProviderStateMixin{
  _ExpandableSetting? _expandedSettingId;
  late AnimationController _controller;
  late Animation<double> _staggerSettingsItemsAnimation;

  late Locale _testLocaleOption;


  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _controller.addStatusListener(_closeSettingId);
    _staggerSettingsItemsAnimation = CurvedAnimation(
      parent: _controller,
      curve: const Interval(
        0.4,
        1.0,
        curve: Curves.ease,
      ),
    );
    _testLocaleOption = const Locale('zh');
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  void onTapSetting(_ExpandableSetting settingId) {
    setState(() {
      if (_expandedSettingId == settingId) {
        _expandedSettingId = null;
      } else {
        _expandedSettingId = settingId;
      }
    });
  }

  void _closeSettingId(AnimationStatus status) {
    if (status == AnimationStatus.dismissed) {
      setState(() {
        _expandedSettingId = null;
      });
    }
  }



  // todo
  final systemLocaleOption = const Locale('system');

  // todo
  LinkedHashMap<Locale, DisplayOption> _getLocaleOptions() {
    LinkedHashMap<Locale, DisplayOption> testMap = LinkedHashMap<Locale, DisplayOption>();
    testMap[const Locale('system')] = DisplayOption('系统', subtitle: '123');
    testMap[const Locale('zh')] = DisplayOption('简体中文', subtitle: '中国');
    testMap[const Locale('en')] = DisplayOption('English', subtitle: 'United States');
    return testMap;
  }

  @override
  Widget build(BuildContext context) {
    final options = WishOptions.of(context);

    final settingsListItems = [
      SettingsListItem<Locale?>(
        title: '语言区域',
        selectedOption: _testLocaleOption,
        optionsMap: _getLocaleOptions(),
        onOptionChanged: (newLocale) {
          print('---- newLocale: $newLocale');
          // if (newLocale == systemLocaleOption) {
          //   newLocale = deviceLocale;
          // }
          // GalleryOptions.update(
          //   context,
          //   options.copyWith(locale: newLocale),
          // );
          setState(() {
            _testLocaleOption = newLocale!;
          });
        },
        onTapSetting: () => onTapSetting(_ExpandableSetting.locale),
        isExpanded: _expandedSettingId == _ExpandableSetting.locale,
      ),
      SettingsListItem<ThemeMode?>(
        title: '主题背景',
        selectedOption: options.themeMode,
        optionsMap: LinkedHashMap.of({
          ThemeMode.light: DisplayOption(
              '浅色'
          ),
          ThemeMode.dark: DisplayOption(
            '深色'
          ),
        }),
        onOptionChanged: (mode) {
          WishOptions.update(context, options.copyWith(themeMode: mode!));
        },
        onTapSetting: () => onTapSetting(_ExpandableSetting.theme),
        isExpanded: _expandedSettingId == _ExpandableSetting.theme,
      ),
      ToggleSetting(text: '123', value: false, onChanged: (v){

      })
    ];

    return Scaffold(
        appBar: AppBar(
          title: const Text('设置'),
        ),
        body: Padding(
          padding: const EdgeInsets.only(top: 30),
          child: ListView(
            children: [
              _AnimateSettingsListItems(
                animation: _staggerSettingsItemsAnimation,
                children: settingsListItems,
              ),
            ],
          ),
        ));
  }
}

class _AnimateSettingsListItems extends StatelessWidget {
  const _AnimateSettingsListItems({
    required this.animation,
    required this.children,
  });

  final Animation<double> animation;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    const dividingPadding = 4.0;
    final dividerTween = Tween<double>(
      begin: 0,
      end: dividingPadding,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Column(
        children: [
          for (Widget child in children)
            AnimatedBuilder(
              animation: animation,
              builder: (context, child) {
                return Padding(
                  padding: EdgeInsets.only(
                    top: dividerTween.animate(animation).value,
                  ),
                  child: child,
                );
              },
              child: child,
            ),
        ],
      ),
    );
  }
}
