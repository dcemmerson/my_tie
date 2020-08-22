import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  static const route = '/';
  static const title = 'home';

  final Widget child;

  HomePage({@required this.child});

  @override
  Widget build(BuildContext context) {
    return child;
  }
}
