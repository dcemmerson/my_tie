import 'package:flutter/material.dart';
import 'package:my_tie/models/user_profile/user_materials_transfer.dart';
import 'package:my_tie/models/user_profile/user_profile.dart';
import 'package:my_tie/styles/styles.dart';
import 'package:my_tie/widgets/title/title_group.dart';
import '../profile_overview_stream_builder.dart';
import 'profile_material_overview.dart';

class ProfileOverview extends StatelessWidget {
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
      return ProfileMaterialOverview(
        userMaterialsTransfer: userMaterialsTransfer,
        flyFormMaterial: flyFormMaterial,
      );
    }).toList();
  }

  Widget _buildProfileOverview(
      BuildContext context, UserMaterialsTransfer userMaterialsTransfer) {
    return SingleChildScrollView(
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        TitleGroup(title: 'User'),
        _buildUserOverview(context, userMaterialsTransfer.userProfile),
        TitleGroup(title: 'Materials On Hand'),
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
