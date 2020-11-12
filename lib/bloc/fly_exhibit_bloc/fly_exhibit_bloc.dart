import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_tie/models/db_names.dart';
import 'package:my_tie/models/fly_exhibits/fly_exhibit.dart';
import 'package:my_tie/models/new_fly/fly.dart';
import 'package:my_tie/models/new_fly/new_fly_form_template.dart';
import 'package:my_tie/models/user_profile/user_materials_transfer.dart';
import 'package:my_tie/models/user_profile/user_profile.dart';
import 'package:my_tie/pages/tab_based_pages/tab_page.dart';
import 'package:my_tie/services/network/fly_exhibit_services/fly_exhibit_service.dart';
import 'package:my_tie/services/network/fly_form_template_service.dart';

import '../user_bloc.dart';

/// Classes solely used to pass signals in stream controllers.
class FetchFliesEvent {}

class FetchNewestFliesEvent extends FetchFliesEvent {}

class FlyExhibitLoadingIndicator extends FlyExhibit {}

class FlyExhibitEndCapIndicator extends FlyExhibit {}

abstract class FlyExhibitBloc {
  // final AuthBloc authBloc;
  final UserBloc userBloc;
  final FlyExhibitService flyExhibitService;
  final FlyFormTemplateService flyFormTemplateService;

  final _favoritedFliesStreamController = StreamController<FlyExhibit>();
  StreamSink<FlyExhibit> favoritedFlySink;
  final _requestFetchFlies = StreamController<FetchFliesEvent>();
  StreamSink<FetchFliesEvent> requestFetchFliesSink;
  StreamController<FlyExhibit> flyDetailStreamController;

  // Don't mark flies as final. During the majority of the bloc,
  //  we will not reassign flies and instead just add FlyExhibits to it,
  //  but in instance of user updating profile, we will map flies to the
  //  updated version of flies, thus needing to reassign.
  List<FlyExhibit> flies = [];
  // prevFlyDoc will be reassigned every time user scrolls to bottom of page,
  // and we need to load additional flies. prevFlyDoc allows queries to pick up
  // where we left off in the last query when querying Firestore.
  DocumentSnapshot prevFlyDoc;
  UserProfile userProfile;

  final fliesStreamController = StreamController<List<FlyExhibit>>.broadcast();
  Stream<List<FlyExhibit>> fliesStream;

  FlyExhibitType get flyExhibitType;

  FlyExhibitBloc({
    this.userBloc,
    this.flyExhibitService,
    this.flyFormTemplateService,
  }) {
    fliesStream = fliesStreamController.stream;
    fliesStreamController.onListen = initFliesFetch;
    favoritedFlySink = _favoritedFliesStreamController.sink;
    requestFetchFliesSink = _requestFetchFlies.sink;

    _listenForUserMaterialProfileEvents();
    _listenForRequestFliesFetch();
    _listenForFavoritedFlyEvents();
  }

  /// Get userProfile, and listen for changes to userProfile. Update all FlyExhibit
  /// if upon changes to userProfile (materials on hand for each fly may change
  ///  when user profile is updated).
  void _listenForUserMaterialProfileEvents() {
    userBloc.userMaterialsProfile.listen((UserMaterialsTransfer umt) {
      userProfile = umt.userProfile;

      flies = flies.map((FlyExhibit flyExhibit) {
        if (flyExhibit is FlyExhibitEndCapIndicator)
          return FlyExhibitEndCapIndicator();
        return FlyExhibit.fromUserProfileAndFly(
          flyExhibitType: flyExhibitType,
          fly: flyExhibit.fly,
          userProfile: userProfile,
        );
      }).toList();

      fliesStreamController.add(flies);
    });
  }

  /// name: initFliesFetch
  /// description: Used only for first call to Firestore to retrieve first 10
  ///   newest fly docs. This call initializes the prevNewestFlyDoc var, which
  ///   can then be used for subsequent calls to Firestore for additional fly
  ///   docs for newest fly exhibit, in an infinite scroll/fetch manner.
  void initFliesFetch() async {
    final Future<QuerySnapshot> flyTemplateDocF =
        flyFormTemplateService.newFlyForm;
    final Future<QuerySnapshot> queryF =
        flyExhibitService.initGetCompletedFlies(uid: userProfile.uid);

    // No need to use Future.wait, as query depeneds on flyFormTemplate.
    final flyFormTemplateDoc =
        NewFlyFormTemplate.fromDoc((await flyTemplateDocF).docs[0].data());
    final flyQueries = await queryF;

    setPrevDoc(flyQueries);
    formatAndSendFliesToUI(flyQueries, flyFormTemplateDoc);
  }

  /// Listen for fetch flies events being adddd to sink from UI (eg, when user
  ///  scrolls to bottom of screen and infinite scroll needs to load more
  ///  flies). First added the FlyExhibitLoadingIndicator, to tell UI to show
  ///  spinner, then call _newestFliesFetch which will make request to db,
  ///  update _newestFlies, then add _newest flies to newestFliesStreamController.
  void _listenForRequestFliesFetch() {
    _requestFetchFlies.stream.listen((ffe) {
      if (ffe is FetchNewestFliesEvent) {
        flies.add(FlyExhibitLoadingIndicator());
        fliesStreamController.add(flies);
        fliesFetch();
      } else {
        // Unreachable, but you never know...
        print('event not found - unimplemented $ffe');
        throw Error();
      }
    });
  }

  void fliesFetch() async {
    final Future<QuerySnapshot> flyTemplateDocF =
        flyFormTemplateService.newFlyForm;
    final Future<QuerySnapshot> queryF =
        flyExhibitService.getCompletedFliesByDateAfterDoc(
            uid: userProfile.uid, prevDoc: prevFlyDoc);

    // No need to use Future.wait, as query depeneds on flyFormTemplate.
    final flyFormTemplateDoc =
        NewFlyFormTemplate.fromDoc((await flyTemplateDocF).docs[0].data());
    final flyQueries = await queryF;

    setPrevDoc(flyQueries);
    formatAndSendFliesToUI(flyQueries, flyFormTemplateDoc);
  }

  /// Listen for events being dispatched from UI, added to favoritedFlySink,
  /// representing user selecting/deselecting the favorite fly button. FlyExhibit
  /// is added to sink and we either add or remove docId from user's favorited
  /// fly list in db. Additionally, we must update the favorited flies
  /// collection (which denormalizes fly docs to enable querying on the user's
  /// favorited flies).
  void _listenForFavoritedFlyEvents() {
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

  void setPrevDoc(QuerySnapshot flyQueries) {
    if (flyQueries.docs.length > 0)
      prevFlyDoc = flyQueries.docs[flyQueries.docs.length - 1];
  }

  void formatAndSendFliesToUI(
      QuerySnapshot flyQueries, NewFlyFormTemplate flyFormTemplateDoc) async {
    // final UserMaterialsTransfer userMaterials =
    //     await userBloc.userMaterialsProfile.first;

    // userService.getUserProfile(authService.currentUser.uid);

    final List<FlyExhibit> flyExhibits = flyQueries.docs.map((doc) {
      final flyDoc = doc.data();
      return FlyExhibit.fromUserProfileAndFly(
        flyExhibitType: flyExhibitType,
        userProfile: userProfile,
        fly: Fly.formattedForExhibit(
          docId: doc.id,
          flyName: flyDoc[DbNames.flyName],
          flyDescription: flyDoc[DbNames.flyDescription],
          attrs: flyDoc[DbNames.attributes],
          mats: flyDoc[DbNames.materials],
          instr: flyDoc[DbNames.instructions],
          imageUris: flyDoc[DbNames.topLevelImageUris],
          flyFormTemplate: flyFormTemplateDoc,
        ),
      );
    }).toList();

    flies.addAll(flyExhibits);
    flies.removeWhere((fly) => fly is FlyExhibitLoadingIndicator);
    if (flyExhibits.isEmpty) flies.add(FlyExhibitEndCapIndicator());
    fliesStreamController.add(flies);
  }

  Stream<FlyExhibit> getFlyExhibit(String docId) {
    // Function defined within this scope to extract docId form list of flyExhibits
    // stored in FlyExhibitBloc class. Used when user clicks to see details on a
    //  fly exhibit.
    FlyExhibit extractFlyExhibit(List<FlyExhibit> flyExhibits) {
      return flyExhibits.firstWhere(
          (flyExhibit) => flyExhibit.fly.docId == docId,
          orElse: () => null);
    }

    if (flyDetailStreamController != null) flyDetailStreamController.close();

    flyDetailStreamController = StreamController<FlyExhibit>();

    // Setup flyDetailStream controller to emit whenever fliesStreamController
    // emits. For example, if user clicks 'Material on hand', user profile updates,
    //  which causes fliesStreamConroller to update, which then causes
    //  flyDetailStreamController to update, as defined here.
    fliesStreamController.stream.listen((flyExhibits) {
      flyDetailStreamController.add(extractFlyExhibit(flyExhibits));
    });

    flyDetailStreamController.add(extractFlyExhibit(flies));
    return flyDetailStreamController.stream;
  }

  void close() {
    _requestFetchFlies.close();
    requestFetchFliesSink.close();
    fliesStreamController.close();
    _favoritedFliesStreamController.close();
    favoritedFlySink.close();

    // _newestFlyDetailStreamController could be null if user never clicked
    // on a fly exhibit to see details/instructions.
    if (flyDetailStreamController != null) flyDetailStreamController.close();
  }
}
