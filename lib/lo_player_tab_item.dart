import 'package:flutter/material.dart';

class PlayerTabItem extends FloatingActionButtonLocation {
  FloatingActionButtonLocation location;
  late double offsetX;    // X方向的偏移量
  late double offsetY;    // Y方向的偏移量
  PlayerTabItem(this.location, this.offsetX, this.offsetY);

  @override
  Offset getOffset(ScaffoldPrelayoutGeometry scaffoldGeometry) {
    Offset offset = location.getOffset(scaffoldGeometry);
    return Offset(offset.dx + offsetX, offset.dy + offsetY);
  }
}