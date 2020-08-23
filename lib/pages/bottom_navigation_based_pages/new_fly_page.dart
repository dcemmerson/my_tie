import 'package:flutter/material.dart';
import 'package:my_tie/pages/bottom_navigation_based_pages/bottom_nav_page_base.dart';
import 'package:my_tie/widgets/bottom_navigation/new_fly.dart';

class NewFlyPage extends BottomNavPageBase {
  static const _title = 'New Tie Fly';

  @override
  get title => _title;

  @override
  Widget build(BuildContext context) {
    return NewFly();
  }
}
