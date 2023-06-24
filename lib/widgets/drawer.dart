import 'package:flutter/material.dart';
import 'package:wish/data/wish_data.dart';
import 'package:flutter_gen/gen_l10n/wish_localizations.dart';

typedef DrawerCallback = void Function(DrawerType type);

enum DrawerType {
  allList,
  wishList,
  repeatList,
  checkInList,
  doneList,
  review,
  setting;

  String getShowTitle(BuildContext context) {
    WishLocalizations localizations = WishLocalizations.of(context)!;
    switch (this) {
      case DrawerType.wishList:
        return localizations.desireLabel;
      case DrawerType.repeatList:
        return localizations.repeatTaskLabel;
      case DrawerType.checkInList:
        return localizations.checkInTaskLabel;
      case DrawerType.setting:
        return localizations.setting;
      case DrawerType.doneList:
        return localizations.doneLabel;
      case DrawerType.review:
        return localizations.reviewLabel;
      case DrawerType.allList:
      default:
        return localizations.allWish;
    }
  }

  IconData _getIcon() {
    switch (this) {
      case DrawerType.wishList:
        return Icons.favorite;
      case DrawerType.repeatList:
        return Icons.repeat;
      case DrawerType.checkInList:
        return Icons.lock_clock;
      case DrawerType.setting:
        return Icons.settings;
      case DrawerType.doneList:
        return Icons.radio_button_checked_outlined;
      case DrawerType.review:
        return Icons.history;
      case DrawerType.allList:
        return Icons.list;
    }
  }

  WishType? getWishType() {
    if (this == DrawerType.wishList) {
      return WishType.wish;
    }
    if (this == DrawerType.repeatList) {
      return WishType.repeat;
    }
    if (this == DrawerType.checkInList) {
      return WishType.checkIn;
    }
    return null;
  }
}

class DrawerLayout extends StatelessWidget {
  final DrawerCallback callback;
  final DrawerType drawerType;

  const DrawerLayout({
    super.key,
    required this.drawerType,
    required this.callback,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 20, left: 20, bottom: 20),
            child: Text(drawerType.getShowTitle(context), style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900)),
          ),
          _buildItem(context, DrawerType.allList),
          _buildItem(context, DrawerType.wishList),
          _buildItem(context, DrawerType.repeatList),
          _buildItem(context, DrawerType.checkInList),
          const Divider(
            thickness: 1,
            indent: 60,
          ),
          _buildItem(context, DrawerType.doneList),
          const Divider(
            thickness: 1,
            indent: 60,
          ),
          _buildItem(context, DrawerType.review),
          const Divider(
            thickness: 1,
            indent: 60,
          ),
          _buildItem(context, DrawerType.setting),
        ],
      ),
    );
  }

  Widget _buildItem(BuildContext context, DrawerType type) {
    return ListTile(
      selected: type == drawerType,
      title: Text(type.getShowTitle(context)),
      leading: Icon(type._getIcon()),
      onTap: () {
        Navigator.pop(context);
        callback.call(type);
      },
    );
  }
}
