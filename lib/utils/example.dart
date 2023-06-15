import 'dart:math';

import 'package:wish/data/wish_data.dart';
import 'package:wish/utils/struct.dart';

class EmptyTip {
  final String title;
  final String? author;

  EmptyTip(this.title, {this.author});
}

var _emptyTips = [
  EmptyTip('没有理想，即没有某种美好的愿望\n也就永远不会有美好的现实。', author: '陀思妥耶夫斯基'),
  EmptyTip('只有一件事会使人疲劳：\n摇摆不定和优柔寡断。\n而每做一件事，都会使人身心解放\n即使把事情办坏了，也比什么都不做强', author: '茨威格'),
  EmptyTip('新的一年，想要不虚度光阴\n就要趁早谋划，树立新的目标\n不妨拿出一张信笺\n把自己的愿望，一笔一划写下来'),
  EmptyTip('写下来的愿望\n更容易实现'),
  EmptyTip('胸无理想，枉活一世'),
  EmptyTip('一个实现梦想的人，就是一个成功的人'),
  EmptyTip('梦想一旦被付诸行动，就会变得神圣', author: '普罗克特'),
  EmptyTip('有愿望才会幸福', author: '席勒'),
  EmptyTip('梦想无论怎样模糊\n总潜伏在我们心底\n使我们的心境永远得不到宁静\n直到这些梦想成为事实\n'),
  EmptyTip('世界上最快乐的事\n莫过于为理想而奋斗', author: '苏格拉底'),
];

class BaseExample {
  final String title;

  BaseExample(this.title);
}

class WishExample extends BaseExample {
  final List<String>? steps;

  WishExample(super.title, {this.steps});
}

class RepeatWishExample extends BaseExample {
  final int repeatCount;

  RepeatWishExample(super.title, this.repeatCount);
}

class CheckInWishExample extends BaseExample {
  final int periodDays;

  CheckInWishExample(super.title, this.periodDays);
}

var _wishExample = [
  WishExample('体验不一样的人生',
      steps: ['读，从未读过的书', '走，从未走过的路', '看，从未看过的风景', '闻，从未闻过的清香', '听，从未听过的鸟语', '品，从未品过的美食']),
  WishExample('买套属于自己的房子'),
  WishExample('有钱有闲有颜'),
  WishExample('去重庆吃地道的重庆火锅'),
  WishExample('和喜欢的人一起跨年'),
  WishExample('考研上岸'),
  WishExample('穿过亚欧大陆抵达挪威的北角欣赏午夜的阳光'),
  WishExample(
    '和心仪的妹子表白',
  ),
  WishExample('带爸妈出游'),
  WishExample('带爸妈完成年度体检一次'),
  WishExample('买一个游戏本'),
  WishExample(
    '约上好友出门旅行，体验潇洒率性的生活',
  ),
  WishExample(
    '做好理财管理',
  ),
  WishExample(
    '练出马甲线',
  ),
  WishExample('挣钱存钱', steps: ['做好存钱计划', '找一个记账app、学会记账', '尽早还清欠银行的钱', '尝试副业', '增强专业技能、涨工资']),
  WishExample('拍一组写真', steps: [
    '找个好地方',
    '找个好摄影师',
    '挑个好天气',
    '找个好心情go',
  ]),
  WishExample(
    '拍一次全家福',
  ),
  WishExample('精通一门外语', steps: ['选一个外语', '找个好学习方法', '定好计划', '认真实施']),
  WishExample(
    '去看日出日落',
  ),
  WishExample(
    '当一次群演',
  ),
];

var _repeatExample = [
  RepeatWishExample('去3个其他城市旅游', 3),
  RepeatWishExample('读10本人文类书', 10),
  RepeatWishExample('学会3首尤克里里指弹', 3),
  RepeatWishExample('做义工5次', 5),
  RepeatWishExample('学10到新菜', 10),
];

var _checkInExample = [
  CheckInWishExample('每周主动给家里打一次电话', 7),
  CheckInWishExample('每天至少做一次运动', 1),
  CheckInWishExample('个人公众号，每周稳定输出 1 篇', 7),
  CheckInWishExample('每月读一本书', 30),
  CheckInWishExample('每周整理一次相册和网盘', 7),
  CheckInWishExample('保持每天7小时充足睡眠', 1),
  CheckInWishExample('每天坚持写日记', 1),
  CheckInWishExample('每周发一篇笔记', 7),
];

class ExampleGenerate {
  ExampleGenerate._internal();

  static Pair<int, T> _generate<T>(List<T> example, {int? lastIndex}) {
    while (true) {
      int randomIndex = Random().nextInt(example.length);
      // 排除掉上一次的 lastIndex的随机index
      if (randomIndex != lastIndex) {
        return Pair(randomIndex, example[randomIndex]);
      }
    }
  }

  static Pair<int, WishExample> generateWish({int? lastIndex}) {
    return _generate(_wishExample, lastIndex: lastIndex);
  }

  static Pair<int, RepeatWishExample> generateRepeatWish({int? lastIndex}) {
    return _generate(_repeatExample, lastIndex: lastIndex);
  }

  static Pair<int, CheckInWishExample> generateCheckInWish({int? lastIndex}) {
    return _generate(_checkInExample, lastIndex: lastIndex);
  }

  static Pair<int, BaseExample> generateByIndex(WishType wishType, {int? lastIndex}) {
    switch (wishType) {
      case WishType.wish:
        return generateWish(lastIndex: lastIndex);
      case WishType.repeat:
        return generateRepeatWish(lastIndex: lastIndex);
      case WishType.checkIn:
        return generateCheckInWish(lastIndex: lastIndex);
    }
  }

  static EmptyTip generateEmptyTip() {
    return _emptyTips[Random().nextInt(_emptyTips.length)];
  }
}
