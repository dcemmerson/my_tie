import 'package:flutter/material.dart';

enum FlyExhibitType {
  MaterialMatch,
  Newest,
  Favorites,
}

abstract class TabPage {
  String get name;
  Widget widget(ScrollController parentScrollController);

  final ScrollController scrollController = ScrollController();

  // @override
  // Widget build(BuildContext context) {
  //   return widget;
  // }
}
