import 'package:flutter/material.dart';
import 'package:my_tie/bloc/state/my_tie_state.dart';
import 'package:my_tie/models/fly_exhibits/fly_exhibit.dart';
import 'package:my_tie/pages/tab_based_pages/tab_page.dart';
import 'package:my_tie/styles/styles.dart';

class FavoriteFly extends StatelessWidget {
  final FlyExhibit flyExhibit;
  final bool detailMode;
  final bool centered;

  FavoriteFly(
      {@required this.flyExhibit,
      this.detailMode = false,
      this.centered = true});

  void _handleFavorited(BuildContext context) {
    switch (flyExhibit.flyExhibitType) {
      case FlyExhibitType.Newest:
        MyTieStateContainer.of(context)
            .blocProvider
            .newestFlyExhibitBloc
            .favoritedFlySink
            ?.add(flyExhibit);
        break;
      case FlyExhibitType.MaterialMatch:
        MyTieStateContainer.of(context)
            .blocProvider
            .byMaterialsFlyExhibitBloc
            .favoritedFlySink
            ?.add(flyExhibit);
        break;
      case FlyExhibitType.Favorites:
        // If user is currently viewing the fly details modal route and selects
        // the unfavorite button, we need to pop the current route, as this
        // currently viewed page no longer exists in the user's favorite flies.
        if (flyExhibit.isFavorited && detailMode) {
          Navigator.of(context).pop();
        }
        MyTieStateContainer.of(context)
            .blocProvider
            .favoritedFlyExhibitBloc
            .favoritedFlySink
            ?.add(flyExhibit);
        break;
      default:
        throw Exception('UNIMPLEMENTED: detail');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: centered ? Alignment.topCenter : Alignment.topLeft,
      padding: EdgeInsets.fromLTRB(AppPadding.p2, 0, AppPadding.p2, 0),
      child: InkWell(
          onTap: () => _handleFavorited(context),
          child: flyExhibit.isFavorited
              ? Icon(Icons.favorite, color: Colors.red)
              : Icon(Icons.favorite_outline)),
    );
  }
}
