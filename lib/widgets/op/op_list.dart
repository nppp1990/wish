import 'package:flutter/material.dart';
import 'package:wish/data/wish_op.dart';

class OpList extends StatelessWidget {
  final List<WishOp> list;
  final EdgeInsetsGeometry? padding;

  const OpList({super.key, required this.list, this.padding});

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
          (_, int index) => OpItem(
                op: list[index],
                padding: padding,
              ),
          childCount: list.length),
    );
  }
}

class OpItem extends StatelessWidget {
  final WishOp op;
  final EdgeInsetsGeometry? padding;

  const OpItem({super.key, required this.op, this.padding});

  @override
  Widget build(BuildContext context) {
    final lineColor = Colors.black.withOpacity(0.2);
    final subTitle = op.getShowTitle2();
    return Container(
      padding: padding,
      height: 100,
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
                child: _buildIcon(op.opType, 16),
              ),
              Container(
                height: 74,
                width: 1,
                color: lineColor,
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
                    child: Text(
                      op.getShowTitle1(),
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                  ),
                  Text(
                    op.getShowTime(),
                    style: TextStyle(fontSize: 14, color: Colors.black.withOpacity(0.6)),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              if (subTitle != null && subTitle.isNotEmpty)
                RichText(
                  text: TextSpan(
                      style: TextStyle(fontSize: 14, color: Colors.black.withOpacity(0.6)),
                      children: subTitle
                          .map((editDesc) => TextSpan(
                                text: editDesc.value,
                                style: TextStyle(
                                  color: editDesc.color ??
                                      (editDesc.isKey
                                          ? Colors.black
                                          : Colors.black.withOpacity(0.6)),
                                ),
                              ))
                          .toList()),
                  // style: TextStyle(fontSize: 14, color: Colors.black.withOpacity(0.6)),
                )
            ],
          )),
        ],
      ),
    );
  }

  Widget _buildIcon(WishOpType type, double size) {
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
      color: Colors.black.withOpacity(0.6),
    );
  }
}
