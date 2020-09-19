import 'package:flutter/material.dart';

import 'package:my_tie/pages/base/page_base_stateful/page_home.dart';
import 'package:my_tie/pages/base/page_base_stateless/page_base.dart';
import 'package:my_tie/pages/base/page_base_stateless/page_container.dart';
import 'package:my_tie/pages/base/page_base_stateless/subpage_base.dart';
import 'package:my_tie/pages/base/page_base_stateless/subpage_container.dart';
import 'package:my_tie/pages/bottom_navigation_based_pages/new_fly_start_page.dart';

import 'package:my_tie/pages/route_based_pages/account_page.dart';
import 'package:my_tie/pages/route_based_pages/home_page.dart';
import 'package:my_tie/pages/route_based_pages/waste_detail_page.dart';
import 'package:my_tie/routes/route_guard.dart';

import 'fly_form_routes.dart';
import 'modal_routes.dart';

class Routes {
  static final routes = {
    HomePage.route: (context) => RouteGuard(child: PageHome()),
    AccountPage.route: (context) =>
        RouteGuard(child: PageContainer(pageType: PageType.AccountPage)),
    WasteDetailPage.route: (context) =>
        RouteGuard(child: PageContainer(pageType: PageType.WasteDetailPage)),
    NewFlyStartPage.route: (context) => RouteGuard(
        child: SubPageContainer(subPageType: SubPageType.NewFlyStartPage)),
    ...FlyFormRoutes.routes,
    // ...ModalRoutes.routes
  };

  static Future accountPage(BuildContext context) =>
      Navigator.pushNamed(context, AccountPage.route);
}
