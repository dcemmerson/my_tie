import 'dart:math';

import 'package:flutter/material.dart';
import 'package:my_tie/models/fly_exhibits/fly_exhibit.dart';
import 'package:my_tie/routes/fly_exhibit_routes.dart';
import 'package:my_tie/widgets/flies_exhibit/fly_exhibit_overview/fly_image_with_loading_bar.dart';

class FlySearchResultPreview extends StatelessWidget {
  final FlyExhibit flyExhibit;

  FlySearchResultPreview(this.flyExhibit);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        ListTile(
          onTap: () => FlyExhibitRoutes.flyExhibitDetail(context, flyExhibit),
          // leading: FavoriteFly(flyExhibit: flyExhibit),
          title: Text(flyExhibit.fly.flyName
              .substring(0, min(flyExhibit.fly.flyName.length, 25))),
          subtitle: Text(flyExhibit.fly.flyDescription
              .substring(0, min(flyExhibit.fly.flyDescription.length, 40))),
          trailing: Container(
            width: 100,
            child: FlyImageWithLoadingBar(flyExhibit.fly.topLevelImageUris[0]),
          ),
        )
      ]),
    );
  }
}
