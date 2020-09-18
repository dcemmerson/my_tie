import 'package:flutter/material.dart';
import 'package:my_tie/pages/bottom_navigation_based_pages/new_fly_start_page.dart';
import 'package:my_tie/routes/routes.dart';

class NewFlyNavigator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Navigator(
      initialRoute: NewFlyStartPage.route,
      onGenerateRoute: (RouteSettings settings) {
        return MaterialPageRoute(
            builder: Routes.routes[settings.name], settings: settings);
      },
    );
  }
}
