import 'package:flutter/material.dart';
import 'package:my_tie/widgets/bottom_navigation/new_fly_start.dart';

import 'bottom_nav_page_base.dart';

class NewFlyStartPage extends BottomNavPageBase {
  static const _title = 'New Tie Fly';
  static const route = 'new_fly_start';

  get title => _title;

  @override
  Widget build(BuildContext context) {
    return NewFlyStart();
  }
}
