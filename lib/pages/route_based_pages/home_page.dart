import 'package:flutter/material.dart';
import 'package:my_tie/widgets/waste_item_detail.dart';

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
