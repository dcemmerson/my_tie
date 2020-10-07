import 'package:flutter/cupertino.dart';
import 'package:my_tie/pages/tab_based_pages/tab_page.dart';
import 'package:my_tie/widgets/flies_exhibit/newest_flies.dart';

class NewestTabPage extends TabPage {
  static const _name = 'Newest';
  static final _widget = NewestFlies();

  String get name => _name;
  Widget get widget => _widget;
}
