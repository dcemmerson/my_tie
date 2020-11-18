import 'package:my_tie/models/new_fly/fly.dart';
import 'package:my_tie/models/new_fly/fly_materials.dart';
import 'package:my_tie/models/user_profile/user_profile.dart';
import 'package:my_tie/pages/tab_based_pages/tab_page.dart';

class FlyExhibit {
  // Flags used for animating flyExhibits in/out when user favorites/unfavorites
  // a fly exhibit.
  bool willBeRemoved = false;
  bool isRemoved = false;

  final Fly fly;
  // flyExhibitType is only used when user clicks on a fly in the
  // fly exhibit. The fly details exhibit needs to know which page the user
  // clicked on this fly so that the fly detail stream builder can correclty
  // subscribe to the correct fly exhibit bloc stream that downloaded this
  // fly from CloudFirestore.
  final FlyExhibitType flyExhibitType;
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
    this.flyExhibitType,
  });

  FlyExhibit.fromUserProfileAndFly(
      {this.flyExhibitType,
      this.fly,
      this.userProfile,
      this.willBeRemoved = false,
      this.isRemoved = false})
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

  static bool equals(FlyExhibit a, FlyExhibit b) {
    print('equalizer');
    if (a.fly?.docId == b.fly?.docId) {
      return true;
    } else {
      return false;
    }
  }
}
