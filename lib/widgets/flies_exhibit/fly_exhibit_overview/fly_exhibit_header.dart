import 'package:flutter/material.dart';
import 'package:my_tie/bloc/state/my_tie_state.dart';
import 'package:my_tie/models/fly_exhibits/fly_exhibit.dart';
import 'package:my_tie/styles/styles.dart';

import 'favorite_fly.dart';

class FlyExhibitHeader extends StatelessWidget {
  final FlyExhibit flyExhibit;
  final bool detailMode;
  // final String title;
  // Number of required materials user has on hand, vs number of required
  // materials to tie the fly in this exhibit.
  // final String materialsFraction;
  // final FlyAttribute difficultyAttribute;
  final bool centered;

  FlyExhibitHeader(
      {this.flyExhibit, this.centered = false, this.detailMode = false});

  @override
  Widget build(BuildContext context) {
    final compactMode = MyTieStateContainer.of(context).isCompactFlyListMode;
    if (compactMode) {
      return Container(
        padding: EdgeInsets.all(AppPadding.p2),
        alignment: centered ? Alignment.topCenter : Alignment.topLeft,
        child: Column(children: [
          Container(
            alignment: centered ? Alignment.topCenter : Alignment.topLeft,
            child: Text(
              flyExhibit.fly.flyName,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.headline6,
            ),
          ),
          Container(
              alignment: centered ? Alignment.topCenter : Alignment.topLeft,
              padding: EdgeInsets.fromLTRB(AppPadding.p2, 0, AppPadding.p2, 0),
              child: Text(flyExhibit.materialsFraction)),
          FavoriteFly(
            flyExhibit: flyExhibit,
            detailMode: detailMode,
            centered: centered,
          ),
        ]),
      );
    } else {
      return Container(
        padding: EdgeInsets.all(AppPadding.p2),
        alignment: centered ? Alignment.topCenter : Alignment.topLeft,
        child: Row(children: [
          Container(
              padding: EdgeInsets.fromLTRB(AppPadding.p2, 0, AppPadding.p2, 0),
              child: Text(flyExhibit.materialsFraction)),
          Expanded(
            child: Container(
              alignment: Alignment.center,
              child: Text(
                flyExhibit.fly.flyName,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.headline6,
              ),
            ),
          ),
          FavoriteFly(
            flyExhibit: flyExhibit,
            detailMode: detailMode,
          ),
        ]),
      );
    }
  }
}
