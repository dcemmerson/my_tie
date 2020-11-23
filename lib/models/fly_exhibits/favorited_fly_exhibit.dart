/// filename: favorited_fly_exhibit.dart
/// decription: Subclass of the FlyExhibit class used to maintain reference
///   along with the FlyExhibit so the doc reference can be used to query
///   when implementing the infinte scroll in the Fly Exhibit UI. Remember,
///   our favorited fly collection is denormalized from the fly exhibit for
///   easy querying on the favorited fly exhibit documents. This means every
///   time we want to continue our favorited fly exhibit queries based off the
///   last doc retrieved, we need to use the previous fly doc that belongs to the
///   favorited fly collection, and not the fly collection.
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_tie/models/new_fly/fly.dart';
import 'package:my_tie/models/user_profile/user_profile.dart';
import 'package:my_tie/pages/tab_based_pages/tab_page.dart';

import 'fly_exhibit.dart';

class FavoritedFlyExhibit extends FlyExhibit {
  final DocumentSnapshot doc;
  final bool materialUpdate;

  FavoritedFlyExhibit(
      {this.doc, UserProfile userProfile, Fly fly, this.materialUpdate = true})
      : super.fromUserProfileAndFly(
            flyExhibitType: FlyExhibitType.Favorites,
            fly: fly,
            userProfile: userProfile);

  // This override of the equality operator is required due to a bug in the
  // AnimatedListStream used in the FlyExhibitEntry widget. The AnimatedListStream
  // allows us to pass an equality closure, but the AnimatedListStream does not
  // correctly pass the equality closure to the isolate where the Myers diff
  // calc is performed, thus defaulting to using (a, b) => a == b when comparing
  // FlyExhibits. An issue has been opened for this Flutter package.
  // November 2020
  // Equality override commented out for now. Causes issues with asynchronously
  // updating fly exhibits. Current effect of commenting out this override is the
  // wrong fly exhibit gets animated out on favorites tab.
  // @override
  // bool operator ==(other) {
  //   if (this is FlyExhibitEndCapIndicator &&
  //       other is FlyExhibitEndCapIndicator) {
  //     return true;
  //   } else if (this is FlyExhibitLoadingIndicator &&
  //       other is FlyExhibitLoadingIndicator) {
  //     return true;
  //   } else if (this.fly?.docId == other.fly?.docId) {
  //     return true;
  //   } else {
  //     return false;
  //   }
  // }

  // @override
  // int get hashCode => super.hashCode;
}
