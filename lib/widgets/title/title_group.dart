import 'package:flutter/material.dart';
import 'package:my_tie/styles/styles.dart';

class TitleGroup extends StatelessWidget {
  final String title;
  final bool center;

  TitleGroup({this.title, this.center = false});
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: center ? Alignment.center : Alignment.centerLeft,
      padding: EdgeInsets.all(AppPadding.p2),
      child: Opacity(
        opacity: 0.9,
        child: Text(
          title,
          style: TextStyle(
            fontSize: AppFonts.h3,
            color: Theme.of(context).colorScheme.secondaryVariant,
            decoration: TextDecoration.underline,
          ),
        ),
      ),
    );
  }
}
