import 'package:flutter/material.dart';
import 'package:my_tie/bloc/my_tie_state.dart';
import 'package:my_tie/routes/routes.dart';
import 'package:my_tie/styles/theme_manager.dart';
import 'package:my_tie/widgets/drawer/settings_drawer.dart';
import 'package:my_tie/widgets/drawer/settings_drawer_icon.dart';

enum PageType {
  HomePage,
  AuthenticationPage,
  WastePage,
  WasteDetailPage,
  WastePostPage,
  AccountPage,
}

abstract class PageBase extends StatelessWidget {
  ThemeManager themeManager;

  PageType get pageType;

  String get pageTitle;
  Widget get body;

  PageBase({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    themeManager =
        ThemeManager(darkMode: MyTieStateContainer.of(context).isDarkMode);
    if (pageType == PageType.WastePage) {
      return Theme(
        data: themeManager.themeData,
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            elevation: 0.0,
            title: Text(pageTitle),
            textTheme: Theme.of(context).primaryTextTheme,
            actions: [
              SettingsDrawerIcon(),
            ],
          ),
          endDrawer: SettingsDrawer(),
          body: body,
          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
          floatingActionButton: Semantics(
            button: true,
            enabled: true,
            label: 'New Waste Post',
            hint: 'Add new waste post',
            child: FloatingActionButton(
              key: Key('addWastePost'),
              onPressed: () => Routes.addWastedPost(context),
              child: Icon(Icons.add_a_photo),
            ),
          ),
        ),
      );
    } else {
      return Theme(
        data: themeManager.themeData,
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            elevation: 0.0,
            title: Text(pageTitle),
            textTheme: Theme.of(context).primaryTextTheme,
            actions: [
              SettingsDrawerIcon(),
            ],
          ),
          endDrawer: SettingsDrawer(),
          body: body,
        ),
      );
    }
  }
}
