import 'package:flutter/material.dart';

import 'package:my_tie/models/arguments/routes_based/edit_user_material_page_transfer.dart';
import 'package:my_tie/models/new_fly/fly_form_material.dart';
import 'package:my_tie/models/new_fly/fly_materials.dart';
import 'package:my_tie/models/user_profile/user_materials_transfer.dart';
import 'package:my_tie/routes/user_profile_routes.dart';
import 'package:my_tie/styles/styles.dart';
import 'package:my_tie/styles/string_format.dart';

class ProfileMaterialOverview extends StatelessWidget {
  final FlyFormMaterial flyFormMaterial;
  final UserMaterialsTransfer userMaterialsTransfer;

  ProfileMaterialOverview({
    this.flyFormMaterial,
    this.userMaterialsTransfer,
  });

  List<Widget> _buildMaterialsOnHandSection(List<FlyMaterial> materials) {
    return materials.map((flyMaterial) {
      return Container(
        padding:
            EdgeInsets.fromLTRB(AppPadding.p4, AppPadding.p2, 0, AppPadding.p2),
        child: Row(
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
                return UserProfileRoutes.userProfileEditMaterialPage(
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
