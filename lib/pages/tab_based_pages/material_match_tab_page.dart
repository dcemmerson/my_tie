import 'package:flutter/material.dart';
import 'package:my_tie/pages/bottom_navigation_based_pages/home_page.dart';
import 'package:my_tie/pages/tab_based_pages/tab_page.dart';

class MaterialMatchTabPage extends TabPage {
  static const _name = 'By Materials';
  static final _widget = HomePage();

  String get name => _name;
  Widget get widget => _widget;
}
