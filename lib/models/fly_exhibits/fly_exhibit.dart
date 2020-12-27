import 'package:my_tie/models/fly_exhibits/favorited_fly_exhibit.dart';
import 'package:my_tie/models/new_fly/fly.dart';
import 'package:my_tie/models/new_fly/fly_materials.dart';
import 'package:my_tie/models/user_profile/user_profile.dart';
import 'package:my_tie/pages/tab_based_pages/tab_page.dart';

class FlyExhibit {
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

  FlyExhibit.fromFlyExhibit(FlyExhibit flyExhibit,
      {FlyExhibitType flyExhibitType, bool favorited: false})
      : this.fly = flyExhibit.fly,
        this.flyExhibitType = flyExhibitType ?? flyExhibit.flyExhibitType,
        this.userProfile = flyExhibit.userProfile,
        this.requiredMaterialCountFly = flyExhibit.requiredMaterialCountFly,
        this.requiredMaterialCountUser = flyExhibit.requiredMaterialCountUser,
        this.isFavorited = favorited;

  FlyExhibit.fromUserProfileAndFly({
    this.flyExhibitType,
    this.fly,
    this.userProfile,
  })  : requiredMaterialCountFly = fly.materialList.length,
        requiredMaterialCountUser = _countFlyMaterialsOnHand(userProfile, fly),
        isFavorited = _isFavorited(fly, userProfile);

  static bool _isFavorited(Fly fly, UserProfile userProfile) {
    if (userProfile.favoriteFlyDocs == null) return false;

    return userProfile.favoriteFlyDocs.contains(fly.docId);
  }

  String get materialsFraction =>
      '$requiredMaterialCountUser / $requiredMaterialCountFly';

  bool containsTerm(String searchTerm) {
    // final loweredSearchTerm = searchTerm.toLowerCase();

    return flyExhibitType.flyExhibitType.contains(searchTerm) ||
        requiredMaterialCountFly.toString().contains(searchTerm) ||
        requiredMaterialCountUser.toString().contains(searchTerm) ||
        fly.containsTerm(searchTerm);
  }

  static int _countFlyMaterialsOnHand(UserProfile userProfile, Fly fly) {
    return fly.materialList.fold(0, (int prevValue, FlyMaterial flyMaterial) {
      if (userProfile.contains(
          name: flyMaterial.name, properties: flyMaterial.properties)) {
        return ++prevValue;
      }
      return prevValue;
    });
  }

  static bool equals(dynamic a, dynamic b) {
    if (a is! FavoritedFlyExhibit || b is! FavoritedFlyExhibit) {
      return a == b;
    } else {
      final flyA = a as FavoritedFlyExhibit;
      final flyB = b as FavoritedFlyExhibit;
      // We test if materialsFractions are equal here as this will tell us
      // if a material update just came through the stream, in which case info
      // in the fly exhibit needs to be updated on the UI (which the stream
      // builder needs to be able to handle, and using the == operator will allow
      // the stream builder to correctly detect this).
      if (flyA.materialsFraction != flyB.materialsFraction) {
        return a == b;
      } else {
        // Else we need to define the equality for cases where the AnimatedListStream
        // is attempting to determine which FavoritedFlyExhibits were actually
        // removed by comparing the items emitted in the previous stream event
        // and the items emitted in the latest stream event. In this case,
        // AnimatedListStream will animate out any items that are no longer
        // contained in the latest stream emission.
        // We need to check here is a.fly is null (or we could check if b.fly
        // is null instead) so that we don't risk evaluating null == null and accidentally
        // return true. This could occur when comparing is a FlyExhibitEndCapIndicator
        // is equal to a FlyExhibitLoadingIndicator, since neither of these FlyExhibit
        // subclasses would have a non-null fly attribute.
        return a.fly != null && a.fly?.docId == b.fly?.docId;
      }
    }
    // if (a == b) {
    //   return true;
    // }
    // if (a.fly != null && a.fly?.docId == b.fly?.docId) {
    //   return true;
    // } else {
    //   return false;
    // }
  }
}
