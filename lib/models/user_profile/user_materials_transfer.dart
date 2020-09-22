import 'package:my_tie/models/new_fly/fly_form_material.dart';
import 'package:my_tie/models/user_profile/user_profile.dart';

class UserMaterialsTransfer {
  final UserProfile userProfile;
  final List<FlyFormMaterial> flyFormMaterials;
  // final NewFlyFormTemplate newFlyFormTemplate;

  UserMaterialsTransfer({this.userProfile, this.flyFormMaterials});
}
