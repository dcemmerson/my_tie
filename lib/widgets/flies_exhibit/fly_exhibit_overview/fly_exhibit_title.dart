import 'package:flutter/material.dart';
import 'package:my_tie/models/new_fly/fly_attribute.dart';
import 'package:my_tie/styles/styles.dart';

class FlyExhibitTitle extends StatelessWidget {
  final String title;
  // Number of required materials user has on hand, vs number of required
  // materials to tie the fly in this exhibit.
  final String materialsFraction;
  // final FlyAttribute difficultyAttribute;
  final bool centered;

  FlyExhibitTitle({this.title, this.centered = false, this.materialsFraction});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppPadding.p2),
      alignment: centered ? Alignment.topCenter : Alignment.topLeft,
      child: Row(children: [
        Expanded(
          child: Container(
            alignment: Alignment.center,
            child: Text(
              title,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.headline6,
            ),
          ),
        ),
        Container(child: Text(materialsFraction)),
        // if (difficultyAttribute != null)
        //   Container(
        //     padding: EdgeInsets.fromLTRB(AppPadding.p2, 0, AppPadding.p2, 0),
        //     decoration: BoxDecoration(
        //       boxShadow: [
        //         BoxShadow(
        //           color: Colors.grey[900],
        //           blurRadius: 3,
        //           offset: Offset(0, 3),
        //         )
        //       ],
        //       color: difficultyAttribute.color,
        //       borderRadius: BorderRadius.all(Radius.circular(3)),
        //     ),
        //     child: Text(
        //       difficultyAttribute.value,
        //       style: TextStyle(
        //           fontSize: AppFonts.h6,
        //           color: Theme.of(context).colorScheme.onPrimary),
        //     ),
        //   ),
      ]),
    );
  }
}
