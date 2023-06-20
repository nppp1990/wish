import 'package:flutter/material.dart';
import 'package:wish/data/style/wish_options.dart';
import 'package:wish/data/wish_data.dart';

typedef DrawerCallback = void Function(DrawerType type);

enum DrawerType {
  allList,
  wishList,
  repeatList,
  checkInList,
  doneList,
  review,
  setting;

  @override
  String toString() {
    switch (this) {
      case DrawerType.wishList:
        return '心想事成';
      case DrawerType.repeatList:
        return '重复任务';
      case DrawerType.checkInList:
        return '打卡任务';
      case DrawerType.setting:
        return '设置';
      case DrawerType.doneList:
        return '已完成';
      case DrawerType.review:
        return '回顾';
      case DrawerType.allList:
      default:
        return '全部心愿';
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
            child: Text(drawerType.toString(), style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900)),
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
          Divider(
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
    var isDark = WishOptions.of(context).themeMode == ThemeMode.dark;
    return ListTile(
      selected: type == drawerType,
      title: Text(type.toString()),
      // selectedTileColor: isDark ? GalleryThemeData.test1 : const Color(0XFFE8E8E8),
      leading: Icon(type._getIcon()),
      onTap: () {
        Navigator.pop(context);
        callback.call(type);
      },
    );
  }
}
