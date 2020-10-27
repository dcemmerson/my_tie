import 'package:flutter/material.dart';
import 'package:my_tie/pages/tab_based_pages/tab_page.dart';
import 'package:my_tie/widgets/flies_exhibit/flies_exhibit_entry.dart';

class MaterialMatchTabPage extends TabPage {
  static const _name = 'By Materials';
  static final _widget =
      FliesExhibitEntry(flyExhibitType: FlyExhibitType.MaterialMatch);

  String get name => _name;
  Widget get widget => _widget;
}
