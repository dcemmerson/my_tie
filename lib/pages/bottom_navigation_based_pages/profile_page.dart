import 'package:flutter/material.dart';
import 'package:my_tie/widgets/profile_overview/profile_overview.dart';

import 'bottom_nav_page_base.dart';

class ProfilePage extends BottomNavPageBase {
  static const _title = 'Profile';

  get title => _title;

  @override
  Widget build(BuildContext context) {
    return Container(child: ProfileOverview());
  }
}
