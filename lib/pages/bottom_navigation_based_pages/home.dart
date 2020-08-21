import 'package:flutter/material.dart';

import 'bottom_nav_page_base.dart';

class Home extends BottomNavPageBase {
  static const _title = 'Home';

  @override
  get title => _title;

  @override
  Widget build(BuildContext context) {
    return Container(child: Text('home'));
  }
}
