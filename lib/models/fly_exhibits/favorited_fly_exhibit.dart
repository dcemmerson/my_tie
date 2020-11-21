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

  FavoritedFlyExhibit({
    this.doc,
    UserProfile userProfile,
    Fly fly,
  }) : super.fromUserProfileAndFly(
            flyExhibitType: FlyExhibitType.Favorites,
            fly: fly,
            userProfile: userProfile);
}
