import 'package:flutter/material.dart';
import 'package:my_tie/models/new_fly/fly_attribute.dart';
import 'package:my_tie/styles/styles.dart';

class FlyExhibitTitle extends StatelessWidget {
  final String title;
  final FlyAttribute difficultyAttribute;
  final bool centered;

  FlyExhibitTitle(
      {this.title, this.centered = false, this.difficultyAttribute});

  @override
  Widget build(BuildContext context) {
    return
        // Flexible(
        //   child:
        Container(
      padding: EdgeInsets.all(AppPadding.p2),
      alignment: centered ? Alignment.topCenter : Alignment.topLeft,
      child: Row(
          // runAlignment: WrapAlignment.spaceBetween,
          // alignment: Alignment.,
          children: [
            Expanded(
              child: Container(
                alignment: Alignment.center,
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.headline6,
                  //  TextStyle(
                  //     fontSize: AppFonts.h3, color: Theme.of(context).primaryHeaderColor),
                ),
              ),
            ),
            if (difficultyAttribute != null)
              Container(
                padding:
                    EdgeInsets.fromLTRB(AppPadding.p2, 0, AppPadding.p2, 0),
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey[900],
                      blurRadius: 3,
                      offset: Offset(0, 3),
                    )
                  ],

                  color: difficultyAttribute.color,
                  borderRadius: BorderRadius.all(Radius.circular(3)),
                  // border: Border.all(color: Color('0xffffff'))
                ),
                // color: attr.color,
                child: Text(
                  difficultyAttribute.value,
                  style: TextStyle(
                      fontSize: AppFonts.h6,
                      color: Theme.of(context).colorScheme.onPrimary),
                ),
              ),
          ]),
      // ),
    );
  }
}
