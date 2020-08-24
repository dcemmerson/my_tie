import 'package:flutter/material.dart';
import 'package:my_tie/bloc/my_tie_state.dart';
import 'package:my_tie/pages/base/page_base_stateful/app_bottom_navigation_bar.dart';
import 'package:my_tie/pages/bottom_navigation_based_pages/account_page.dart';
import 'package:my_tie/pages/bottom_navigation_based_pages/bottom_nav_page_base.dart';
import 'package:my_tie/pages/bottom_navigation_based_pages/home_page.dart';
import 'package:my_tie/pages/bottom_navigation_based_pages/new_fly_page.dart';
import 'package:my_tie/routes/routes.dart';
import 'package:my_tie/styles/theme_manager.dart';
import 'package:my_tie/widgets/drawer/settings_drawer.dart';
import 'package:my_tie/widgets/drawer/settings_drawer_icon.dart';

class BottomNavPage {
  final BottomNavPageBase page;
  final Icon icon;

  BottomNavPage({this.page, this.icon});
}

class PageHome extends StatefulWidget {
  final _pages = [
    BottomNavPage(
      page: HomePage(),
      icon: Icon(Icons.home),
    ),
    BottomNavPage(
      page: NewFlyPage(),
      icon: Icon(Icons.add_box),
    ),
    BottomNavPage(
      page: AccountPage(),
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
    _pageController = PageController(initialPage: 1);
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
          curve: Curves.linear, duration: Duration(milliseconds: 100));
    }
    setState(() {
      _selectedPageIndex = index;
    });
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
