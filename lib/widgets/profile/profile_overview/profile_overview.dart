import 'package:flutter/material.dart';
import 'package:my_tie/models/arguments/routes_based/edit_user_material_page_transfer.dart';
import 'package:my_tie/models/new_fly/fly_materials.dart';
import 'package:my_tie/models/user_profile/user_materials_transfer.dart';
import 'package:my_tie/models/user_profile/user_profile.dart';
import 'package:my_tie/routes/routes.dart';
import 'package:my_tie/routes/user_profile_routes.dart';
import 'package:my_tie/styles/styles.dart';
import 'package:my_tie/styles/string_format.dart';
import 'profile_overview_stream_builder.dart';

class ProfileOverview extends StatelessWidget {
  Widget _userHeader(
    BuildContext context,
  ) {
    return Container(
      padding: EdgeInsets.all(AppPadding.p2),
      child: Opacity(
        opacity: 0.9,
        child: Text(
          'User',
          style: TextStyle(
            fontSize: AppFonts.h3,
            color: Theme.of(context).colorScheme.secondaryVariant,
            decoration: TextDecoration.underline,
          ),
        ),
      ),
    );
  }

  Widget _materialsOnHandleHeader(
    BuildContext context,
  ) {
    return Container(
      padding: EdgeInsets.all(AppPadding.p2),
      child: Row(children: [
        Opacity(
          opacity: 0.9,
          child: Text(
            'Materials On Hand',
            style: TextStyle(
              fontSize: AppFonts.h3,
              color: Theme.of(context).colorScheme.secondaryVariant,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
      ]),
    );
  }

  Widget _buildUserOverview(BuildContext context, UserProfile userProfile) {
    return Card(
      color: Theme.of(context).colorScheme.surface,
      margin: EdgeInsets.fromLTRB(0, AppPadding.p2, 0, AppPadding.p4),
      child: Padding(
        padding: EdgeInsets.fromLTRB(0, AppPadding.p2, 0, AppPadding.p4),
        child: Column(children: [
          if (userProfile.user != null)
            Text(userProfile.user, style: TextStyle(fontSize: AppFonts.h4)),
          if (userProfile.name != null) Text(userProfile.name)
        ]),
      ),
    );
  }

  List<Widget> _buildMaterialsOverview(
      BuildContext context, UserMaterialsTransfer userMaterialsTransfer) {
    return userMaterialsTransfer.flyFormMaterials.map((flyFormMaterial) {
      return Card(
        color: Theme.of(context).colorScheme.surface,
        margin: EdgeInsets.fromLTRB(0, AppPadding.p2, 0, AppPadding.p4),
        child: Padding(
          padding: EdgeInsets.all(AppPadding.p4),
          child: Column(children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Icon(flyFormMaterial.icon),
              Text(flyFormMaterial.name.toTitleCase(),
                  style: AppTextStyles.header),
              IconButton(
                icon: Icon(Icons.edit),
                onPressed: () => UserProfileRoutes.userProfileEditPage(
                    context,
                    EditUserMaterialPageTransfer(
                        material: flyFormMaterial.name)),
              )
            ]),
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
        ),
      );
    }).toList();
  }

  List<Widget> _buildMaterialsOnHandDisplay(List<FlyMaterial> materials) {
    return materials
        .map((flyMaterials) => Row(
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding:
                      EdgeInsets.fromLTRB(AppPadding.p8, 0, AppPadding.p2, 0),
                  child: Icon(flyMaterials.icon, color: flyMaterials.color),
                ),
                Expanded(
                    child: Container(
                        alignment: Alignment.center,
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [Text(flyMaterials.value)]))),
              ],
            ))
        .toList();
  }

  Widget _buildProfileOverview(
      BuildContext context, UserMaterialsTransfer userMaterialsTransfer) {
    return SingleChildScrollView(
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        _userHeader(context),
        _buildUserOverview(context, userMaterialsTransfer.userProfile),
        _materialsOnHandleHeader(context),
        ..._buildMaterialsOverview(context, userMaterialsTransfer),
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ProfileOverviewStreamBuilder(
      child: (userMaterialsTransfer) =>
          _buildProfileOverview(context, userMaterialsTransfer),
    );
  }
}
