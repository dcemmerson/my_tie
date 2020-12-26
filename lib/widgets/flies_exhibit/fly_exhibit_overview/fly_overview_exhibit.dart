import 'package:flutter/material.dart';
import 'package:my_tie/misc/placeholders.dart';
import 'package:my_tie/models/fly_exhibits/fly_exhibit.dart';
import 'package:my_tie/routes/fly_exhibit_routes.dart';
import 'package:my_tie/styles/dimensions.dart';
import 'package:my_tie/styles/styles.dart';

import 'fly_exhibit_attributes.dart';
import 'fly_exhibit_description.dart';
import 'fly_exhibit_title.dart';
import 'fly_image_with_loading_bar.dart';

class FlyOverviewExhibit extends StatelessWidget {
  static const double defaultImageWidth = 750;
  final bool isDisabled;
  final FlyExhibit flyExhibit;

  FlyOverviewExhibit(this.flyExhibit, {this.isDisabled = false});

  Widget _buildSingleView(BuildContext context, double width, double height) {
    return Column(children: [
      _buildExhibitInfo(),
      SizedBox(
        height: height / 3,
        child: FlyImageWithLoadingBar(flyExhibit.fly.topLevelImageUris[0]),
      ),
    ]);
  }

  Widget _buildSideBySideView(
      BuildContext context, double width, double height) {
    const edgePadding = AppPadding.p3;
    return SizedBox(
      width: width,
      height: height / 2,
      child: Row(
        children: [
          Flexible(
            flex: 6,
            child: Padding(
              padding: const EdgeInsets.all(edgePadding),
              child: FlyImageWithLoadingBar(
                flyExhibit.fly.topLevelImageUris[0],
              ),
            ),
          ),
          Flexible(
            flex: 4,
            child: _buildExhibitInfo(),
          ),
        ],
      ),
    );
  }

  Widget _buildExhibitInfo() {
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      FlyExhibitTitle(
        flyExhibit: flyExhibit,
        // title: flyExhibit.fly.flyName,
        // materialsFraction: flyExhibit.materialsFraction,
        centered: true,
      ),
      FlyExhibitAttributes(flyExhibit.fly.attributes),
      FlyExhibitDescription(flyExhibit.fly.flyDescription),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: isDisabled
          ? null
          : () => FlyExhibitRoutes.flyExhibitDetail(context, flyExhibit),
      child: LayoutBuilder(builder: (context, constraints) {
        final screenHeight = MediaQuery.of(context).size.height;
        return Card(
          elevation: 7,
          color: Theme.of(context).colorScheme.surface,
          margin: const EdgeInsets.fromLTRB(0, AppPadding.p4, 0, AppPadding.p4),
          child: Padding(
            padding:
                const EdgeInsets.fromLTRB(0, AppPadding.p4, 0, AppPadding.p2),
            child: Column(
              children: [
                constraints.maxWidth > Dimensions.sideBySideCutoffWidth
                    ? _buildSideBySideView(
                        context, constraints.maxWidth, screenHeight)
                    : _buildSingleView(
                        context, constraints.maxWidth, screenHeight)
              ],
            ),
          ),
        );
      }),
    );
  }
}
