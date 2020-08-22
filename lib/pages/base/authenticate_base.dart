import 'package:flutter/material.dart';
import 'package:my_tie/bloc/wasteagram_state.dart';
import 'package:my_tie/pages/base/navigation_base/app_bottom_navigation_bar.dart';
import 'package:my_tie/pages/bottom_navigation_based_pages/bottom_nav_page_base.dart';
import 'package:my_tie/routes/routes.dart';
import 'package:my_tie/styles/theme_manager.dart';
import 'package:my_tie/widgets/drawer/settings_drawer.dart';
import 'package:my_tie/widgets/drawer/settings_drawer_icon.dart';

class AuthenticateBase extends StatelessWidget {
  final Widget child;

  AuthenticateBase({@required this.child});

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeManager(
              darkMode: WasteagramStateContainer.of(context).isDarkMode)
          .themeData,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          elevation: 0.0,
          title: Text('auth'),
          textTheme: Theme.of(context).primaryTextTheme,
          actions: [
            SettingsDrawerIcon(),
          ],
        ),
        endDrawer: SettingsDrawer(),
        body: child,
      ),
    );
  }
}
