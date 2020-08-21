import 'package:flutter/material.dart';
import 'package:my_tie/bloc/wasteagram_state.dart';
import 'package:my_tie/pages/base/home/app_bottom_navigation_bar.dart';
import 'package:my_tie/pages/bottom_navigation_based_pages/bottom_nav_page_base.dart';
import 'package:my_tie/routes/routes.dart';
import 'package:my_tie/styles/theme_manager.dart';
import 'package:my_tie/widgets/authentication/authenticate.dart';
import 'package:my_tie/widgets/drawer/settings_drawer.dart';
import 'package:my_tie/widgets/drawer/settings_drawer_icon.dart';

class PageHome extends StatefulWidget {
  @override
  _PageHomeState createState() => _PageHomeState();
}

class _PageHomeState extends State<PageHome> {
  ThemeManager themeManager;
  BottomNavPageBase _body;

  AppBottomNavigationBar _appBottomNavigationBar;

  @override
  void initState() {
    super.initState();
    _appBottomNavigationBar = AppBottomNavigationBar(setBody: setBody);
    _body = _appBottomNavigationBar.home;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    themeManager =
        ThemeManager(darkMode: WasteagramStateContainer.of(context).isDarkMode);
  }

  void setBody(Widget widget) => setState(() => _body = widget);

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: themeManager.themeData,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          elevation: 0.0,
          title: Text(_body.title),
          textTheme: Theme.of(context).primaryTextTheme,
          actions: [
            SettingsDrawerIcon(),
          ],
        ),
        endDrawer: SettingsDrawer(),
        body: Authenticate(child: _body),
        bottomNavigationBar: _appBottomNavigationBar,
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButton: Semantics(
          button: true,
          enabled: true,
          label: 'New Waste Post',
          hint: 'Add new waste post',
          child: FloatingActionButton(
              key: Key('addWastePost'),
              onPressed: () => Routes.addWastedPost(context),
              child: Icon(Icons.add_a_photo)),
        ),
      ),
    );
  }
}
