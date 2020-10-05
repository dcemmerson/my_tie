import 'package:flutter/material.dart';

import 'bottom_nav_page_base.dart';

class HomePage extends BottomNavPageBase {
  static const _title = 'Home';
  static const route = 'home';

  @override
  get title => _title;

  @override
  Widget build(BuildContext context) {
    return Center(child: Text('home'));
  }
}
