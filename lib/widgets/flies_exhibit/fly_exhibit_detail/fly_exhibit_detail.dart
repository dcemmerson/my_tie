import 'package:flutter/material.dart';
import 'package:my_tie/bloc/fly_exhibit_bloc/fly_exhibit_bloc.dart';
import 'package:my_tie/bloc/state/my_tie_state.dart';
import 'package:my_tie/models/fly_exhibits/fly_exhibit.dart';
import 'package:my_tie/pages/tab_based_pages/tab_page.dart';
import 'package:my_tie/styles/dimensions.dart';
import 'package:my_tie/styles/styles.dart';
import 'package:my_tie/styles/string_format.dart';
import 'package:my_tie/widgets/flies_exhibit/fly_exhibit_detail_stream_builder.dart';

import 'package:my_tie/widgets/flies_exhibit/fly_exhibit_overview/fly_exhibit_attributes.dart';
import 'package:my_tie/widgets/flies_exhibit/fly_exhibit_overview/fly_exhibit_description.dart';
import 'package:my_tie/widgets/flies_exhibit/fly_exhibit_overview/fly_exhibit_title.dart';

import 'fly_carousel.dart';
import 'fly_exhibit_detail_instructions.dart';
import 'fly_exhibit_detail_materials.dart';

class FlyExhibitDetail extends StatelessWidget {
  BuildContext context;
  Widget _materialsHeader;

  Widget _buildSingleAttributesView(FlyExhibit flyExhibit, BuildContext context,
      double width, double height) {
    return Column(children: [
      _buildExhibitAttributeInfo(flyExhibit),
      SizedBox(
        height: height / 3,
        child: FlyCarousel(flyExhibit.fly.topLevelImageUris),
      ),
    ]);
  }

  Widget _buildSideBySideAttributesView(
      FlyExhibit flyExhibit, double width, double height) {
    const edgePadding = AppPadding.p3;
    return Column(children: [
      SizedBox(
        width: width,
        height: height / 2,
        child: Row(
          children: [
            Flexible(
              flex: 6,
              child: Padding(
                padding: const EdgeInsets.all(edgePadding),
                child: FlyCarousel(flyExhibit.fly.topLevelImageUris),
              ),
            ),
            Flexible(
              flex: 4,
              child: _buildExhibitAttributeInfo(flyExhibit),
            ),
          ],
        ),
      ),
    ]);
  }

  Widget _buildExhibitAttributeInfo(FlyExhibit flyExhibit) {
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      FlyExhibitTitle(
        flyExhibit: flyExhibit,
        centered: true,
      ),
      // SizedBox(height: 10),
      FlyExhibitAttributes(flyExhibit.fly.attributes),
      FlyExhibitDescription(flyExhibit.fly.flyDescription),
    ]);
  }

  Widget _createHeaderLabel(BuildContext context, String text) {
    return Container(
      // alignment: Alignment.centerLeft,
      padding: EdgeInsets.all(AppPadding.p2),
      child: Opacity(
        opacity: 0.9,
        child: Text(
          text,
          style: TextStyle(
            fontSize: AppFonts.h3,
            color: Theme.of(context).colorScheme.secondaryVariant,
            decoration: TextDecoration.underline,
          ),
        ),
      ),
    );
  }

  FlyExhibitBloc switchBlocByPage(FlyExhibit flyExhibit, BuildContext context) {
    switch (flyExhibit.flyExhibitType) {
      case FlyExhibitType.MaterialMatch:
        return MyTieStateContainer.of(context)
            .blocProvider
            .byMaterialsFlyExhibitBloc;
      case FlyExhibitType.Newest:
        return MyTieStateContainer.of(context)
            .blocProvider
            .newestFlyExhibitBloc;
      case FlyExhibitType.Favorites:
      default:
        return MyTieStateContainer.of(context)
            .blocProvider
            .favoritedFlyExhibitBloc;
    }
  }

  @override
  Widget build(BuildContext context) {
    this.context = context;
    _materialsHeader = _createHeaderLabel(context, 'Materials');
    // _instructionsHeader = _createHeaderLabel(context, 'Instructions');

    // Only use this FlyExhibit passed in to reference (1) docId and
    // (2) the referring page type. Use
    // FlyExhibitDetailStreamBuilder to actually obtain FlyExhibit -
    // this ensures if user marks "I have this material", the UI will
    // update itself. Use referring page type so that FlyExhibitDetailStreamBuilder
    // can switch to subscribe to the correct stream (which ensures the
    // corresponding Bloc already has downloaded the correct fly from
    // Cloud Firestore).
    final FlyExhibit flyEx = ModalRoute.of(context).settings.arguments;
    final FlyExhibitBloc flyExhibitBloc = switchBlocByPage(flyEx, context);

    return FlyExhibitDetailStreamBuilder(
      docId: flyEx.fly.docId,
      flyExhibitBloc: flyExhibitBloc,
      builder: (flyExhibit) => SingleChildScrollView(
        child: LayoutBuilder(builder: (context, constraints) {
          final screenHeight = MediaQuery.of(context).size.height;
          print('\n\nFly exhibit = ');
          print(flyExhibit);

          return Column(children: [
            Card(
              elevation: 10,
              color: Theme.of(context).colorScheme.surface,
              margin:
                  const EdgeInsets.fromLTRB(0, AppPadding.p4, 0, AppPadding.p4),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                    0, AppPadding.p4, 0, AppPadding.p2),
                child: Column(
                  children: [
                    constraints.maxWidth > Dimensions.sideBySideCutoffWidth
                        ? _buildSideBySideAttributesView(
                            flyExhibit, constraints.maxWidth, screenHeight)
                        : _buildSingleAttributesView(flyExhibit, context,
                            constraints.maxWidth, screenHeight)
                  ],
                ),
              ),
            ),
            FlyExhibitDetailMaterials(flyExhibit: flyExhibit),
            FlyExhibitDetailInstructions(flyExhibit: flyExhibit),
          ]);
        }),
      ),
    );
  }
}
