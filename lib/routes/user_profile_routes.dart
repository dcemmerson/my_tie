/// filename: fly_form_routes.dart
/// description: FlyFormRoutes is a static class which contains routes specific
///   to the user filling out the new fly form, as well as editting the fly form
///   template in the db. FlyFormRoutes must be imported in Routes.dart to
///   register routes when app launches. All routes in this file require user
///   to be logged in to access, which is implemented using RouteGuard class.

import 'package:flutter/material.dart';
import 'package:my_tie/models/arguments/routes_based/edit_user_material_page_transfer.dart';
import 'package:my_tie/pages/base/page_base_stateless/page_base.dart';
import 'package:my_tie/pages/base/page_base_stateless/page_container.dart';
import 'package:my_tie/pages/route_based_pages/user_profile_pages/user_profile_edit_page.dart';
import 'package:my_tie/routes/route_guard.dart';

class UserProfileRoutes {
  static final routes = {
    UserProfileEditPage.route: (context) => RouteGuard(
        child: PageContainer(pageType: PageType.UserProfileEditPage)),
  };

  static Future userProfileEditPage(BuildContext context,
          EditUserMaterialPageTransfer editUserMaterialPageTransfer) =>
      Navigator.pushNamed(context, UserProfileEditPage.route,
          arguments: editUserMaterialPageTransfer);
}
