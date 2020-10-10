import 'package:flutter/material.dart';
import 'package:my_tie/styles/styles.dart';

class FlyExhibitDescription extends StatelessWidget {
  final String description;

  FlyExhibitDescription(this.description);

  @override
  Widget build(BuildContext context) {
    return
        // Flexible(
        //   child:
        Container(
      padding: EdgeInsets.all(AppPadding.p3),
      // alignment: centered ? Alignment.topCenter : Alignment.topLeft,
      child: Text(
        description,
        style: TextStyle(fontSize: AppFonts.h6),
      ),
      // ),
    );
  }
}
