import 'package:flutter/material.dart';
import 'package:my_tie/bloc/state/my_tie_state.dart';
import 'package:my_tie/bloc/user_bloc.dart';
import 'package:my_tie/models/bloc_transfer_related/user_profile_fly_material_add_or_delete.dart';
import 'package:my_tie/models/new_fly/fly_form_material.dart';
import 'package:my_tie/models/new_fly/fly_materials.dart';
import 'package:my_tie/models/user_profile/user_materials_transfer.dart';
import 'package:my_tie/styles/styles.dart';
import 'package:my_tie/styles/string_format.dart';

//ignore: must_be_immutable
class ProfileMaterialEditDisplayOnHand extends StatelessWidget {
  static const _delete = Padding(
      padding: EdgeInsets.all(AppPadding.p2),
      child: Text('Delete', style: TextStyle(color: Colors.white)));
  static const _deleteIcon = Padding(
      padding: EdgeInsets.all(AppPadding.p2),
      child: Icon(Icons.delete_forever, color: Colors.white));

  final FlyFormMaterial flyFormMaterial;
  final UserMaterialsTransfer userMaterialsTransfer;
  UserBloc _userBloc;
  BuildContext context;

  ProfileMaterialEditDisplayOnHand({
    this.flyFormMaterial,
    this.userMaterialsTransfer,
  });

  void _deleteMaterial(FlyMaterial flyMaterial) {
    _userBloc.deleteUserFlyMaterialSink.add(UserProfileFlyMaterialAddOrDelete(
        flyMaterial: flyMaterial,
        userProfile: userMaterialsTransfer.userProfile));
  }

  List<Widget> _buildMaterialsOnHandDisplay(List<FlyMaterial> materials) {
    return materials.map((flyMaterial) {
      return Card(
        color: Theme.of(context).secondaryHeaderColor,
        margin: EdgeInsets.fromLTRB(0, AppPadding.p2, 0, AppPadding.p1),
        child: Dismissible(
          background: Container(
              color: AppColors.delete,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [_delete, _deleteIcon],
              )),
          key: Key(flyMaterial.name),
          direction: DismissDirection.horizontal,
          onDismissed: (DismissDirection direction) =>
              _deleteMaterial(flyMaterial),
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
    this.context = context;
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
            Container(
                width: (2 * AppPadding.defaultIconButtonPadding +
                        2 * AppPadding.defaultIconPadding +
                        AppIcons.defaultIconSize)
                    .toDouble(),
                height: (2 * AppPadding.defaultIconButtonPadding +
                        2 * AppPadding.defaultIconPadding +
                        AppIcons.defaultIconSize)
                    .toDouble())
          ]),
        ),
        if (userMaterialsTransfer.userProfile
                .getMaterials(flyFormMaterial.name)
                .length >
            0)
          ..._buildMaterialsOnHandDisplay(userMaterialsTransfer.userProfile
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
