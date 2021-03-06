import 'package:flutter/material.dart';
import 'package:my_tie/pages/base/page_base_stateful/page_main_base.dart';
import 'package:my_tie/pages/base/page_base_stateless/page_base.dart';
import 'package:my_tie/pages/base/page_base_stateless/page_container.dart';
import 'package:my_tie/pages/bottom_navigation_based_pages/home_page.dart';
import 'package:my_tie/pages/route_based_pages/fly_search_pages/fly_search_page.dart';
import 'package:my_tie/pages/tab_based_pages/tabs.dart';
import 'package:my_tie/routes/route_guard.dart';

import 'fly_exhibit_routes.dart';
import 'fly_form_routes.dart';
import 'user_profile_routes.dart';

class Routes {
  static final routes = {
    '/': (context) => RouteGuard(child: PageMainBase()),

    HomePage.route: (context) => RouteGuard(
          child:
              PageContainer(pageType: PageType.HomePage, tabPages: Tabs.pages),
        ),
    FlySearchPage.route: (context) =>
        RouteGuard(child: PageContainer(pageType: PageType.FlySearchPage)),
    ...FlyExhibitRoutes.routes,
    ...FlyFormRoutes.routes,
    ...UserProfileRoutes.routes,
    // ...ModalRoutes.routes
  };

  static Future flySearchPage(context) =>
      Navigator.pushNamed(context, FlySearchPage.route);
}
