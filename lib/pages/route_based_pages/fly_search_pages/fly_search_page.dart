import 'package:flutter/material.dart';
import 'package:my_tie/widgets/search_bar/fly_search.dart';

class FlySearchPage extends StatelessWidget {
  static const title = 'Fly Search';
  static const route = '/fly_search';

  @override
  Widget build(BuildContext context) {
    return Container(child: FlySearch());
  }
}
