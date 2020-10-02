import 'package:flutter/material.dart';

import 'package:my_tie/pages/base/page_base_stateful/page_main.dart';
import 'package:my_tie/pages/base/page_base_stateless/page_base.dart';
import 'package:my_tie/pages/base/page_base_stateless/page_container.dart';
import 'package:my_tie/pages/base/page_base_stateless/subpage_base.dart';
import 'package:my_tie/pages/base/page_base_stateless/subpage_container.dart';
import 'package:my_tie/pages/bottom_navigation_based_pages/new_fly_start_page.dart';

import 'package:my_tie/pages/route_based_pages/user_profile_pages/profile_page.dart';
import 'package:my_tie/pages/route_based_pages/home_page.dart';
import 'package:my_tie/routes/route_guard.dart';

import 'fly_form_routes.dart';
import 'user_profile_routes.dart';

class Routes {
  static final routes = {
    HomePage.route: (context) => RouteGuard(child: PageMain()),
    // AccountPage.route: (context) =>
    //     RouteGuard(child: PageContainer(pageType: PageType.AccountPage)),
    NewFlyStartPage.route: (context) => RouteGuard(
        child: SubPageContainer(subPageType: SubPageType.NewFlyStartPage)),
    ...FlyFormRoutes.routes,
    ...UserProfileRoutes.routes,
    // ...ModalRoutes.routes
  };

  static Future accountPage(BuildContext context) =>
      Navigator.pushNamed(context, AccountPage.route);
}
