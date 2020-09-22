/// filename: page_home.dart
/// last modified: 08/30/2020
/// description: Main page entry point base for app. This page contains the
///   bottom app bar, and logic for which swipeable page to display to user.

import 'package:flutter/material.dart';
import 'package:my_tie/bloc/state/my_tie_state.dart';
import 'package:my_tie/pages/base/navigators_nested/new_fly_navigator_entry.dart';
import 'package:my_tie/pages/base/page_base_stateful/app_bottom_navigation_bar.dart';
import 'package:my_tie/pages/bottom_navigation_based_pages/profile_page.dart';
import 'package:my_tie/pages/bottom_navigation_based_pages/bottom_nav_page_base.dart';
import 'package:my_tie/pages/bottom_navigation_based_pages/home_page.dart';
import 'package:my_tie/styles/theme_manager.dart';
import 'package:my_tie/widgets/drawer/settings_drawer.dart';
import 'package:my_tie/widgets/drawer/settings_drawer_icon.dart';

class BottomNavPage {
  final BottomNavPageBase page;
  final Icon icon;

  BottomNavPage({this.page, this.icon});
}

class PageHome extends StatefulWidget {
  final _pageTransitionDuration = Duration(milliseconds: 200);

  final _pages = [
    BottomNavPage(
      page: HomePage(),
      icon: Icon(Icons.home),
    ),
    BottomNavPage(
      page: NewFlyNavigatorEntry(),
      icon: Icon(Icons.add_box),
    ),
    BottomNavPage(
      page: ProfilePage(),
      icon: Icon(Icons.account_box),
    ),
  ];

  @override
  _PageHomeState createState() => _PageHomeState();
}

class _PageHomeState extends State<PageHome> {
  PageController _pageController;
  int _selectedPageIndex;

  ThemeManager themeManager;

  @override
  void initState() {
    super.initState();
    _selectedPageIndex = 0;
    _pageController = PageController(initialPage: 0);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    themeManager =
        ThemeManager(darkMode: MyTieStateContainer.of(context).isDarkMode);
  }

  void setSelectedPage(int index, {bool animate: true}) {
    if (animate) {
      _pageController.animateToPage(index,
          curve: Curves.linear, duration: widget._pageTransitionDuration);
    }
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: themeManager.themeData,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          elevation: 0.0,
          title: Text(widget._pages[_selectedPageIndex].page.title),
          textTheme: Theme.of(context).primaryTextTheme,
          actions: [
            SettingsDrawerIcon(),
          ],
        ),
        endDrawer: SettingsDrawer(),
        body: PageView(
          controller: _pageController,
          onPageChanged: (int index) => setSelectedPage(index, animate: false),
          children: widget._pages.map((p) => p.page).toList(),
        ),
        bottomNavigationBar: AppBottomNavigationBar(
          selectedBottomAppBarIndex: _selectedPageIndex,
          bottomNavPages: widget._pages,
          setBottomNavPage: setSelectedPage,
        ),
        // floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        // floatingActionButton: Semantics(
        //   button: true,
        //   enabled: true,
        //   label: 'New Waste Post',
        //   hint: 'Add new waste post',
        //   child: FloatingActionButton(
        //       key: Key('addWastePost'),
        //       onPressed: () => print('unimplemented'),
        //       /* Routes.addWastedPost(context), */
        //       child: Icon(Icons.add_a_photo)),
        // ),
      ),
    );
  }
}
