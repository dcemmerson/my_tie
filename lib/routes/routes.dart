import 'package:flutter/material.dart';

import 'package:my_tie/models/wasted_item.dart';
import 'package:my_tie/pages/base/navigation_base/page_home.dart';
import 'package:my_tie/pages/base/route_base/page_base.dart';
import 'package:my_tie/pages/base/route_base/page_container.dart';
import 'package:my_tie/pages/route_based_pages/account_page.dart';
import 'package:my_tie/pages/route_based_pages/home_page.dart';
import 'package:my_tie/pages/route_based_pages/waste_detail_page.dart';
import 'package:my_tie/pages/route_based_pages/waste_list_page.dart';
import 'package:my_tie/pages/route_based_pages/waste_post_page.dart';
import 'package:my_tie/routes/route_guard.dart';

class Routes {
  static final routes = {
    HomePage.route: (context) {
      print('home route');
      return RouteGuard(child: PageHome());
    },
    AccountPage.route: (context) =>
        RouteGuard(child: PageContainer(pageType: PageType.AccountPage)),
    WasteListPage.route: (context) =>
        RouteGuard(child: PageContainer(pageType: PageType.WastePage)),
    WasteDetailPage.route: (context) =>
        RouteGuard(child: PageContainer(pageType: PageType.WasteDetailPage)),
    WastePostPage.route: (context) =>
        RouteGuard(child: PageContainer(pageType: PageType.WastePostPage)),
  };

  static Future wastePage(BuildContext context) {
    return Navigator.pushNamed(context, WasteListPage.route);
  }

  static Future wasteDetailPage(BuildContext context,
      {@required WastedItem item}) {
    return Navigator.pushNamed(context, WasteDetailPage.route, arguments: item);
  }

  static Future addWastedPost(BuildContext context) {
    return Navigator.pushNamed(context, WastePostPage.route);
  }

  static Future accountPage(BuildContext context) {
    return Navigator.pushNamed(context, AccountPage.route);
  }
}
