import 'package:flutter/material.dart';
import 'package:wish/data/style/wish_options.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({Key? key}) : super(key: key);

  static const String routeName = '/setting';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Setting'),
        ),
        body: Center(
          child: TextButton(
            onPressed: () {
              var currentOptions = WishOptions.of(context);
              if (currentOptions.themeMode == ThemeMode.dark) {
                WishOptions.update(
                    context,
                    WishOptions.of(context).copyWith(
                      themeMode: ThemeMode.light,
                    ));
              } else {
                WishOptions.update(
                    context,
                    WishOptions.of(context).copyWith(
                      themeMode: ThemeMode.dark,
                    ));
              }
            },
            child: const Text('Go back!'),
          ),
        ));
  }
}
