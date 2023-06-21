import 'package:flutter/material.dart';
import 'package:wish/data/wish_data.dart';
import 'package:wish/widgets/item/wish_item.dart';
import 'package:wish/themes/gallery_theme_data.dart';

enum PopupMenuType {
  edit,
  done,
  delete,
  addCount,
  checkIn,
}

typedef PopupMenuCallback = void Function(PopupMenuType type);

class PopupMenuUtils {
  PopupMenuUtils._();

  static const itemHeight = 40.0;
  static const itemWidth = 240.0;
  static const padding = 10;

  static Future<PopupMenuType?> show(BuildContext context, GlobalKey key, {PopupMenuCallback? callback}) {
    final itemData = (key.currentWidget as WishItem).itemData;
    debugPrint('itemData: $itemData');
    final isLight = Theme.of(context).brightness == Brightness.light;

    return showMenu(
      elevation: 8,
      context: context,
      color: isLight ? const Color(0XFFf1f1f1) : null,
      shape: RoundedRectangleBorder(
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        side: isLight ? BorderSide.none : const BorderSide(color: GalleryThemeData.darkGreenBorderColor),
      ),
      position: _getWidgetGlobalRect(context, key),
      constraints: const BoxConstraints(
        maxWidth: itemWidth + padding,
      ),
      items: _buildMenuItems(context, itemData, callback),
    );
  }

  static List<PopupMenuEntry<PopupMenuType>> _buildMenuItems(
      BuildContext context, WishData itemData, PopupMenuCallback? callback) {
    return [
      _buildMenuItem(context, PopupMenuType.edit, '编辑', Icons.edit_note_outlined, onTap: () {
        callback?.call(PopupMenuType.edit);
      }),
      const PopupMenuDivider(),
      ..._buildOptions(context, itemData, callback),
      _buildMenuItem(context, PopupMenuType.delete, '删除', Icons.delete_outline, color: Colors.red, onTap: () {
        callback?.call(PopupMenuType.delete);
      }),
    ];
  }

  static List<PopupMenuEntry<PopupMenuType>> _buildOptions(
      BuildContext context, WishData itemData, PopupMenuCallback? callback) {
    if (itemData.wishType == WishType.wish) {
      if (itemData.done) {
        return [
          _buildMenuItem(context, PopupMenuType.done, '取消完成', Icons.radio_button_unchecked_outlined, color: Colors.grey,
              onTap: () {
            callback?.call(PopupMenuType.done);
          }),
          const PopupMenuDivider(),
        ];
      } else {
        return [
          _buildMenuItem(context, PopupMenuType.done, '完成', Icons.radio_button_checked_outlined, onTap: () {
            callback?.call(PopupMenuType.done);
          }),
          const PopupMenuDivider(),
        ];
      }
    }
    if (itemData.wishType == WishType.repeat) {
      return [
        _buildMenuItem(context, PopupMenuType.addCount, '次数', Icons.plus_one_outlined, onTap: () {
          callback?.call(PopupMenuType.addCount);
        }),
        const PopupMenuDivider(),
        _buildMenuItem(context, PopupMenuType.done, '完成', Icons.radio_button_checked_outlined, onTap: () {
          callback?.call(PopupMenuType.done);
        }),
        const PopupMenuDivider(),
      ];
    }

    return [
      _buildMenuItem(context, PopupMenuType.checkIn, '打卡', Icons.done, onTap: () {
        callback?.call(PopupMenuType.checkIn);
      }),
      const PopupMenuDivider(),
      _buildMenuItem(context, PopupMenuType.done, '完成', Icons.radio_button_checked_outlined, onTap: () {
        callback?.call(PopupMenuType.done);
      }),
      const PopupMenuDivider(),
    ];
  }

  static PopupMenuItem<PopupMenuType> _buildMenuItem(
      BuildContext context, PopupMenuType type, String text, IconData iconData,
      {Color? color, required VoidCallback onTap}) {
    color ??= Theme.of(context).colorScheme.primary;
    return PopupMenuItem(
        value: type,
        onTap: onTap,
        height: itemHeight,
        child: SizedBox(
          width: itemWidth,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                  child: Text(
                text,
                style: const TextStyle(fontWeight: FontWeight.w800),
              )),
              Icon(
                iconData,
                size: 28,
                color: color,
              ),
            ],
          ),
        ));
  }

  static RelativeRect _getWidgetGlobalRect(BuildContext context, GlobalKey key) {
    final RenderBox renderBox = key.currentContext!.findRenderObject() as RenderBox;
    final offset = renderBox.localToGlobal(Offset.zero);
    debugPrint('Widget position: ${offset.dx} ${offset.dy} ${renderBox.size.width} ${renderBox.size.height}');
    final dx = (MediaQuery.of(context).size.width) / 2;
    return RelativeRect.fromLTRB(
      dx,
      offset.dy + renderBox.size.height * 0.7,
      10,
      20,
    );
  }
}
