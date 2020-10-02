import 'package:my_tie/models/new_fly/fly_materials.dart';
import 'package:my_tie/models/user_profile/user_profile.dart';

class UserProfileFlyMaterialAddOrDelete {
  final UserProfile userProfile;
  final FlyMaterial flyMaterial;

  UserProfileFlyMaterialAddOrDelete({this.userProfile, this.flyMaterial});

  UserProfileFlyMaterialAddOrDelete.fromMap(Map map,
      {String name, this.userProfile})
      : this.flyMaterial = FlyMaterial.fromMap(name: name, properties: map);
}
