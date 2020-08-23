import 'package:flutter/material.dart';

import 'bottom_nav_page_base.dart';

class AccountPage extends BottomNavPageBase {
  static const _title = 'Account';

  get title => _title;

  @override
  Widget build(BuildContext context) {
    return Container(child: Text('account'));
  }
}
