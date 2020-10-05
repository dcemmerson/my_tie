import 'package:flutter/cupertino.dart';
import 'package:my_tie/pages/bottom_navigation_based_pages/home_page.dart';
import 'package:my_tie/pages/tab_based_pages/tab_page.dart';

class HomeTabPage extends TabPage {
  static const _name = 'Home';
  static final _widget = HomePage();

  String get name => _name;
  Widget get widget => _widget;
}
