import 'package:flutter/material.dart';
import 'package:my_tie/widgets/account.dart';

class AccountPage extends StatelessWidget {
  static const route = '/account';
  static const title = 'Account';

  @override
  Widget build(BuildContext context) {
    return Account();
  }
}
