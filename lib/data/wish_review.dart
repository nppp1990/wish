import 'package:wish/data/wish_data.dart';

class WishStatics {
  final int total;
  final int done;
  final int? delay;
  final int? delete;
  final int? doing;

  WishStatics({required this.total, required this.done, this.delay, this.delete, this.doing});

  factory WishStatics.fromWishList(List<WishData> wishList) {
    var totalCount = 0;
    var doneCount = 0;
    var delayCount = 0;
    final curTime = DateTime.now();
    for (var wish in wishList) {
      totalCount++;
      if (wish.done) {
        doneCount++;
      } else if (wish.endTime != null && wish.endTime!.isBefore(curTime)) {
        delayCount++;
      }
    }
    return WishStatics(
      total: totalCount,
      done: doneCount,
      delay: delayCount,
    );
  }
}
