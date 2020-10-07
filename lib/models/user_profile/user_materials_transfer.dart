import 'package:my_tie/models/new_fly/fly_form_material.dart';
import 'package:my_tie/models/new_fly/fly_materials.dart';
import 'package:my_tie/models/user_profile/user_profile.dart';

class UserMaterialsTransfer {
  final UserProfile userProfile;
  final List<FlyFormMaterial> flyFormMaterials;
  // final NewFlyFormTemplate newFlyFormTemplate;

  UserMaterialsTransfer({this.userProfile, this.flyFormMaterials});

  List<FlyMaterial> removeShallow(FlyMaterial flyMaterial) {
    print('before');
    print(userProfile.getMaterials(flyMaterial.name));
    userProfile.getMaterials(flyMaterial.name).removeWhere((mat) {
      print('mat = ');
      print(mat == flyMaterial);

      return mat == flyMaterial;
    });
    print('after');
    print(userProfile.getMaterials(flyMaterial.name));
    return userProfile.getMaterials(flyMaterial.name);
  }
}
