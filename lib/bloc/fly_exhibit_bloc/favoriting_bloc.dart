//  filename: favoriting_bloc
//  description: BLoC responsible for allowing user to like/unlike flies,
//    by tapping on heart icon on fly exhibit.

import 'dart:async';

import 'package:my_tie/models/db_names.dart';
import 'package:my_tie/models/fly_exhibits/fly_exhibit.dart';
import 'package:my_tie/models/user_profile/user_materials_transfer.dart';
import 'package:my_tie/models/user_profile/user_profile.dart';
import 'package:my_tie/services/network/fly_exhibit_services/fly_exhibit_service.dart';

import '../user_bloc.dart';

class FavoritingBloc {
  UserBloc userBloc;
  UserProfile userProfile;
  FlyExhibitService flyExhibitService;

  final _favoritedFliesStreamController = StreamController<FlyExhibit>();
  StreamSink<FlyExhibit> favoritedFlySink;

  static final sharedInstance = FavoritingBloc._();

  FavoritingBloc._() {
    favoritedFlySink = _favoritedFliesStreamController.sink;
  }

  void init({
    UserBloc userBloc,
    FlyExhibitService flyExhibitService,
  }) {
    this.userBloc = userBloc;
    this.flyExhibitService = flyExhibitService;
    // this.userProfile = userBloc.userService
    _listenForFavoritedFlyEvents();
    _listenForUserProfileEvents();
  }

  void _assertThisIsInited() {
    assert(userBloc != null);
    assert(flyExhibitService != null);
  }

  /// Keep user profile in sync to correctly favorite/unfavorite flies.
  /// Firestore will enforce dis-allowing a user to incorrectly favorite/favorite
  /// another user's flies, as well.
  void _listenForUserProfileEvents() {
    userBloc.userMaterialsProfile.listen((UserMaterialsTransfer umt) {
      userProfile = umt.userProfile;
    });
  }

  /// Listen for events being dispatched from UI, added to favoritedFlySink,
  /// representing user selecting/deselecting the favorite fly button. FlyExhibit
  /// is added to sink and we either add or remove docId from user's favorited
  /// fly list in db. Additionally, we must update the favorited flies
  /// collection (which denormalizes fly docs to enable querying on the user's
  /// favorited flies).
  void _listenForFavoritedFlyEvents() {
    _assertThisIsInited();

    _favoritedFliesStreamController.stream.listen((flyExhibit) {
      if (flyExhibit.isFavorited) {
        userBloc.removeFromFavorites(
            flyExhibit.userProfile.docId, flyExhibit.fly.docId);
        flyExhibitService.removeFavoriteFly(
            userProfile.uid, flyExhibit.fly.docId);
      } else {
        userBloc.addToFavorites(
            flyExhibit.userProfile.docId, flyExhibit.fly.docId);
        flyExhibitService.addFavoriteFly({
          DbNames.uid: userProfile.uid,
          DbNames.originalFlyDocId: flyExhibit.fly.docId,
          ...flyExhibit.fly.toMap()
        });
      }
    });
  }

  void close() {
    _favoritedFliesStreamController.close();
    favoritedFlySink.close();
  }
}
