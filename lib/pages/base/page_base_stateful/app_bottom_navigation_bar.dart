import 'package:flutter/material.dart';
import 'package:my_tie/pages/base/page_base_stateful/page_home.dart';

typedef void SetBottomNavPageType(BottomNavPageType bottomNavPage);

class AppBottomNavigationBar extends StatelessWidget {
  final SetBottomNavPageType setBottomNavPageType;
  final BottomNavPageType bottomNavPageType;

  AppBottomNavigationBar(
      {@required this.setBottomNavPageType, @required this.bottomNavPageType});

  void _onItemTap(int index) {
    switch (BottomNavPageType.values[index]) {
      case (BottomNavPageType.Home):
        setBottomNavPageType(BottomNavPageType.Home);
        break;
      case (BottomNavPageType.Account):
        setBottomNavPageType(BottomNavPageType.Account);
        break;
      case (BottomNavPageType.NewTieFly):
        setBottomNavPageType(BottomNavPageType.NewTieFly);
        break;
      default:
        throw Error();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: [
        BottomNavigationBarItem(
          title: Text('home'),
          icon: Icon(Icons.home),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.add_box),
          title: Text('New Fly'),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.account_box),
          title: Text('Account..'),
        ),
      ],
      selectedItemColor: Colors.blueAccent,
      currentIndex: bottomNavPageType.index,
      onTap: _onItemTap,
    );
  }
}
