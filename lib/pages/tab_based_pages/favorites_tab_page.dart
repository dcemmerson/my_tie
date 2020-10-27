import 'package:flutter/material.dart';
import 'package:my_tie/pages/tab_based_pages/tab_page.dart';
import 'package:my_tie/widgets/flies_exhibit/flies_exhibit_entry.dart';

class FavoritesTabPage extends TabPage {
  static const _name = 'Favorites';
  static final _widget =
      FliesExhibitEntry(flyExhibitType: FlyExhibitType.Favorites);

  String get name => _name;
  Widget get widget => _widget;
}
