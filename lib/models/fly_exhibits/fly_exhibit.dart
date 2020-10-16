import 'package:my_tie/models/new_fly/fly.dart';
import 'package:my_tie/models/new_fly/fly_materials.dart';
import 'package:my_tie/models/user_profile/user_profile.dart';

class FlyExhibit {
  final Fly fly;
  final UserProfile userProfile;
  final int requiredMaterialCountUser;
  final int requiredMaterialCountFly;
  final bool isFavorited;

  FlyExhibit({
    this.fly,
    this.userProfile,
    this.requiredMaterialCountUser,
    this.requiredMaterialCountFly,
    this.isFavorited,
  });

  FlyExhibit.fromUserProfileAndFly({this.fly, this.userProfile})
      : requiredMaterialCountFly = fly.materialList.length,
        requiredMaterialCountUser = _countFlyMaterialsOnHand(userProfile, fly),
        isFavorited = _isFavorited(fly, userProfile);

  static bool _isFavorited(Fly fly, UserProfile userProfile) {
    if (userProfile.favoriteFlyDocs == null) return false;

    return userProfile.favoriteFlyDocs.contains(fly.docId);
  }

  String get materialsFraction =>
      '$requiredMaterialCountUser / $requiredMaterialCountFly';

  static int _countFlyMaterialsOnHand(UserProfile userProfile, Fly fly) {
    return fly.materialList.fold(0, (int prevValue, FlyMaterial flyMaterial) {
      if (userProfile.contains(
          name: flyMaterial.name, properties: flyMaterial.properties)) {
        return ++prevValue;
      }
      return prevValue;
    });
  }
}
