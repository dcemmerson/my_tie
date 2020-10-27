/// filename: fly_form_routes.dart
/// description: FlyExhibitRoutes is a static class which contains routes specific
///   to the user swiping between the fly exhibit types (newest, vs materials,
///   vs favorites). All routes in this file require user
///   to be logged in to access, which is implemented using RouteGuard class.

import 'package:flutter/material.dart';
import 'package:my_tie/models/fly_exhibits/fly_exhibit.dart';

import 'package:my_tie/pages/base/page_base_stateless/page_base.dart';
import 'package:my_tie/pages/base/page_base_stateless/page_container.dart';
import 'package:my_tie/pages/route_based_pages/fly_exhibit_pages/fly_exhibit_detail_page.dart';
import 'package:my_tie/routes/route_guard.dart';

class FlyExhibitRoutes {
  static final routes = {
    FlyExhibitDetailPage.route: (context) => RouteGuard(
          child: PageContainer(pageType: PageType.FlyExhibitDetailPage),
        ),
  };

  static Future flyExhibitDetail(BuildContext context, FlyExhibit flyExhibit) =>
      Navigator.pushNamed(context, FlyExhibitDetailPage.route,
          arguments: flyExhibit);
}
