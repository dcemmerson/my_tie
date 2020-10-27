import 'package:flutter/material.dart';

enum FlyExhibitType {
  MaterialMatch,
  Newest,
  Favorites,
}

abstract class TabPage extends StatelessWidget {
  String get name;
  Widget get widget;

  @override
  Widget build(BuildContext context) {
    return widget;
  }
}
