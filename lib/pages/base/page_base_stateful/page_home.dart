import 'package:flutter/material.dart';
import 'package:my_tie/bloc/my_tie_state.dart';
import 'package:my_tie/pages/base/page_base_stateful/app_bottom_navigation_bar.dart';
import 'package:my_tie/pages/bottom_navigation_based_pages/account_page.dart';
import 'package:my_tie/pages/bottom_navigation_based_pages/home_page.dart';
import 'package:my_tie/pages/bottom_navigation_based_pages/new_fly_page.dart';
import 'package:my_tie/routes/routes.dart';
import 'package:my_tie/styles/theme_manager.dart';
import 'package:my_tie/widgets/drawer/settings_drawer.dart';
import 'package:my_tie/widgets/drawer/settings_drawer_icon.dart';

enum BottomNavPageType { Home, NewTieFly, Account }

class PageHome extends StatefulWidget {
  final _pages = [
    HomePage(),
    NewFlyPage(),
    AccountPage(),
  ];

  @override
  _PageHomeState createState() => _PageHomeState();
}

class _PageHomeState extends State<PageHome> {
  BottomNavPageType _bottomNavPageType;
  PageController _pageController;

  ThemeManager themeManager;

  @override
  void initState() {
    super.initState();
    _bottomNavPageType = BottomNavPageType.values[0];
    _pageController = PageController(initialPage: 1);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    themeManager =
        ThemeManager(darkMode: MyTieStateContainer.of(context).isDarkMode);
  }

  void setSelectedPage(BottomNavPageType bottomNavPageType,
      {bool animate: true}) {
    if (animate) {
      _pageController.animateToPage(bottomNavPageType.index,
          curve: Curves.linear, duration: Duration(milliseconds: 100));
    }
    setState(() => _bottomNavPageType = bottomNavPageType);
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: themeManager.themeData,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          elevation: 0.0,
          title: Text(widget._pages[_bottomNavPageType.index].title),
          textTheme: Theme.of(context).primaryTextTheme,
          actions: [
            SettingsDrawerIcon(),
          ],
        ),
        endDrawer: SettingsDrawer(),
        body: PageView(
          controller: _pageController,
          onPageChanged: (index) =>
              setSelectedPage(BottomNavPageType.values[index], animate: false),
          children: widget._pages,
        ),
        bottomNavigationBar: AppBottomNavigationBar(
          bottomNavPageType: _bottomNavPageType,
          setBottomNavPageType: setSelectedPage,
        ),
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
