import 'package:flutter/material.dart';
import 'package:my_tie/pages/bottom_navigation_based_pages/account.dart';
import 'package:my_tie/pages/bottom_navigation_based_pages/home.dart';
import 'package:my_tie/pages/bottom_navigation_based_pages/new_tie_fly.dart';

enum BottomNav { Home, NewTieFly, Account }

typedef void SetBody(Widget widget);

class AppBottomNavigationBar extends StatefulWidget {
  final SetBody setBody;
  final Home home = Home();
  final Account account = Account();
  final NewTieFly newTieFly = NewTieFly();

  AppBottomNavigationBar({@required this.setBody});

  @override
  _AppBottomNavigationBarState createState() => _AppBottomNavigationBarState();
}

class _AppBottomNavigationBarState extends State<AppBottomNavigationBar> {
  int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = 0;
  }

  void _onItemTap(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (BottomNav.values[index]) {
      case (BottomNav.Home):
        widget.setBody(widget.home);
        break;
      case (BottomNav.Account):
        widget.setBody(widget.account);
        break;
      case (BottomNav.NewTieFly):
        widget.setBody(widget.newTieFly);
        break;
      default:
        widget.setBody(widget.home);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: [
        BottomNavigationBarItem(
          title: Text('Home'),
          icon: Icon(Icons.home),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.add_box),
          title: Text('New Tie'),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.account_box),
          title: Text('Account'),
        ),
      ],
      selectedItemColor: Colors.blueAccent,
      currentIndex: _selectedIndex,
      onTap: _onItemTap,
    );
  }
}
