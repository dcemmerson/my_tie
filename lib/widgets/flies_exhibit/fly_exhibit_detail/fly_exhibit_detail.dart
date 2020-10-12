import 'package:flutter/material.dart';
import 'package:my_tie/bloc/state/my_tie_state.dart';
import 'package:my_tie/bloc/user_bloc.dart';
import 'package:my_tie/models/bloc_transfer_related/user_profile_fly_material_add_or_delete.dart';
import 'package:my_tie/models/fly_exhibits/fly_exhibit.dart';
import 'package:my_tie/models/new_fly/fly_materials.dart';
import 'package:my_tie/models/user_profile/user_profile.dart';
import 'package:my_tie/styles/dimensions.dart';
import 'package:my_tie/styles/styles.dart';
import 'package:my_tie/styles/string_format.dart';
import 'package:my_tie/widgets/flies_exhibit/fly_exhibit_detail_stream_builder.dart';

import 'package:my_tie/widgets/flies_exhibit/fly_exhibit_overview/fly_exhibit_attributes.dart';
import 'package:my_tie/widgets/flies_exhibit/fly_exhibit_overview/fly_exhibit_description.dart';
import 'package:my_tie/widgets/flies_exhibit/fly_exhibit_overview/fly_exhibit_title.dart';

import 'fly_carousel.dart';

class FlyExhibitDetail extends StatelessWidget {
  BuildContext context;
  Widget _materialsHeader;

  void _updateMaterialsOnHand(UserProfile userProfile, FlyMaterial flyMaterial,
      bool hasMaterialOnHand) {
    final UserBloc userBloc =
        MyTieStateContainer.of(context).blocProvider.userBloc;
    final addOrDeleteMaterial = UserProfileFlyMaterialAddOrDelete(
        flyMaterial: flyMaterial, userProfile: userProfile);
    if (hasMaterialOnHand) {
      userBloc.addUserFlyMaterialSink.add(addOrDeleteMaterial);
    } else {
      userBloc.deleteUserFlyMaterialSink.add(addOrDeleteMaterial);
    }
  }

  Widget _buildSingleView(FlyExhibit flyExhibit, BuildContext context,
      double width, double height) {
    return Column(children: [
      _buildExhibitAttributeInfo(flyExhibit),
      SizedBox(
        height: height / 3,
        child: FlyCarousel(flyExhibit.fly.topLevelImageUris),
      ),
    ]);
  }

  Widget _buildSideBySideView(
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
        title: flyExhibit.fly.flyName,
        materialsFraction: flyExhibit.materialsFraction,
        centered: true,
      ),
      // SizedBox(height: 10),
      FlyExhibitAttributes(flyExhibit.fly.attributes),
      FlyExhibitDescription(flyExhibit.fly.flyDescription),
    ]);
  }

  Widget _buildExhibitMaterialInfo(FlyExhibit flyExhibit) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _materialsHeader,
        ...flyExhibit.fly.materialList.map((flyMaterial) {
          bool hasMaterialOnHand = flyExhibit.userProfile.contains(
              name: flyMaterial.name, properties: flyMaterial.properties);
          return Container(
            padding: EdgeInsets.fromLTRB(
                AppPadding.p4, AppPadding.p4, 0, AppPadding.p4),
            child: Row(
              children: [
                Container(
                  padding:
                      EdgeInsets.fromLTRB(AppPadding.p4, 0, AppPadding.p6, 0),
                  child: Icon(flyMaterial.icon, color: flyMaterial.color),
                ),
                Expanded(
                  child: Wrap(alignment: WrapAlignment.spaceBetween, children: [
                    Text(flyMaterial.value + flyMaterial.name.toSingular()),
                  ]),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(0, 0, AppPadding.p2, 0),
                  child: InkWell(
                    onTap: () => _updateMaterialsOnHand(flyExhibit.userProfile,
                        flyMaterial, !hasMaterialOnHand),
                    child: hasMaterialOnHand
                        ? Stack(
                            children: [
                              Icon(
                                Icons.check_box_outlined,
                                color: Colors.orange,
                              ),
                              Icon(Icons.check_box_outline_blank)
                            ],
                          )
                        : Icon(Icons.check_box_outline_blank_outlined),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ],
    );
  }

  void _setHeaderLabels(BuildContext context) {
    _materialsHeader = Container(
      // alignment: Alignment.centerLeft,
      padding: EdgeInsets.all(AppPadding.p2),
      child: Opacity(
        opacity: 0.9,
        child: Text(
          'Materials',
          style: TextStyle(
            fontSize: AppFonts.h3,
            color: Theme.of(context).colorScheme.secondaryVariant,
            decoration: TextDecoration.underline,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    this.context = context;
    _setHeaderLabels(context);

    // Only use this FlyExhibit passed in to reference docId. Use
    // FlyExhibitDetailStreamBuilder to actually obtain FlyExhibit -
    // this ensures if user marks "I have this material", the UI will
    // update itself.
    FlyExhibit flyEx = ModalRoute.of(context).settings.arguments;
    return FlyExhibitDetailStreamBuilder(
      docId: flyEx.fly.docId,
      builder: (flyExhibit) => SingleChildScrollView(
        child: LayoutBuilder(builder: (context, constraints) {
          final screenHeight = MediaQuery.of(context).size.height;
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
                        ? _buildSideBySideView(
                            flyExhibit, constraints.maxWidth, screenHeight)
                        : _buildSingleView(flyExhibit, context,
                            constraints.maxWidth, screenHeight)
                  ],
                ),
              ),
            ),
            Card(
              elevation: 10,
              color: Theme.of(context).colorScheme.surface,
              margin:
                  const EdgeInsets.fromLTRB(0, AppPadding.p4, 0, AppPadding.p4),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                    0, AppPadding.p4, 0, AppPadding.p2),
                child: _buildExhibitMaterialInfo(flyExhibit),
              ),
            ),
          ]);
        }),
      ),
    );
  }
}
