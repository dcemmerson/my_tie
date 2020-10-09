import 'package:flutter/material.dart';
import 'package:my_tie/models/new_fly/fly.dart';
import 'package:my_tie/styles/styles.dart';
import 'package:my_tie/widgets/flies_exhibit/fly_overview/fly_exhibit_attributes.dart';

import 'fly_exhibit_description.dart';
import 'fly_exhibit_title.dart';

class FlyOverviewExhibit extends StatelessWidget {
  static const double sideBySideCutoffWidth = 500;
  static const double defaultImageWidth = 750;

  final Fly fly;

  FlyOverviewExhibit(this.fly);

  Widget _imageWithLoadingBar(
      String uri, /*double width, double height,*/ BuildContext context) {
    return FadeInImage.assetNetwork(
      placeholder: 'assets/fly_placeholder.png',
      image: uri,
      imageErrorBuilder: (context, error, stackTrace) => Stack(children: [
        Text('Error loading image',
            style: TextStyle(color: Theme.of(context).errorColor)),
        Image.asset('assets/fly_placeholder.png',
            fit: BoxFit.fill, width: 1000),
      ]),
      // height: height,
      fit: BoxFit.fill,
      width: 1000,
      fadeOutDuration: const Duration(milliseconds: 400),
    );
  }

  Widget _buildSingleView(BuildContext context, double width, double height) {
    return Column(children: [
      _buildExhibitInfo(),
      SizedBox(
        height: height / 3,
        child: _imageWithLoadingBar(fly.topLevelImageUris[0], context),
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
              child: _imageWithLoadingBar(
                fly.topLevelImageUris[0],
                context,
              ), // subtract off padding
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
        title: fly.flyName,
        difficultyAttribute: fly.difficulty,
        centered: true,
      ),
      // SizedBox(height: 10),
      FlyExhibitAttributes(fly.attributes),
      FlyExhibitDescription(fly.flyDescription),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final screenHeight = MediaQuery.of(context).size.height;
      return Card(
        // elevation: 10,
        color: Theme.of(context).colorScheme.surface,
        margin: const EdgeInsets.fromLTRB(0, AppPadding.p4, 0, AppPadding.p4),
        child: Padding(
          padding:
              const EdgeInsets.fromLTRB(0, AppPadding.p4, 0, AppPadding.p2),
          child: Column(
            children: [
              constraints.maxWidth > sideBySideCutoffWidth
                  ? _buildSideBySideView(
                      context, constraints.maxWidth, screenHeight)
                  : _buildSingleView(
                      context, constraints.maxWidth, screenHeight)
            ],
          ),
        ),
      );
    });
  }
}
