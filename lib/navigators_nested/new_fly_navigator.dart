import 'package:flutter/material.dart';
import 'package:my_tie/pages/bottom_navigation_based_pages/new_fly_start_page.dart';
import 'package:my_tie/routes/routes.dart';

class NewFlyNavigator extends StatelessWidget {
  static const title = 'Fly Attributes';

  NewFlyNavigator() {
    print('hellpppppoooo');
  }
  @override
  Widget build(BuildContext context) {
    return Navigator(
      initialRoute: NewFlyStartPage.route,
      onGenerateRoute: (RouteSettings settings) {
        print('hello nav');
        print(settings);
        return MaterialPageRoute(
            builder: Routes.routes[settings.name], settings: settings);
      },
    );
  }
}
