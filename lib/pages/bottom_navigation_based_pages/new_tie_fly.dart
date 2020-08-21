import 'package:flutter/material.dart';
import 'package:my_tie/pages/bottom_navigation_based_pages/bottom_nav_page_base.dart';

class NewTieFly extends BottomNavPageBase {
  static const _title = 'New Tie Fly';

  @override
  get title => _title;

  @override
  Widget build(BuildContext context) {
    return Container(child: Text('new tie fly'));
  }
}
