import 'package:my_tie/models/new_fly/fly.dart';
import 'package:my_tie/models/new_fly/fly_materials.dart';
import 'package:my_tie/models/user_profile/user_profile.dart';

class FlyExhibit {
  final Fly fly;
  final int requiredMaterialCountUser;
  final int requiredMaterialCountFly;

  FlyExhibit({
    this.fly,
    this.requiredMaterialCountUser,
    this.requiredMaterialCountFly,
  });

  String get materialsFraction =>
      '$requiredMaterialCountUser / $requiredMaterialCountFly';

  FlyExhibit.fromUserProfileAndFly({this.fly, UserProfile userProfile})
      : requiredMaterialCountFly = fly.materialList.length,
        requiredMaterialCountUser = _countFlyMaterialsOnHand(userProfile, fly);

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
