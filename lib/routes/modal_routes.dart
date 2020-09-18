import 'package:flutter/material.dart';

import 'package:my_tie/pages/route_based_pages/hero_dialog_partial_page.dart';

import '../pages/base/navigators_nested/dialog_route.dart';

class ModalRoutes {
  static final routes = {
    HeroDialogPartialPage.route: () =>
        DialogRoute(builder: (BuildContext context) => HeroDialogPartialPage()),
  };

  static Future instructionStepModalPage(BuildContext context) =>
      Navigator.push(context, routes[HeroDialogPartialPage.route]());
}
