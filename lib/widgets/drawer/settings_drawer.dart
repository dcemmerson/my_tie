import 'package:flutter/material.dart';
import 'package:my_tie/styles/styles.dart';
import 'package:my_tie/widgets/drawer/account_dropdown.dart';
// import 'package:my_tie/widgets/drawer/switches/all_users_entries_switch.dart';
import 'package:my_tie/widgets/drawer/switches/compact_fly_list_switch.dart';
import 'package:my_tie/widgets/drawer/switches/theme_switch.dart';

class SettingsDrawer extends StatelessWidget {
  final Key drawerKey = GlobalKey();

  DrawerHeader drawerHeader(BuildContext context) {
    return DrawerHeader(
      decoration: BoxDecoration(color: Theme.of(context).primaryColor),
      child: Column(
        children: [
          Container(
            alignment: Alignment.topLeft,
            child: Row(children: [
              Text('Settings',
                  style: TextStyle(
                      fontSize: AppFonts.h3,
                      color: Theme.of(context).primaryColorLight))
            ]),
          ),
          Expanded(
            child: LoginButton(),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
        key: drawerKey,
        child: Column(
          children: [
            drawerHeader(context),
            Padding(
              padding: EdgeInsets.fromLTRB(
                  AppPadding.p7, AppPadding.p4, AppPadding.p7, AppPadding.p2),
              child: ThemeSwitch(),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(
                  AppPadding.p7, AppPadding.p2, AppPadding.p7, AppPadding.p4),
              child: CompactFlyListSwitch(),
            ),
          ],
        ));
  }
}
