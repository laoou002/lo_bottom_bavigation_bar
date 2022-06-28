import 'package:flutter/material.dart';

import 'lo_bottom_navigation_bar.dart';
import 'lo_bottom_navigation_bar_item.dart' as MyBarItem;
import 'lo_player_tab_item.dart';
import 'lo_tab_page.dart';

class HomeTabBar extends StatefulWidget {
  const HomeTabBar({Key? key}) : super(key: key);

  @override
  _HomeTabBarState createState() => _HomeTabBarState();
}

class _Item {
  String name, activeIcon, normalIcon;

  _Item(this.name, this.activeIcon, this.normalIcon);
}

class _HomeTabBarState extends State<HomeTabBar> with TickerProviderStateMixin {
  late List<Widget> pages;

  final defaultItemColor = const Color.fromARGB(255, 125, 125, 125);

  late List<AnimationController> animationControllers = [];

  late List<Animation<double>> animations = [];

  final itemNames = [
    _Item('首页', 'assets/images/tabbar00_h.png', 'assets/images/tabbar00.png'),
    _Item('成长墙', 'assets/images/tabbar01_h.png', 'assets/images/tabbar01.png'),
    _Item('', 'assets/images/tabbar02_h.png', 'assets/images/tabbar02.png'),
    _Item('已购', 'assets/images/tabbar03_h.png', 'assets/images/tabbar03.png'),
    _Item('我的', 'assets/images/tabbar04_h.png', 'assets/images/tabbar04.png')
  ];

  late List<MyBarItem.BottomNavigationBarItem> itemList;

  double progress = 0;

  Image playIcon = Image.asset("assets/images/tabbar02_h.png");
  Image pauseIcon = Image.asset("assets/images/tabbar02.png");
  bool isPlaying = false;

  @override
  void initState() {
    super.initState();
    debugPrint('initState _ContainerPageState');

    /// 刷新进度，演示所用
    reloadProgress(100);

    /// barItem对应的页面
    pages = [
      const MyPage(title: "首页"),
      const MyPage(title: "成长墙"),
      const MyPage(title: ""),
      const MyPage(title: "已购"),
      const MyPage(title: "个人中心"),
    ];

    animationControllers = [];
    itemList = [];
    for (var i = 0; i < itemNames.length; i++) {
      /// 为每个barItem创建单独的动画控制器
      AnimationController controller = _getAnimationController();
      animationControllers.add(controller);

      /// 为每个barItem创建的动画
      Animation<double> animate = _getAnimation(controller);
      animations.add(animate);

      itemList.add(_getBarItem(i, itemNames[i]));
    }
  }

  int _selectIndex = 0;

  final PlayerTabItem _playerItemLocation =
      PlayerTabItem(FloatingActionButtonLocation.centerDocked, 0, 24);

  /// 获取动画控制器
  AnimationController _getAnimationController() {
    AnimationController animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    return animationController;
  }

  /// 获取BarItem
  MyBarItem.BottomNavigationBarItem _getBarItem(int index, _Item item) {
    Animation<double> animation = animations[index];
    MyBarItem.BottomNavigationBarItem barItem =
        MyBarItem.BottomNavigationBarItem(
            icon: Image.asset(
              item.normalIcon,
              width: 30.0,
              height: 30.0,
            ),
            label: item.name,
            activeIcon: Image.asset(
              item.activeIcon,
              width: 30.0,
              height: 30.0,
            ));
    barItem.index = index;
    barItem.animation = animation;
    return barItem;
  }

  /// 多个缩放点的缩放动画
  Animation<double> _getAnimation(AnimationController controller) {
    List values = [1.0, 1.4, 0.9, 1.15, 0.95, 1.02, 1.0];
    double preValue = 1.0;
    List<TweenSequenceItem<double>> tweenItems = [];
    for (int i = 0; i < values.length; i++) {
      if (i != 0) {
        tweenItems.add(TweenSequenceItem<double>(
          tween: Tween(begin: preValue, end: values[i]),
          weight: 1,
        ));
      }
      preValue = values[i];
    }
    return TweenSequence<double>(tweenItems).animate(controller);
  }

  Widget _getPagesWidget(int index) {
    return Offstage(
      offstage: _selectIndex != index,
      child: TickerMode(
        enabled: _selectIndex == index,
        child: pages[index],
      ),
    );
  }

  @override
  void didUpdateWidget(HomeTabBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    debugPrint('didUpdateWidget');
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('build _ContainerPageState');

    Animation<double> animation = animations[2];

    return Scaffold(
      body: Stack(
        children: [
          _getPagesWidget(0),
          _getPagesWidget(1),
          _getPagesWidget(2),
          _getPagesWidget(3),
          _getPagesWidget(4),
        ],
      ),
      backgroundColor: const Color.fromARGB(255, 248, 248, 248),
      bottomNavigationBar: MyBottomNavigationBar(
        items: itemList,
        onTap: (int index) {
          ///这里根据点击的index来显示，非index的page均隐藏
          setState(() {
            _selectIndex = index;
          });

          AnimationController animationController = animationControllers[index];
          animationController.reset();
          animationController.forward();
        },
        //图标大小
        iconSize: 24,
        // selectedItemColor: const Color(0xFF29CCCC),
        //当前选中的索引
        currentIndex: _selectIndex,
        selectedFontSize: 12,
        unselectedFontSize: 12,
        //选中后，底部BottomNavigationBar内容的颜色(选中时，默认为主题色)（仅当type: BottomNavigationBarType.fixed,时生效）
        fixedColor: const Color(0xFF29CCCC),
        type: MyBottomNavigationBarType.fixed,
      ),
      floatingActionButton: SizedBox(
        height: 70,
        width: 70,
        child: ScaleTransition(
            scale: animation,
            child: FloatingActionButton(
              backgroundColor: Colors.white,
              foregroundColor: Colors.white,
              child: Stack(
                children: [
                  SizedBox(
                    height: 70,
                    width: 70,
                    child: CircularProgressIndicator(
                      value: progress,
                      backgroundColor: const Color(0xffcccccc),
                      color: const Color(0xff29cccc),
                    ),
                  ),
                  isPlaying ? playIcon : pauseIcon,
                ],
              ),
              onPressed: () {
                setState(() {
                  isPlaying = !isPlaying;
                });
                AnimationController animationController =
                    animationControllers[2];
                animationController.reset();
                animationController.forward();
              },
            )),
      ),
      floatingActionButtonLocation: _playerItemLocation, //放在中间
    );
  }

  /// 这里简单演示播放圆形进度
  void reloadProgress(int milliseconds) {
    if (isPlaying) {
      setState(() {
        if (progress < 1) {
          progress = progress + 0.01;
        }
      });
    }
    Future.delayed(Duration(milliseconds: milliseconds), () {
      reloadProgress(milliseconds);
    });
  }
}
