import 'package:flutter/material.dart';
import 'package:my_tie/bloc/state/my_tie_state.dart';
import 'package:my_tie/bloc/user_bloc.dart';
import 'package:my_tie/models/bloc_transfer_related/user_profile_fly_material_add_or_delete.dart';
import 'package:my_tie/models/fly_exhibits/fly_exhibit.dart';
import 'package:my_tie/models/new_fly/fly_materials.dart';
import 'package:my_tie/models/user_profile/user_profile.dart';
import 'package:my_tie/styles/string_format.dart';
import 'package:my_tie/styles/styles.dart';
import 'package:my_tie/widgets/title/title_group.dart';

class FlyExhibitDetailMaterials extends StatelessWidget {
  final FlyExhibit flyExhibit;

  const FlyExhibitDetailMaterials({Key key, this.flyExhibit}) : super(key: key);

  void _updateMaterialsOnHand(BuildContext context, UserProfile userProfile,
      FlyMaterial flyMaterial, bool hasMaterialOnHand) {
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

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      TitleGroup(title: 'Materials'),
      Card(
        elevation: 10,
        color: Theme.of(context).colorScheme.surface,
        margin: const EdgeInsets.fromLTRB(0, AppPadding.p0, 0, AppPadding.p4),
        child: Padding(
          padding:
              const EdgeInsets.fromLTRB(0, AppPadding.p4, 0, AppPadding.p2),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: flyExhibit.fly.materialList.map((flyMaterial) {
              bool hasMaterialOnHand = flyExhibit.userProfile.contains(
                  name: flyMaterial.name, properties: flyMaterial.properties);
              return Container(
                padding: EdgeInsets.fromLTRB(
                    AppPadding.p4, AppPadding.p4, 0, AppPadding.p4),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.fromLTRB(
                          AppPadding.p4, 0, AppPadding.p6, 0),
                      child: Icon(flyMaterial.icon, color: flyMaterial.color),
                    ),
                    Expanded(
                      child: Wrap(
                          alignment: WrapAlignment.spaceBetween,
                          children: [
                            Text(flyMaterial.value +
                                flyMaterial.name.toSingular()),
                          ]),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(0, 0, AppPadding.p2, 0),
                      child: InkWell(
                        onTap: () => _updateMaterialsOnHand(
                            context,
                            flyExhibit.userProfile,
                            flyMaterial,
                            !hasMaterialOnHand),
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
          ),
        ),
      ),
    ]);
  }
}
