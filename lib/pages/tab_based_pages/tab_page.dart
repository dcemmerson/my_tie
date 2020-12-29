import 'package:flutter/material.dart';

enum FlyExhibitType {
  MaterialMatch,
  Newest,
  Favorites,
}

extension FlyExhibitTypeExtension on FlyExhibitType {
  String get flyExhibitType {
    switch (this) {
      case FlyExhibitType.MaterialMatch:
        return 'material match';
      case FlyExhibitType.Newest:
        return 'newest';
      case FlyExhibitType.Favorites:
        return 'favorites';
    }
    return '';
  }
}

abstract class TabPage {
  String get name;
  Widget widget(ScrollController parentScrollController);

  final ScrollController scrollController = ScrollController();
}
