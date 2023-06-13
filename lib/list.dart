import 'dart:async';

import 'package:animated_list_plus/animated_list_plus.dart';
import 'package:flutter/material.dart';
import 'package:wish/data/data_base_helper.dart';
import 'package:wish/data/event_manager.dart';
import 'package:wish/data/wish_data.dart';
import 'package:wish/edit_page.dart';
import 'package:wish/op_page.dart';
import 'package:wish/router/router_utils.dart';
import 'package:wish/widgets/common/wish_loading.dart';
import 'package:wish/widgets/drawer.dart';
import 'package:wish/widgets/item/item_menu.dart';
import 'package:wish/widgets/item/wish_item.dart';
import 'package:implicitly_animated_reorderable_list/transitions.dart';

final class WishList extends StatefulWidget {
  final DrawerType drawerType;
  final SortType sortType;
  final bool isAsc;
  final VoidCallback onPressEmpty;

  const WishList(
      {super.key,
      required this.drawerType,
      required this.sortType,
      required this.isAsc,
      required this.onPressEmpty});

  @override
  State<StatefulWidget> createState() => _WishListState();
}

class _WishListState extends State<WishList> {
  List<WishData>? dataList;
  WishLoadingType loadingType = WishLoadingType.loading;
  late StreamSubscription<AddEvent> addListener;
  late StreamSubscription<DeleteWishEvent> delListener;
  StreamSubscription<UpdateWishEvent>? updateListener;

  @override
  void initState() {
    super.initState();
    loadData();
    addListener = eventBus.on<AddEvent>().listen((event) {
      loadData();
    });
    delListener = eventBus.on<DeleteWishEvent>().listen((event) {
      if (dataList == null ||
          event.index >= dataList!.length ||
          dataList![event.index].id != event.id) {
        return;
      }
      setState(() {
        dataList!.removeAt(event.index);
      });
    });
    updateListener = eventBus.on<UpdateWishEvent>().listen((event) {
      if (dataList == null || dataList!.length <= event.index) {
        return;
      }
      if (dataList![event.index].id == event.id) {
        loadItemData(event.index, event.id);
      }
    });
  }

  @override
  dispose() {
    addListener.cancel();
    delListener.cancel();
    updateListener?.cancel();
    super.dispose();
  }

  @override
  void didUpdateWidget(oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.drawerType != widget.drawerType ||
        oldWidget.sortType != widget.sortType ||
        oldWidget.isAsc != widget.isAsc) {
      loadData();
    }
  }

  Future<void> loadData() async {
    setState(() {
      loadingType = WishLoadingType.loading;
    });
    var time1 = DateTime.now();
    List<WishData>? res;
    if (widget.drawerType == DrawerType.wishList) {
      res = await DatabaseHelper.instance
          .getWishListByType(WishType.wish, widget.sortType, widget.isAsc);
    } else if (widget.drawerType == DrawerType.repeatList) {
      res = await DatabaseHelper.instance
          .getWishListByType(WishType.repeat, widget.sortType, widget.isAsc);
    } else if (widget.drawerType == DrawerType.checkInList) {
      res = await DatabaseHelper.instance
          .getWishListByType(WishType.checkIn, widget.sortType, widget.isAsc);
    } else if (widget.drawerType == DrawerType.doneList) {
      res = await DatabaseHelper.instance.getWishDoneList(widget.sortType, widget.isAsc);
    } else {
      res = await DatabaseHelper.instance.getAllWish(widget.sortType, widget.isAsc);
    }
    print(
        '${widget.drawerType}---dur:${DateTime.now().difference(time1).inMilliseconds}---res:$res');
    setState(() {
      if (res == null) {
        loadingType = WishLoadingType.error;
      } else if (res.isEmpty) {
        loadingType = WishLoadingType.empty;
      } else {
        dataList = res;
        loadingType = WishLoadingType.success;
      }
    });
  }

  Future<void> loadItemData(int index, int id) async {
    var time1 = DateTime.now();
    WishData? newItem = await DatabaseHelper.instance.getWishById(id);
    print('---loadItemData dur:${DateTime.now().difference(time1).inMilliseconds}');
    if (newItem != null) {
      setState(() {
        print('----newIte:${newItem.done}----${widget.drawerType}');
        if (widget.drawerType == DrawerType.doneList && !newItem.done) {
          print('-----?');
          dataList!.removeAt(index);
        } else {
          dataList![index] = newItem;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WishLoading(
        type: loadingType,
        onRefresh: loadData,
        onPressEmpty: widget.onPressEmpty,
        builder: () {
          return ImplicitlyAnimatedList<WishData>(
            padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
            items: dataList!,
            areItemsTheSame: (a, b) => a.id == b.id,
            itemBuilder: (context, animation, item, index) {
              return SizeFadeTransition(
                key: ValueKey(item.id),
                sizeFraction: 0.7,
                curve: Curves.easeInOut,
                animation: animation,
                child: _buildListItem(item, animation, index, widget.sortType),
              );
            },
          );
        });
  }

  _buildListItem(WishData wishData, Animation animation, int index, SortType sortType) {
    GlobalKey key = GlobalKey();
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: WishItem(
        key: key,
        animation: animation,
        sortType: sortType,
        onLongPress: () async {
          var res = await PopupMenuUtils.show(context, key);
          debugPrint('longPressed:$res');
          if (res == null) {
            return;
          }
          switch (res) {
            case PopupMenuType.delete:
              _deleteListItem(wishData, index);
              break;
            case PopupMenuType.edit:
              _gotoEditPage(wishData, index);
              break;
            case PopupMenuType.addCount:
              _addWishActualRepeatCount(wishData, index);
              break;
            case PopupMenuType.done:
              _handleDoneWish(wishData, index);
              break;
            case PopupMenuType.checkIn:
              _gotoOpPage(wishData, index);
          }
        },
        onTap: () {
          _gotoOpPage(wishData, index);
        },
        itemData: wishData,
      ),
    );
  }

  _deleteListItem(WishData wish, int index) async {
    final confirm = await showDeleteDialog(context, wish);
    if (confirm == null || !confirm) {
      return;
    }
    var time1 = DateTime.now();
    int res = await DatabaseHelper.instance.deleteWish(wish);
    print('---del dur:${DateTime.now().difference(time1).inMilliseconds}');
    if (res > 0) {
      setState(() {
        // loadData();
        dataList!.removeAt(index);
      });
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('删除失败'),
            duration: Duration(seconds: 1),
          ),
        );
      }
    }
  }

  _gotoOpPage(WishData wish, int index) {
    Navigator.push(
        context,
        Right2LeftRouter(
            child: OpPage(
          itemData: wish,
          index: index,
        )));
  }

  _gotoEditPage(WishData wish, int index) {
    Navigator.push(
        context,
        Right2LeftRouter(
            child: EditPage(
          index: index,
          pageType: WishPageType.edit,
          wishData: wish,
        )));
  }

  _addWishActualRepeatCount(WishData wishData, int index) async {
    var time1 = DateTime.now();
    var res = await DatabaseHelper.instance.updateActualRepeatCount(
        wishData, wishData.actualRepeatCount, (wishData.actualRepeatCount ?? 0) + 1);
    print(
        '${wishData.actualRepeatCount}---res:$res----add dur:${DateTime.now().difference(time1).inMilliseconds}');
    loadItemData(index, wishData.id!);
  }

  _handleDoneWish(WishData wishData, int index) async {
    var time1 = DateTime.now();
    var res = await DatabaseHelper.instance.handleDoneOp(wishData, !wishData.done);
    print('dur:${DateTime.now().difference(time1).inMilliseconds}');
    loadItemData(index, wishData.id!);
  }

  Future<bool?> showDeleteDialog(BuildContext context, WishData wish) async {
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
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
        );
      },
    );
  }
}
