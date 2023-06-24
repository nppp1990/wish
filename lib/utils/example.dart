import 'dart:math';

import 'package:wish/data/style/wish_options.dart';
import 'package:wish/data/wish_data.dart';
import 'package:wish/utils/struct.dart';

class EmptyTip {
  final String title;
  final String? author;

  EmptyTip(this.title, {this.author});
}

var _emptyTipsEn = [
  EmptyTip(
      'Without ideals, there is no beautiful wish\nand there will never be a beautiful reality.', author: 'Dostoevsky'),
  EmptyTip(
    'There is only one thing that makes people tired:\nhesitation and indecision.\nAnd every time you do something, you will be free\nEven if you do it badly, it is better than doing nothing',),
  EmptyTip(
      'In the new year, if you want to not waste time\nyou might as well take out a piece of letter paper\nWrite down your wishes, one by one'),
  EmptyTip('Written wishes\neasier to achieve'),
  EmptyTip(
      'Without ideals, there is no beautiful wish\nand there will never be a beautiful reality.', author: 'Dostoevsky'),
  EmptyTip(
    'There is only one thing that makes people tired:\nhesitation and indecision.\nAnd every time you do something, you will be free\nEven if you do it badly, it is better than doing nothing',),
  EmptyTip(
      'In the new year, if you want to not waste time\nyou might as well take out a piece of letter paper\nWrite down your wishes, one by one'),
  EmptyTip('Written wishes\neasier to achieve'),
  EmptyTip('Without ideals in the chest, living in vain for a lifetime'),
  EmptyTip('A person who realizes his dream is a successful person'),
  EmptyTip('Once the dream is put into action, it will become sacred', author: 'Procter'),
  EmptyTip('You can only be happy if you have a wish', author: 'Schiller'),
  EmptyTip(
      'No matter how vague the dream is\nIt is always hidden in our hearts\nMake our mood never get peace\nUntil these dreams become facts\n'),
  EmptyTip('The dream is the blueprint of the future', author: 'Victor Hugo'),
];

var _emptyTips = [
  EmptyTip('没有理想，即没有某种美好的愿望\n也就永远不会有美好的现实。', author: '陀思妥耶夫斯基'),
  EmptyTip(
      '只有一件事会使人疲劳：\n摇摆不定和优柔寡断。\n而每做一件事，都会使人身心解放\n即使把事情办坏了，也比什么都不做强',
      author: '茨威格'),
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

var _wishExampleEn = [
  WishExample('Experience a Different Life', steps: [
    'Read a book you have never read',
    'Walk a road you have never walked',
    'See a scenery you have never seen',
    'Smell a fragrance you have never smelled',
    'Listen to a bird song you have never heard',
    'Taste a food you have never tasted'
  ]),
  WishExample('Buy a house of your own'),
  WishExample('Rich, free and beautiful'),
  WishExample('Spend New Year\'s Eve with someone you like'),
  WishExample('Pass the postgraduate entrance examination'),
  WishExample('Cross the Eurasian continent', steps: [
    'Arrive at the northernmost point of Norway',
    'Enjoy the midnight sun'
  ]),
  WishExample(
    'Travel to the most beautiful places in the world',
    steps: [
      'The Great Wall of China',
      'The Pyramids of Egypt',
      'The Taj Mahal',
      'The Grand Canyon',
      'The Great Barrier Reef',
      'The Victoria Falls',
      'The Aurora Borealis',
      'The Parthenon',
      'The Colosseum',
      'The Eiffel Tower',
      'The Leaning Tower of Pisa',
      'The Statue of Liberty',
      'The Sydney Opera House',
      'The Golden Gate Bridge',
      'The London Eye',
      'The Burj Khalifa',
      'The Petronas Twin Towers',
      'The Sagrada Familia',
      'The Kremlin',
      'The Louvre',
      'The Alhambra',
      'The Neuschwanstein Castle',
      'The Acropolis of Athens',
      'The Stonehenge',
      'The Moai Statues',
      'The Machu Picchu',
      'The Angkor Wat',
      'The Mount Fuji',
      'The Mount Everest',
      'The Amazon Rainforest',
      'The Sahara Desert',
      'The Antarctica',
    ],
  ),
  WishExample('Buy a car'),
  WishExample('Learn to drive',),
  WishExample('Learn to swim'),
];

var _wishExample = [
  WishExample('体验不一样的人生', steps: [
    '读，从未读过的书',
    '走，从未走过的路',
    '看，从未看过的风景',
    '闻，从未闻过的清香',
    '听，从未听过的鸟语',
    '品，从未品过的美食'
  ]),
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
  WishExample('挣钱存钱',
      steps: ['做好存钱计划', '找一个记账app、学会记账', '尽早还清欠银行的钱', '尝试副业', '增强专业技能、涨工资']),
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

var _repeatExampleEn = [
  RepeatWishExample('Travel to 3 other cities', 3),
  RepeatWishExample('Read 10 books of humanities', 10),
  RepeatWishExample('Learn 3 ukulele fingerings', 3),
  RepeatWishExample('Volunteer 5 times', 5),
  RepeatWishExample('Learn 10 new dishes', 10),
];

var _repeatExample = [
  RepeatWishExample('去3个其他城市旅游', 3),
  RepeatWishExample('读10本人文类书', 10),
  RepeatWishExample('学会3首尤克里里指弹', 3),
  RepeatWishExample('做义工5次', 5),
  RepeatWishExample('学10到新菜', 10),
];

var _checkInExampleEn = [
  CheckInWishExample('Call home once a week', 7),
  CheckInWishExample('Exercise at least once a day', 1),
  CheckInWishExample('Personal public number, stable output 1 article per week', 7),
  CheckInWishExample('Read a book every month', 30),
  CheckInWishExample('Organize albums and network disks once a week', 7),
  CheckInWishExample('Keep 7 hours of sleep every day', 1),
  CheckInWishExample('Keep a diary every day', 1),
  CheckInWishExample('Post a note every week', 7),
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
    return _generate(HookData.instance.isChinese ? _wishExample : _wishExampleEn, lastIndex: lastIndex);
  }

  static Pair<int, RepeatWishExample> generateRepeatWish({int? lastIndex}) {
    return _generate(HookData.instance.isChinese ? _repeatExample : _repeatExampleEn, lastIndex: lastIndex);
  }

  static Pair<int, CheckInWishExample> generateCheckInWish({int? lastIndex}) {
    return _generate(HookData.instance.isChinese ? _checkInExample : _checkInExampleEn, lastIndex: lastIndex);
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
    if (HookData.instance.isChinese) {
      return _emptyTips[Random().nextInt(_emptyTips.length)];
    } else {
      return _emptyTipsEn[Random().nextInt(_emptyTipsEn.length)];
    }
  }
}
