import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_tie/bloc/fly_search_bloc.dart';
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
import 'favoriting_bloc.dart';

/// Classes solely used to pass signals in stream controllers.
class FetchFliesEvent {}

class FetchNewestFliesEvent extends FetchFliesEvent {}

class FlyExhibitLoadingIndicator extends FlyExhibit {}

class FlyExhibitEndCapIndicator extends FlyExhibit {}

abstract class FlyExhibitBloc {
  static const flyFetchCount = 5;
  // Flags used to determine if we need to signal to the UI to add an end cap
  // indicator or
  bool isEndCapIndicator = false;
  bool isFetching = false;

  final UserBloc userBloc;
  final FavoritingBloc favoritingBloc;
  final FlySearchBloc flySearchBloc;

  final FlyExhibitService flyExhibitService;
  final FlyFormTemplateService flyFormTemplateService;

  final _favoritedFliesStreamController = StreamController<FlyExhibit>();
  StreamSink<FlyExhibit> _favoritedFlySink;
  final requestFetchFlies = StreamController<FetchFliesEvent>();
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

  // Define this in a getter so we can easily override in subclasses.
  StreamSink<FlyExhibit> get favoritedFlySink => _favoritedFlySink;

  // Define in getter here so our favorited fy exhibit bloc class can override this
  // and actually return List<FavoritedFlyExhibit>.

  FlyExhibitBloc({
    this.userBloc,
    this.flyExhibitService,
    this.flyFormTemplateService,
    this.flySearchBloc,
  }) : this.favoritingBloc = FavoritingBloc.sharedInstance {
    fliesStream = fliesStreamController.stream;
    fliesStreamController.onListen = fliesFetch;
    _favoritedFlySink = favoritingBloc.favoritedFlySink;
    // favoritedFlySink = _favoritedFliesStreamController.sink;
    requestFetchFliesSink = requestFetchFlies.sink;

    listenForUserMaterialProfileEvents();
    listenForRequestFliesFetch();
    // _listenForFavoritedFlyEvents();
  }

  /// Get userProfile, and listen for changes to userProfile. Update all FlyExhibit
  /// if upon changes to userProfile (materials on hand for each fly may change
  ///  when user profile is updated).
  void listenForUserMaterialProfileEvents() {
    userBloc.userMaterialsProfile
        .listen(updateFliesFromUserMaterialProfileEvent);
  }

  void updateFliesFromUserMaterialProfileEvent(UserMaterialsTransfer umt) {
    userProfile = umt.userProfile;

    flies = flies.map((FlyExhibit flyExhibit) {
      // if (flyExhibit is FlyExhibitEndCapIndicator)
      //   return FlyExhibitEndCapIndicator();
      return FlyExhibit.fromUserProfileAndFly(
        flyExhibitType: flyExhibitType,
        fly: flyExhibit.fly,
        userProfile: userProfile,
      );
    }).toList();

    List<FlyExhibit> fliesCopy = List.from(flies);

    if (isEndCapIndicator) fliesCopy.add(FlyExhibitEndCapIndicator());
    // else if (isLoadingIndicator) fliesCopy.add(FlyExhibitLoadingIndicator());

    fliesStreamController.add(fliesCopy);
  }

  /// name: initFliesFetch
  /// description: Used only for first call to Firestore to retrieve first 10
  ///   newest fly docs. This call initializes the prevNewestFlyDoc var, which
  ///   can then be used for subsequent calls to Firestore for additional fly
  ///   docs for newest fly exhibit, in an infinite scroll/fetch manner.
  void initFliesFetch() async {
    // First just add the FlyExhibitLoadingIndicator to stream so UI will know
    // to display a circular progress indicator.
    fliesStreamController.add([FlyExhibitLoadingIndicator()]);

    // Set isFetching true while we make fetch request,
    // which will prevent us from making excessive fetch calls to Firestore.
    isFetching = true;

    final Future<QuerySnapshot> flyTemplateDocF =
        flyFormTemplateService.newFlyForm;
    final Future<QuerySnapshot> queryF =
        flyExhibitService.initGetCompletedFlies(uid: userProfile.uid);

    // No need to use Future.wait, as query depeneds on flyFormTemplate.
    final flyFormTemplateDoc =
        NewFlyFormTemplate.fromDoc((await flyTemplateDocF).docs[0].data());
    final flyQueries = await queryF;

    isFetching = false;
    setPrevDoc(flyQueries);
    formatAndSendFliesToUI(flyQueries, flyFormTemplateDoc);
  }

  /// Listen for fetch flies events being added to sink from UI (eg, when user
  ///  scrolls to bottom of screen and infinite scroll needs to load more
  ///  flies). First add the FlyExhibitLoadingIndicator, to tell UI to show
  ///  spinner, then call fliesFetch which will make request to db,
  ///  update flies, then add flies to fliesStreamController.
  void listenForRequestFliesFetch() {
    requestFetchFlies.stream.listen((ffe) {
      if (ffe is FetchNewestFliesEvent && !isFetching) {
        final List<FlyExhibit> fliesCopy = List.from(flies);

        // Add the FlyExhibitLoadingIndicator to our copied list of FlyExhibit and
        // add this to the fliesStreamController, which indicates to the UI to display
        // a loading indicator while we are fetching the next batch of flies.
        fliesCopy.add(FlyExhibitLoadingIndicator());
        isFetching = true;

        fliesStreamController.add(fliesCopy);
        fliesFetch();
      } else if (isFetching) {
        print('Received fetch request...ignoring - fetch in progress.');
      } else {
        // Unreachable, but you never know...
        throw Exception('event not found - unimplemented $ffe');
      }
    });
  }

  void fliesFetch() async {
    if (flies.length == 0) {
      // Always check if flies.length is 0 because there are two scenarios where
      // this condition is true:
      // 1. When fliesStreamController is first listened to.
      //    - Caveat: under favorites tab, the first time fliesStreamController is
      //      listened to, there is possibility that flies.length != 0. This can
      //      occur if user presses "favorite" button, before navigating to the
      //      favorite flies tab.
      // 2. User must have "unliked" all favorited flies since last fetch, meaning
      //    we no longer have a prevDoc to rely on to use in the next query. This
      //    condition is only a concern if this FlyExhibitBloc is a
      //    FavoritedFlyExhibitBloc.
      initFliesFetch();
      return;
    }

    final Future<QuerySnapshot> flyTemplateDocF =
        flyFormTemplateService.newFlyForm;
    final Future<QuerySnapshot> queryF =
        flyExhibitService.getCompletedFliesByDateAfterDoc(
            uid: userProfile.uid, prevDoc: prevFlyDoc);

    // No need to use Future.wait, as query depeneds on flyFormTemplate.
    final flyFormTemplateDoc =
        NewFlyFormTemplate.fromDoc((await flyTemplateDocF).docs[0].data());
    final flyQueries = await queryF;

    isFetching = false;
    setPrevDoc(flyQueries);
    formatAndSendFliesToUI(flyQueries, flyFormTemplateDoc);
  }

  /// Listen for events being dispatched from UI, added to favoritedFlySink,
  /// representing user selecting/deselecting the favorite fly button. FlyExhibit
  /// is added to sink and we either add or remove docId from user's favorited
  /// fly list in db. Additionally, we must update the favorited flies
  /// collection (which denormalizes fly docs to enable querying on the user's
  /// favorited flies).
  // void _listenForFavoritedFlyEvents() {
  //   _favoritedFliesStreamController.stream.listen((flyExhibit) {
  //     if (flyExhibit.isFavorited) {
  //       userBloc.removeFromFavorites(
  //           flyExhibit.userProfile.docId, flyExhibit.fly.docId);
  //       flyExhibitService.removeFavoriteFly(
  //           userProfile.uid, flyExhibit.fly.docId);
  //     } else {
  //       userBloc.addToFavorites(
  //           flyExhibit.userProfile.docId, flyExhibit.fly.docId);
  //       flyExhibitService.addFavoriteFly({
  //         DbNames.uid: userProfile.uid,
  //         DbNames.originalFlyDocId: flyExhibit.fly.docId,
  //         ...flyExhibit.fly.toMap()
  //       });
  //     }
  //   });
  // }

  void setPrevDoc(QuerySnapshot flyQueries) {
    if (flyQueries.docs.length > 0)
      prevFlyDoc = flyQueries.docs[flyQueries.docs.length - 1];
  }

  void formatAndSendFliesToUI(
      QuerySnapshot flyQueries, NewFlyFormTemplate flyFormTemplateDoc) async {
    final List<FlyExhibit> flyExhibits =
        formatQueryAsFlyExhibits(flyQueries, flyFormTemplateDoc);
    sendToUI(flyExhibits);
  }

  void sendToUI(List<FlyExhibit> flyExhibits) {
    flies.addAll(flyExhibits);
    final List<FlyExhibit> fliesCopy = List.from(flies);
    // flies.removeWhere((fly) => fly is FlyExhibitLoadingIndicator);
    if (flyExhibits.isEmpty) {
      isEndCapIndicator = true;
      fliesCopy.add(FlyExhibitEndCapIndicator());
    }
    fliesStreamController.add(fliesCopy);

    // In addition to sending fly exhibits to UI, we also need to add these
    // recently fetched fly exhibits to the flySearchBloc to ensure the
    // recently fetched flies are available when user searches for a fly.
    flySearchBloc.addFliesExhibits(flyExhibits);
  }

  List<FlyExhibit> formatQueryAsFlyExhibits(
      QuerySnapshot flyQueries, NewFlyFormTemplate flyFormTemplateDoc) {
    return flyQueries.docs.map((doc) {
      final flyDoc = doc.data();
      return FlyExhibit.fromUserProfileAndFly(
        flyExhibitType: flyExhibitType,
        userProfile: userProfile,
        fly: Fly.formattedForExhibit(
          docId: doc.id,
          doc: doc,
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
  }

  // name: getFlyExhibit
  // description: Used when user taps on fly exhibit, to show the user the entire
  //  fly details with instructions included.
  Stream<FlyExhibit> getFlyExhibit(String docId) {
    // extractFlyExhibit function defined within this scope to extract docId form
    // list of flyExhibits stored in FlyExhibitBloc class. Used when user
    // clicks to see details on a fly exhibit.
    FlyExhibit extractFlyExhibit(List<FlyExhibit> flyExhibits) {
      // Note that flyExhibit could be instance of FlyExhibitEndCapIndicator or
      // FlyExhibitLoadingIndicator, which are both subclasses of FlyExhibit. Hence,
      // we need the '?' in flyExhibit.fly?.docId as flyExhibit.fly very well
      // might turn up null;
      return flyExhibits.firstWhere(
          (flyExhibit) => flyExhibit.fly?.docId == docId,
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
    requestFetchFlies.close();
    requestFetchFliesSink.close();
    fliesStreamController.close();
    _favoritedFliesStreamController.close();
    _favoritedFlySink.close();

    // _newestFlyDetailStreamController could be null if user never clicked
    // on a fly exhibit to see details/instructions.
    if (flyDetailStreamController != null) flyDetailStreamController.close();
  }
}
