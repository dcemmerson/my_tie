import 'package:flutter/material.dart';
import 'package:my_tie/widgets/bottom_navigation/profile.dart';

class AccountPage extends StatelessWidget {
  static const route = '/account';
  static const title = 'Account';

  @override
  Widget build(BuildContext context) {
    return Profile();
  }
}
