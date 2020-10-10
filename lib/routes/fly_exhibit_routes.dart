/// filename: fly_form_routes.dart
/// description: FlyFormRoutes is a static class which contains routes specific
///   to the user filling out the new fly form, as well as editting the fly form
///   template in the db. FlyFormRoutes must be imported in Routes.dart to
///   register routes when app launches. All routes in this file require user
///   to be logged in to access, which is implemented using RouteGuard class.

import 'package:flutter/material.dart';

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

  static Future flyExhibitDetail(context) =>
      Navigator.pushNamed(context, FlyExhibitDetailPage.route);
}
