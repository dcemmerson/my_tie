import 'package:flutter/material.dart';

class HeroDialogPartialPage extends StatelessWidget {
  static const route = 'hero_dialog_route';

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AlertDialog(
        title: Text('You are my hero.'),
        content: Container(
          child: Hero(
            tag: 'developer-hero',
            child: Container(
              height: 200.0,
              width: 200.0,
              child: FlutterLogo(),
            ),
          ),
        ),
      ),
    );
  }
}
