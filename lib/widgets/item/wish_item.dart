import 'package:flutter/material.dart';
import 'package:wish/data/wish_data.dart';
import 'package:wish/themes/wish_theme_data.dart';
import 'package:wish/utils/timeUtils.dart';
import 'package:wish/widgets/item/progress_circle.dart';
import 'package:flutter_gen/gen_l10n/wish_localizations.dart';

class WishItem extends StatelessWidget {
  final WishData itemData;
  final GestureTapCallback? onTap;
  final GestureLongPressCallback? onLongPress;
  final Animation? animation;
  final SortType? sortType;

  const WishItem({super.key, required this.itemData, this.onTap, this.onLongPress, this.animation, this.sortType});

  @override
  Widget build(BuildContext context) {
    if (animation == null) {
      return _buildRealItem(context, null);
    }
    return AnimatedBuilder(
      animation: animation!,
      builder: (BuildContext context, Widget? child) {
        return _buildRealItem(context, animation);
      },
    );
  }

  Widget _buildRealItem(BuildContext context, Animation? animation) {
    Widget optionRow;
    bool isLight = Theme.of(context).brightness == Brightness.light;
    var colorScheme = Theme.of(context).colorScheme;
    if (itemData.wishType == WishType.wish) {
      if (itemData.done && (itemData.stepList?.isNotEmpty ?? false)) {
        optionRow = Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 1),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: colorScheme.primary, width: 1),
              ),
              child: const Text('done', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12)),
            ),
            const SizedBox(
              width: 10,
            ),
            _buildEndTime(context, colorScheme),
          ],
        );
      } else {
        optionRow = _buildEndTime(context, colorScheme);
      }
    } else {
      optionRow = Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildCompletion(context),
          const SizedBox(
            width: 10,
          ),
          _buildEndTime(context, colorScheme),
        ],
      );
    }

    return InkWell(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Ink(
        height: 96,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: isLight ? colorScheme.secondary : colorScheme.primaryContainer,
          border: isLight ? null : Border.all(color: WishThemeData.darkGreenBorderColor, width: 1),
          boxShadow: isLight
              ? [
                  BoxShadow(
                    color: Colors.grey.withOpacity(animation == null ? 0.5 : 0.5 * animation.value),
                    spreadRadius: 2,
                    blurRadius: 3,
                    offset: const Offset(1, 1),
                  ),
                ]
              : null,
        ),
        child: Row(
          children: [
            Container(
              width: 10,
              decoration: BoxDecoration(
                color: itemData.colorType.toColor(),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(
              width: 15,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    itemData.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 18),
                  ),
                  const SizedBox(
                    height: 3,
                  ),
                  _buildIconTagLayout(context, colorScheme),
                  const SizedBox(
                    height: 4,
                  ),
                  optionRow,
                ],
              ),
            ),
            _buildProgress(colorScheme),
          ],
        ),
      ),
    );
  }

  Widget _buildIconTagLayout(BuildContext context, ColorScheme colorScheme) {
    final String label = itemData.wishType.getShowTitle(context);
    final IconData icon;
    switch (itemData.wishType) {
      case WishType.wish:
        icon = Icons.favorite_border_outlined;
        break;
      case WishType.repeat:
        icon = Icons.repeat;
        break;
      default:
        icon = Icons.lock_clock;
        break;
    }
    var localizations = WishLocalizations.of(context)!;

    return Row(
      children: [
        Icon(
          icon,
          color: colorScheme.primary,
          size: 18,
        ),
        const SizedBox(
          width: 2,
        ),
        Text(label, style: const TextStyle(fontSize: 14)),
        const SizedBox(
          width: 6,
        ),
        if (sortType == SortType.createdTime)
          Text('${localizations.createdAt}${TimeUtils.getShowDate(itemData.createdTime!)}',
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w300))
        else if (sortType == SortType.modifiedTime)
          Text('${localizations.modifiedAt}${TimeUtils.getShowDate(itemData.modifiedTime!)}',
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w300)),
      ],
    );
  }

  Widget _buildEndTime(BuildContext context, ColorScheme colorScheme) {
    WishLocalizations localizations = WishLocalizations.of(context)!;
    final String showText;
    if (itemData.endTime == null) {
      showText = localizations.timeNoLimit;
      return Text(showText, style: TextStyle(fontSize: 14, color: colorScheme.primary.withOpacity(0.2)));
    }
    // itemData.timeOfDay和now相差多少天
    int day = itemData.endTime!.difference(DateTime.now()).inDays;
    if (day < 0) {
      showText = localizations.timeExpired(-day);
      return Text(showText, style: const TextStyle(fontSize: 14, color: Colors.red));
    }
    showText = localizations.timeRemainingDay(day);
    if (day <= 3) {
      return Text(showText, style: TextStyle(fontSize: 14, color: Colors.red[300]));
    }

    return Text(showText, style: TextStyle(fontSize: 14, color: colorScheme.primary.withOpacity(0.4)));
  }

  Widget _buildProgress(ColorScheme colorScheme) {
    if (itemData.wishType == WishType.wish) {
      if (itemData.stepList == null || itemData.stepList!.isEmpty) {
        return Icon(
          itemData.done ? Icons.radio_button_checked_outlined : Icons.radio_button_unchecked_outlined,
          color: colorScheme.primary,
          // size: 40,
        );
      }
      int count = 0;
      for (final step in itemData.stepList!) {
        if (step.done) {
          count++;
        }
      }
      return ProgressCircle(
        size: 40,
        value: count / itemData.stepList!.length,
        color: colorScheme.primary,
      );
    }
    return Icon(
      itemData.done ? Icons.radio_button_checked_outlined : Icons.radio_button_unchecked_outlined,
      color: colorScheme.primary,
    );
  }

  // 完成情况
  Widget _buildCompletion(BuildContext context) {
    if (itemData.wishType == WishType.repeat) {
      return Text('${itemData.actualRepeatCount ?? 0}/${itemData.repeatCount}', style: const TextStyle(fontSize: 14));
    } else {
      return Text('${WishLocalizations.of(context)!.checkInCount}: ${itemData.checkedTimeList?.length ?? 0}',
          style: const TextStyle(fontSize: 14));
    }
  }

  String getDate(DateTime? date) {
    return '${date!.year}-${date.month}-${date.day}';
  }
}
