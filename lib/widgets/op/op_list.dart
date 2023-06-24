import 'package:flutter/material.dart';
import 'package:wish/data/wish_op.dart';

class OpListOption {
  final bool showEdit;
  final bool showName;

  OpListOption({this.showEdit = false, this.showName = false});
}

class OpList extends StatelessWidget {
  final List<WishOp> list;
  final EdgeInsetsGeometry? padding;
  final OpListOption? option;

  const OpList({super.key, required this.list, this.padding, this.option});

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
          (_, int index) => OpItem(
                op: list[index],
                padding: padding,
                option: option,
              ),
          childCount: list.length),
    );
  }
}

class OpItem extends StatelessWidget {
  final WishOp op;
  final EdgeInsetsGeometry? padding;
  final OpListOption? option;

  const OpItem({super.key, required this.op, this.padding, this.option});

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    final showName = option?.showName ?? false;
    final lineColor = colorScheme.primary.withOpacity(0.2);
    final subTitlePair = op.getShowTitle2(context);
    final double itemHeight;
    if (subTitlePair == null) {
      itemHeight = 70.0 + (showName ? 15.0 : 0.0);
    } else {
      itemHeight = 70.0 + 15.0 * subTitlePair.second + (showName ? 15.0 : 0.0);
    }
    var subTitle = subTitlePair?.first;
    var labelText = Text(
      op.getShowTitle1(context, !showName),
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
    );

    return Container(
      padding: padding,
      height: itemHeight,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Column(
            children: [
              Container(
                width: 26,
                height: 26,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: lineColor, width: 1),
                ),
                child: _buildIcon(colorScheme, op.opType, 16),
              ),
              Expanded(
                child: Container(
                  width: 1,
                  color: lineColor,
                ),
              ),
            ],
          ),
          const SizedBox(width: 10),
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: showName
                        ? Text(
                            op.wishName,
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                          )
                        : labelText,
                  ),
                  Text(
                    op.getShowTime(),
                    style: TextStyle(fontSize: 14, color: colorScheme.primary.withOpacity(0.6)),
                  ),
                ],
              ),
              if (option?.showName ?? false) ...[
                const SizedBox(height: 5),
                labelText,
              ],
              const SizedBox(height: 5),
              if (subTitle != null && subTitle.isNotEmpty)
                RichText(
                  text: TextSpan(
                      style: TextStyle(fontSize: 14, color: colorScheme.primary.withOpacity(0.6)),
                      children: subTitle
                          .map((editDesc) => TextSpan(
                                text: editDesc.value,
                                style: TextStyle(
                                  color: editDesc.color ??
                                      (editDesc.isKey ? colorScheme.primary : colorScheme.primary.withOpacity(0.6)),
                                ),
                              ))
                          .toList()),
                )
            ],
          )),
        ],
      ),
    );
  }

  Widget _buildIcon(ColorScheme colorScheme, WishOpType type, double size) {
    final IconData icon;
    switch (type) {
      case WishOpType.create:
        icon = Icons.add;
        break;
      case WishOpType.edit:
        icon = Icons.edit;
        break;
      case WishOpType.delete:
        icon = Icons.delete;
        break;
      default:
        icon = Icons.update;
    }
    return Icon(
      icon,
      size: size,
      color: colorScheme.primary.withOpacity(0.6),
    );
  }
}
