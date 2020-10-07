import 'package:flutter/material.dart';
import 'package:my_tie/bloc/state/my_tie_state.dart';
import 'package:my_tie/pages/tab_based_pages/tab_page.dart';
import 'package:my_tie/styles/theme_manager.dart';
import 'package:my_tie/widgets/drawer/settings_drawer.dart';
import 'package:my_tie/widgets/drawer/settings_drawer_icon.dart';

enum PageType {
  HomePage,
  AuthenticationPage,
  AccountPage,
  // user profile related
  ProfilePage,
  UserProfileEditMaterialPage,
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
  final List<TabPage> tabPages;

  PageType get pageType;

  String get pageTitle;
  Widget get body;

  PageBase({Key key, this.tabPages}) : super(key: key);

  Widget _appBar(BuildContext context) {
    return NestedScrollView(
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
    );
  }

  Widget _tabbedAppBar(BuildContext context) {
    return DefaultTabController(
      length: tabPages.length,
      initialIndex: 0,
      child: NestedScrollView(
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
            pinned: true,
            bottom: TabBar(
                tabs: tabPages
                    .map((tabPage) => Tab(text: tabPage.name))
                    .toList()),
          ),
        ],
        body: TabBarView(
            children: tabPages.map((tabPage) => tabPage.widget).toList()),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    themeManager =
        ThemeManager(darkMode: MyTieStateContainer.of(context).isDarkMode);
    var body;
    if (tabPages != null) {
      body = _tabbedAppBar(context);
    } else {
      body = _appBar(context);
    }
    return Theme(
      data: themeManager.themeData,
      child: Scaffold(
        appBar: AppBar(toolbarHeight: 0),
        endDrawer: SettingsDrawer(),
        body: body,
      ),
    );
  }
}
