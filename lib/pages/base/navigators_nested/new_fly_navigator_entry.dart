import 'package:flutter/material.dart';
import 'package:my_tie/bloc/state/fly_form_state.dart';
import 'package:my_tie/pages/base/navigators_nested/main_navigator.dart';
import 'package:my_tie/pages/bottom_navigation_based_pages/bottom_nav_page_base.dart';
import 'package:my_tie/pages/bottom_navigation_based_pages/new_fly_start_page.dart';

class NewFlyNavigatorEntry extends BottomNavPageBase {
  static const _title = 'New Tie Fly';
  // static const route = 'new_fly_start';

  @override
  get title => _title;

  @override
  Widget build(BuildContext context) {
    return FlyFormStateContainer(
        child: MainNavigator(
      initialRoute: NewFlyStartPage.route,
    ));
  }
}
