import 'package:flutter/material.dart';
import 'package:my_tie/models/fly_exhibits/fly_exhibit.dart';

class FlySearchResultPreview extends StatelessWidget {
  final FlyExhibit flyExhibit;

  FlySearchResultPreview(this.flyExhibit);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(flyExhibit.fly.flyName),
    );
  }
}
