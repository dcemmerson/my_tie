import 'package:flutter/material.dart';
import 'package:my_tie/bloc/state/my_tie_state.dart';
import 'package:my_tie/models/bloc_transfer_related/user_profile_fly_material_add_or_delete.dart';
import 'package:my_tie/models/new_fly/fly_form_material.dart';
import 'package:my_tie/models/new_fly/fly_materials.dart';
import 'package:my_tie/models/user_profile/user_materials_transfer.dart';
import 'package:my_tie/styles/styles.dart';
import 'package:my_tie/styles/string_format.dart';

class ProfileMaterialEditDisplayOnHand extends StatelessWidget {
  static const _delete = Padding(
      padding: EdgeInsets.all(AppPadding.p2),
      child: Text('Delete', style: TextStyle(color: Colors.white)));
  static const _deleteIcon = Padding(
      padding: EdgeInsets.all(AppPadding.p2),
      child: Icon(Icons.delete_forever, color: Colors.white));

  final FlyFormMaterial flyFormMaterial;
  final UserMaterialsTransfer userMaterialsTransfer;

  ProfileMaterialEditDisplayOnHand({
    this.flyFormMaterial,
    this.userMaterialsTransfer,
  });

  void _deleteMaterial(FlyMaterial flyMaterial, BuildContext context) {
    MyTieStateContainer.of(context)
        .blocProvider
        .userBloc
        .deleteUserFlyMaterialSink
        .add(UserProfileFlyMaterialAddOrDelete(
            flyMaterial: flyMaterial,
            userProfile: userMaterialsTransfer.userProfile));
  }

  List<Widget> _buildMaterialsOnHandDisplay(
      List<FlyMaterial> materials, BuildContext context) {
    return materials.map((flyMaterial) {
      return Card(
        color: Theme.of(context).secondaryHeaderColor,
        margin: EdgeInsets.fromLTRB(0, AppPadding.p2, 0, AppPadding.p1),
        child: Dismissible(
          key: UniqueKey(),
          background: Container(
              color: AppColors.delete,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [_delete, _deleteIcon],
              )),
          // key: Key(flyMaterial.name),
          direction: DismissDirection.horizontal,
          onDismissed: (DismissDirection direction) =>
              _deleteMaterial(flyMaterial, context),
          child: ListTile(
            leading: Icon(flyMaterial.icon, color: flyMaterial.color),
            title: Text(flyMaterial.value),
          ),
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    if (flyFormMaterial == null)
      return Text('Error...shouldn\'t have landed here...');

    List<FlyMaterial> userMaterials =
        userMaterialsTransfer.userProfile.getMaterials(flyFormMaterial.name);

    userMaterials.forEach((mat) => print(mat.properties));
    return Card(
      color: Theme.of(context).colorScheme.surface,
      margin: EdgeInsets.fromLTRB(0, AppPadding.p2, 0, AppPadding.p4),
      child: Column(children: [
        if (userMaterials.length > 0)
          ..._buildMaterialsOnHandDisplay(userMaterials, context),
        if (userMaterials.length == 0)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                  padding: EdgeInsets.all(AppPadding.p4),
                  child: Text('None selected'))
            ],
          ),
      ]),
      // ),
    );
  }
}
