import 'package:my_tie/models/new_fly/fly_form_material.dart';
import 'package:my_tie/models/new_fly/fly_materials.dart';
import 'package:my_tie/models/user_profile/user_profile.dart';

class UserMaterialsTransfer {
  final UserProfile userProfile;
  // All materials that user could choose from to select and say "I have this
  //  material on hand"
  final List<FlyFormMaterial> flyFormMaterials;

  UserMaterialsTransfer({this.userProfile, this.flyFormMaterials});

  List<FlyMaterial> removeShallow(FlyMaterial flyMaterial) {
    userProfile
        .getMaterials(flyMaterial.name)
        .removeWhere((mat) => mat == flyMaterial);

    return userProfile.getMaterials(flyMaterial.name);
  }
}
