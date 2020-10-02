import 'package:flutter/material.dart';
import 'package:my_tie/bloc/state/my_tie_state.dart';
import 'package:my_tie/bloc/user_bloc.dart';
import 'package:my_tie/models/arguments/routes_based/edit_user_material_page_transfer.dart';
import 'package:my_tie/models/bloc_transfer_related/user_profile_fly_material_add_or_delete.dart';
import 'package:my_tie/models/new_fly/fly_form_material.dart';
import 'package:my_tie/models/new_fly/fly_materials.dart';
import 'package:my_tie/models/user_profile/user_materials_transfer.dart';
import 'package:my_tie/routes/user_profile_routes.dart';
import 'package:my_tie/styles/styles.dart';
import 'package:my_tie/styles/string_format.dart';

class ProfileMaterialOverview extends StatelessWidget {
  static const _delete = Padding(
      padding: EdgeInsets.all(AppPadding.p2),
      child: Text('Delete', style: TextStyle(color: Colors.white)));
  static const _deleteIcon = Padding(
      padding: EdgeInsets.all(AppPadding.p2),
      child: Icon(Icons.delete_forever, color: Colors.white));

  final FlyFormMaterial flyFormMaterial;
  final UserMaterialsTransfer userMaterialsTransfer;

  UserBloc _userBloc;

  ProfileMaterialOverview({
    this.flyFormMaterial,
    this.userMaterialsTransfer,
  });

  void _deleteMaterial(FlyMaterial flyMaterial) {
    _userBloc.deleteUserFlyMaterialSink.add(UserProfileFlyMaterialAddOrDelete(
        flyMaterial: flyMaterial,
        userProfile: userMaterialsTransfer.userProfile));
  }

  List<Widget> _buildMaterialsOnHandSection(List<FlyMaterial> materials) {
    return materials.map((flyMaterial) {
      return Container(
        padding:
            EdgeInsets.fromLTRB(AppPadding.p4, AppPadding.p2, 0, AppPadding.p2),
        child: Row(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.fromLTRB(AppPadding.p4, 0, AppPadding.p6, 0),
              child: Icon(flyMaterial.icon,
                  color: flyMaterial.color, size: AppIcons.small),
            ),
            Container(
              child: Expanded(
                child: Wrap(alignment: WrapAlignment.spaceBetween, children: [
                  Text(flyMaterial.value),
                ]),
              ),
            ),
          ],
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    _userBloc = MyTieStateContainer.of(context).blocProvider.userBloc;

    if (flyFormMaterial == null)
      return Text('Error...shouldn\'t have landed here...');
    return Card(
      color: Theme.of(context).colorScheme.surface,
      margin: EdgeInsets.fromLTRB(0, AppPadding.p2, 0, AppPadding.p4),
      child: Column(children: [
        Padding(
          padding: EdgeInsets.all(AppPadding.p4),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Icon(flyFormMaterial.icon),
            Text(flyFormMaterial.name.toTitleCase(),
                style: AppTextStyles.header),
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                return UserProfileRoutes.userProfileEditPage(
                    context,
                    EditUserMaterialPageTransfer(
                        material: flyFormMaterial.name));
              },
            ),
          ]),
        ),
        if (userMaterialsTransfer.userProfile
                .getMaterials(flyFormMaterial.name)
                .length >
            0)
          ..._buildMaterialsOnHandSection(userMaterialsTransfer.userProfile
              .getMaterials(flyFormMaterial.name)),
        if (userMaterialsTransfer.userProfile
                .getMaterials(flyFormMaterial.name)
                .length ==
            0)
          Text('None selected'),
      ]),
      // ),
    );
  }
}
