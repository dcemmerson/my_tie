/// filename: user_profile_routes.dart
/// description: UserProfileRoutes is a static class which contains routes specific
///   to the user adding/editting materials on hand.

import 'package:flutter/material.dart';
import 'package:my_tie/models/arguments/routes_based/edit_user_material_page_transfer.dart';
import 'package:my_tie/pages/base/page_base_stateless/page_base.dart';
import 'package:my_tie/pages/base/page_base_stateless/page_container.dart';
import 'package:my_tie/pages/bottom_navigation_based_pages/profile_page.dart';
import 'package:my_tie/pages/route_based_pages/user_profile_pages/user_profile_edit_material_page.dart';
import 'package:my_tie/routes/route_guard.dart';

class UserProfileRoutes {
  static final routes = {
    ProfilePage.route: (context) => RouteGuard(
          child: PageContainer(pageType: PageType.ProfilePage),
        ),
    UserProfileEditMaterialPage.route: (context) => RouteGuard(
        child: PageContainer(pageType: PageType.UserProfileEditMaterialPage)),
  };

  static Future userProfileEditMaterialPage(BuildContext context,
          EditUserMaterialPageTransfer editUserMaterialPageTransfer) =>
      Navigator.pushNamed(context, UserProfileEditMaterialPage.route,
          arguments: editUserMaterialPageTransfer);
}
