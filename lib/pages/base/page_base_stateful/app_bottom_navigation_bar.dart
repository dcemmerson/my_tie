/// filename: app_bottom_navigation_bar.dart
/// last modified: 08/30/2020
/// description: Reusabled widget for bottom app bar navigation. This widget
///   does not maintain state of bottom app bar, and that state logic must be
///   implemented in the containing widget.

import 'package:flutter/material.dart';
import 'package:my_tie/pages/base/page_base_stateful/page_main_base.dart';

typedef void SetBottomNavPage(int index);

class AppBottomNavigationBar extends StatelessWidget {
  final SetBottomNavPage setBottomNavPage;
  final int selectedBottomAppBarIndex;
  final List<BottomNavPage> bottomNavPages;

  AppBottomNavigationBar({
    @required this.setBottomNavPage,
    @required this.selectedBottomAppBarIndex,
    @required this.bottomNavPages,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: bottomNavPages
          .map((p) => BottomNavigationBarItem(
                title: Text(p.page.title),
                icon: p.icon,
              ))
          .toList(),
      selectedItemColor: Colors.blueAccent,
      currentIndex: selectedBottomAppBarIndex,
      onTap: setBottomNavPage,
    );
  }
}
