import 'package:flutter/material.dart';
import 'package:my_tie/widgets/authentication/login_button_standalone.dart';

class AuthenticationPage extends StatelessWidget {
  static const route = '/authentication';
  static const title = 'Sign In';

  @override
  Widget build(BuildContext context) {
    return LoginButtonStandalone();
  }
}
