import 'package:flutter/material.dart';
import 'package:my_tie/models/user_profile/user_materials_transfer.dart';
import 'package:my_tie/models/user_profile/user_profile.dart';
import 'package:my_tie/styles/styles.dart';
import 'package:my_tie/widgets/profile_overview/profile_overview_stream_builder.dart';

class ProfileOverview extends StatefulWidget {
  @override
  _ProfileOverviewState createState() => _ProfileOverviewState();
}

class _ProfileOverviewState extends State<ProfileOverview> {
  bool editMode;

  @override
  void initState() {
    super.initState();
    editMode = false;
  }

  Widget _userHeader() {
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

  Widget _materialsOnHandleHeader() {
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

  Widget _buildUserOverview(UserProfile userProfile) {
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

  Widget _buildMaterialsOverview(UserProfile userProfile) {
    return Card(
      color: Theme.of(context).colorScheme.surface,
      margin: EdgeInsets.fromLTRB(0, AppPadding.p2, 0, AppPadding.p4),
      child: Padding(
        padding: EdgeInsets.all(AppPadding.p4),
        child: Column(children: [
          if (userProfile.materialsOnHand.length == 0)
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text('No materials selected',
                  style: TextStyle(fontSize: AppFonts.h4)),
              _editMaterialsButton(),
            ]),
          if (userProfile.materialsOnHand.length > 0)
            ..._buildMaterialsOnHandDisplay(userProfile),
        ]),
      ),
    );
  }

  List<Widget> _buildMaterialsOnHandDisplay(UserProfile userProfile) {
    return userProfile.materialsOnHand
        .map((flyMaterial) => Row(
              children: [
                Icon(flyMaterial.icon, color: flyMaterial.color),
                Text(flyMaterial.value)
              ],
            ))
        .toList();
  }

  Widget _editMaterialsButton() {
    return Container(
      alignment: Alignment.centerRight,
      child: IconButton(
        padding: EdgeInsets.all(0),
        icon: Icon(Icons.edit),
        onPressed: () => setState(() => editMode = true),
      ),
    );
  }

  Widget _buildMaterialsOnHandEdit(
      UserMaterialsTransfer userMaterialsTransfer) {
    return Column(
      children: userMaterialsTransfer.flyFormMaterials
          .map((formMaterial) =>
              Text(formMaterial.name, style: AppTextStyles.header))
          .toList(),
    );
  }

  Widget _builProfileOverviewEdit(UserMaterialsTransfer userMaterialsTransfer) {
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      _userHeader(),
      _buildUserOverview(userMaterialsTransfer.userProfile),
      _materialsOnHandleHeader(),
      _buildMaterialsOnHandEdit(userMaterialsTransfer),
    ]);
  }

  Widget _buildProfileOverview(UserMaterialsTransfer userMaterialsTransfer) {
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      _userHeader(),
      _buildUserOverview(userMaterialsTransfer.userProfile),
      _materialsOnHandleHeader(),
      _buildMaterialsOverview(userMaterialsTransfer.userProfile),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    if (editMode) {
      return ProfileOverviewStreamBuilder(child: _builProfileOverviewEdit);
    } else {
      return ProfileOverviewStreamBuilder(
        child: _buildProfileOverview,
      );
    }
  }
}
