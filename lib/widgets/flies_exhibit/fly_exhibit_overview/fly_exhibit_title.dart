import 'package:flutter/material.dart';
import 'package:my_tie/bloc/fly_exhibit_bloc/newest_fly_exhibit_bloc.dart';
import 'package:my_tie/bloc/state/my_tie_state.dart';
import 'package:my_tie/models/fly_exhibits/fly_exhibit.dart';
import 'package:my_tie/styles/styles.dart';

class FlyExhibitTitle extends StatelessWidget {
  final FlyExhibit flyExhibit;
  // final String title;
  // Number of required materials user has on hand, vs number of required
  // materials to tie the fly in this exhibit.
  // final String materialsFraction;
  // final FlyAttribute difficultyAttribute;
  final bool centered;

  FlyExhibitTitle({this.flyExhibit, this.centered = false});

  void _handleFavorited(BuildContext context) {
    MyTieStateContainer.of(context)
        .blocProvider
        .flyExhibitBloc
        .favoritedFlySink
        .add(flyExhibit);
    // if (flyExhibit.isFavorited)
    //   favoritedFlySink.add(FavoritedFlyRemoveEvent());
    // else
    //   favoritedFlySink.add(FavoritedFlyAddEvent());
  }

  @override
  Widget build(BuildContext context) {
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
        Container(
            padding: EdgeInsets.fromLTRB(AppPadding.p2, 0, AppPadding.p2, 0),
            child: InkWell(
                onTap: () => _handleFavorited(context),
                child: flyExhibit.isFavorited
                    ? Icon(Icons.favorite, color: Colors.red)
                    : Icon(Icons.favorite_outline))),
      ]),
    );
  }
}
