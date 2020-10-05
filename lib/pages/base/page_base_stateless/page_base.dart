import 'package:flutter/material.dart';
import 'package:my_tie/bloc/state/my_tie_state.dart';
import 'package:my_tie/styles/theme_manager.dart';
import 'package:my_tie/widgets/drawer/settings_drawer.dart';
import 'package:my_tie/widgets/drawer/settings_drawer_icon.dart';

enum PageType {
  HomePage,
  AuthenticationPage,
  AccountPage,
  // user profile related
  ProfilePage,
  UserProfileEditPage,
  // new fly related
  NewFlyStartPage,
  NewFlyAttributesPage,
  NewFlyMaterialsPage,
  NewFlyInstructionPage,
  NewFlyPublishPage,
  NewFlyPreviewPublishPage,
  AddNewAttributePage,
  AddNewPropertyPage,
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

    return Theme(
      data: themeManager.themeData,
      child: Scaffold(
        appBar: AppBar(toolbarHeight: 0),
        endDrawer: SettingsDrawer(),
        body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            SliverAppBar(
              snap: true,
              floating: true,
              centerTitle: true,
              elevation: 0.0,
              // floating: true,
              title: Text(pageTitle),
              textTheme: Theme.of(context).primaryTextTheme,
              actions: [
                SettingsDrawerIcon(),
              ],
            ),
          ],
          body: body,
        ),
      ),
    );
  }
}
