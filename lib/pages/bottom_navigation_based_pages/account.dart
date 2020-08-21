import 'package:flutter/material.dart';

import 'bottom_nav_page_base.dart';

class Account extends BottomNavPageBase {
  static const _title = 'Account';

  @override
  get title => _title;

  @override
  Widget build(BuildContext context) {
    return Container(child: Text('account'));
  }
}
