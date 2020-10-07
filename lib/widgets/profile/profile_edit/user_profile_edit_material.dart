import 'package:flutter/material.dart';
import 'package:my_tie/models/arguments/routes_based/edit_user_material_page_transfer.dart';
import 'package:my_tie/models/user_profile/user_materials_transfer.dart';
import 'package:my_tie/styles/styles.dart';
import 'package:my_tie/widgets/forms/profile_form/profile_add_material_form.dart';
import 'package:my_tie/widgets/profile/profile_overview_stream_builder.dart';
import 'package:my_tie/styles/string_format.dart';
import 'package:my_tie/widgets/title/title_group.dart';

import 'profile_material_edit_display_on_hand.dart';

class UserProfileEditMaterial extends StatelessWidget {
  Widget _buildProfileEdit(
      UserMaterialsTransfer userMaterialsTransfer,
      EditUserMaterialPageTransfer editUserMaterialPageTransfer,
      BuildContext context) {
    final flyFormMaterial = userMaterialsTransfer.flyFormMaterials.firstWhere(
        (ffm) => ffm.name == editUserMaterialPageTransfer.material,
        orElse: () => null);
    return SingleChildScrollView(
        child: Column(
      children: [
        TitleGroup(
          title:
              '${editUserMaterialPageTransfer.material.toTitleCase()} On Hand',
        ),
        ProfileMaterialEditDisplayOnHand(
          userMaterialsTransfer: userMaterialsTransfer,
          flyFormMaterial: flyFormMaterial,
        ),
        Divider(
          height: AppPadding.p8,
          color: Theme.of(context).dividerColor,
        ),
        TitleGroup(
            title:
                'Add ${editUserMaterialPageTransfer.material.toSingular().toTitleCase()}'),
        ProfileAddMaterialForm(
            flyFormMaterial: flyFormMaterial,
            userProfile: userMaterialsTransfer.userProfile),
      ],
    ));
  }

  @override
  Widget build(BuildContext context) {
    return ProfileOverviewStreamBuilder(
      child: (UserMaterialsTransfer umt) => _buildProfileEdit(
          umt,
          ModalRoute.of(context).settings.arguments
              as EditUserMaterialPageTransfer,
          context),
    );
  }
}
