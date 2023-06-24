import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/wish_localizations.dart';
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

class _SettingPageState extends State<SettingPage> with SingleTickerProviderStateMixin {
  _ExpandableSetting? _expandedSettingId;
  late AnimationController _controller;
  late Animation<double> _staggerSettingsItemsAnimation;

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

  final systemLocaleOption = const Locale('system');

  LinkedHashMap<Locale, DisplayOption> _getLocaleOptions(BuildContext context) {
    var supportedLocales = List<Locale>.from(WishLocalizations.supportedLocales);
    LinkedHashMap<Locale, DisplayOption> map = LinkedHashMap<Locale, DisplayOption>();
    var localizations = WishLocalizations.of(context)!;
    map[systemLocaleOption] = DisplayOption(localizations.settingsSystemDefault);
    for (var locale in supportedLocales) {
      if (locale.languageCode.toLowerCase() == 'zh') {
        map[locale] = DisplayOption('中文', subtitle: '简体中文');
      } else if (locale.languageCode.toLowerCase() == 'en') {
        map[locale] = DisplayOption('English', subtitle: localizations.localeEn);
      }
    }
    return map;
  }

  @override
  Widget build(BuildContext context) {
    final options = WishOptions.of(context);
    WishLocalizations localizations = WishLocalizations.of(context)!;
    HookData.instance.updateLabelWidth(Localizations.localeOf(context).languageCode);
    final settingsListItems = [
      SettingsListItem<Locale?>(
        title: localizations.settingsLocale,
        selectedOption: options.locale ?? systemLocaleOption,
        optionsMap: _getLocaleOptions(context),
        onOptionChanged: (newLocale) {
          setLastLocale(newLocale);
          if (newLocale == systemLocaleOption) {
            WishOptions.update(
              context,
              options.copyWith(locale: null, forceLocale: true),
            );
          } else {
            WishOptions.update(
              context,
              options.copyWith(locale: newLocale),
            );
          }
        },
        onTapSetting: () => onTapSetting(_ExpandableSetting.locale),
        isExpanded: _expandedSettingId == _ExpandableSetting.locale,
      ),
      SettingsListItem<ThemeMode?>(
        title: localizations.settingsTheme,
        selectedOption: options.themeMode,
        optionsMap: LinkedHashMap.of({
          ThemeMode.system: DisplayOption(localizations.settingsSystemDefault),
          ThemeMode.light: DisplayOption(localizations.settingsLightTheme),
          ThemeMode.dark: DisplayOption(localizations.settingsDarkTheme),
        }),
        onOptionChanged: (mode) {
          saveLastTheme(mode!.index);
          WishOptions.update(context, options.copyWith(themeMode: mode!));
        },
        onTapSetting: () => onTapSetting(_ExpandableSetting.theme),
        isExpanded: _expandedSettingId == _ExpandableSetting.theme,
      ),
      ToggleSetting(text: '123', value: false, onChanged: (v) {})
    ];

    return Scaffold(
        appBar: AppBar(
          title: Text(localizations.setting),
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
