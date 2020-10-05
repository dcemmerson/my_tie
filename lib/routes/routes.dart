import 'package:flutter/material.dart';
import 'package:my_tie/pages/base/page_base_stateful/page_main_base.dart';
import 'package:my_tie/pages/base/page_base_stateless/page_base.dart';
import 'package:my_tie/pages/base/page_base_stateless/page_container.dart';
import 'package:my_tie/pages/bottom_navigation_based_pages/home_page.dart';

import 'package:my_tie/pages/route_based_pages/user_profile_pages/profile_page.dart';
import 'package:my_tie/routes/route_guard.dart';

import 'fly_form_routes.dart';
import 'user_profile_routes.dart';

class Routes {
  static final routes = {
    '/': (context) => RouteGuard(child: PageMainBase()),
    HomePage.route: (context) =>
        RouteGuard(child: PageContainer(pageType: PageType.HomePage)),
    // AccountPage.route: (context) =>
    //     RouteGuard(child: PageContainer(pageType: PageType.AccountPage)),

    ...FlyFormRoutes.routes,
    ...UserProfileRoutes.routes,
    // ...ModalRoutes.routes
  };

  static Future accountPage(BuildContext context) =>
      Navigator.pushNamed(context, AccountPage.route);
}
