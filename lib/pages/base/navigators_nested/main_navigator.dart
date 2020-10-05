import 'package:flutter/material.dart';
import 'package:my_tie/routes/routes.dart';

class MainNavigator extends StatelessWidget {
  final String initialRoute;

  MainNavigator({@required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return Navigator(
      initialRoute: initialRoute,
      onGenerateRoute: (RouteSettings settings) {
        return MaterialPageRoute(
            builder: Routes.routes[settings.name], settings: settings);
      },
    );
  }
}
