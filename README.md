# 场景：

在实际项目开发过程中，app底部tabbar常常有每个公司不同项目自己的**专属定制**，或**自定义动画**，或**自定义样式**；然而系统自带的BottomNavigationBarItem和pub.dev中的第三方库**限制太死**，并不符合实际用途。

> 本文主要给BottomNavigationBarItem的点击添加了**弹簧缩放动画**，并调整了BottomNavigationBarItem的主要**widget**。
> 各位同学可以参考，添加自己的专属动画，或者将BottomNavigationBarItem的**child**修改为自己的**自定义widget**。

# 效果图：
<center>
<img src="https://github.com/laoou002/LOResoures/blob/main/IMG_2371.GIF" width="200" height="433">	
</center>


# 正文
### 1、重写系统的BottomNavigationBarItem
> lo_bottom_navigation_bar_item.dart, 此处新增了两个属性`animation`和`index`；


### 2、重写系统的BottomNavigationBar
> lo_bottom_navigation_bar.dart, 主要改动了`InkResponse`中的`child`，改变结构，并添加动画；


### 3、lo_home_tab_bar.dart文件，包含了动画创建和控制

```java
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
```


> 希望能帮到各位，并给各位提供各种修改flutter原生组件的灵感。

