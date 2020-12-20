import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_tie/bloc/fly_search_bloc.dart';
import 'package:my_tie/models/db_names.dart';
import 'package:my_tie/models/fly_exhibits/fly_exhibit.dart';
import 'package:my_tie/models/new_fly/fly.dart';
import 'package:my_tie/models/new_fly/new_fly_form_template.dart';
import 'package:my_tie/models/user_profile/user_materials_transfer.dart';
import 'package:my_tie/pages/tab_based_pages/tab_page.dart';
import 'package:my_tie/services/network/fly_exhibit_services/by_materials_fly_exhibit_service.dart';
import 'package:my_tie/services/network/fly_form_template_service.dart';

import '../user_bloc.dart';
import 'fly_exhibit_bloc.dart';

class ByMaterialsFlyExhibitBloc extends FlyExhibitBloc {
  final String exhibitBlocType = 'ByMaterialsFlyExhibitBloc';
  bool materialsReindexedSinceLastFetch = false;

  FlyExhibitType get flyExhibitType => FlyExhibitType.MaterialMatch;

  ByMaterialsFlyExhibitBloc({
    UserBloc userBloc,
    ByMaterialsFlyExhibitService byMaterialsFlyExhibitService,
    FlyFormTemplateService flyFormTemplateService,
    FlySearchBloc flySearchBloc,
  }) : super(
          userBloc: userBloc,
          flyExhibitService: byMaterialsFlyExhibitService,
          flyFormTemplateService: flyFormTemplateService,
          flySearchBloc: flySearchBloc,
        );

  /// name: initFliesFetch
  /// description: We must override this method from FlyExhibitBloc because
  ///   by materials flies are stored in a top level collection (for simple
  ///   querying functionallity).
  @override
  void initFliesFetch() async {
    materialsReindexedSinceLastFetch = false;

    final Future<QuerySnapshot> flyTemplateDocF =
        flyFormTemplateService.newFlyForm;
    final List<FlyExhibit> fliesFetched = [];
    final queryInit = await flyExhibitService.initGetCompletedFlies(
        uid: userBloc.authService.currentUser.uid);
    final flyFormTemplateDoc =
        NewFlyFormTemplate.fromDoc((await flyTemplateDocF).docs[0].data());
    List<FlyExhibit> lastFliesFetched =
        formatQueryAsFlyExhibits(queryInit, flyFormTemplateDoc);
    var prevFlyDocFetched = queryInit.docs[queryInit.docs.length - 1];
    var numberFetchedFlies = lastFliesFetched.length;
    stripRefetchedFlies(lastFliesFetched);
    fliesFetched.addAll(lastFliesFetched);

    while (fliesFetched.length < FlyExhibitBloc.flyFetchCount &&
        numberFetchedFlies > 0) {
      final query = await flyExhibitService.getCompletedFliesByDateAfterDoc(
          prevDoc: prevFlyDocFetched,
          uid: userBloc.authService.currentUser.uid);
      lastFliesFetched = formatQueryAsFlyExhibits(query, flyFormTemplateDoc);
      numberFetchedFlies = lastFliesFetched.length;

      if (lastFliesFetched.length > 0) {
        prevFlyDocFetched = query.docs[query.docs.length - 1];
        stripRefetchedFlies(lastFliesFetched);
        fliesFetched.addAll(lastFliesFetched);
      }
    }

    isFetching = false;
    prevFlyDoc = prevFlyDocFetched;
    sendToUI(fliesFetched);
  }

  /// name: fliesFetch
  /// description: We must override this method from FlyExhibitBloc for same
  ///   reason described in initFliesFetch.
  @override
  void fliesFetch() async {
    if (flies.length == 0) {
      initFliesFetch();
      return;
    }

    final Future<QuerySnapshot> flyTemplateDocF =
        flyFormTemplateService.newFlyForm;
    final flyFormTemplateDoc =
        NewFlyFormTemplate.fromDoc((await flyTemplateDocF).docs[0].data());

    final List<FlyExhibit> fliesFetched = [];
    var prevFlyDocFetched = flies[flies.length - 1].fly.doc;

    List<FlyExhibit> lastFliesFetched = [];

    var numberFetchedFlies = 0;

    // Use do-while loop here as we need to ensure we execute loop at minimum
    // one time.
    do {
      final query = await flyExhibitService.getCompletedFliesByDateAfterDoc(
          prevDoc: prevFlyDocFetched,
          uid: userBloc.authService.currentUser.uid);
      lastFliesFetched = formatQueryAsFlyExhibits(query, flyFormTemplateDoc);
      numberFetchedFlies = lastFliesFetched.length;

      if (lastFliesFetched.length > 0) {
        prevFlyDocFetched = query.docs[query.docs.length - 1];
        stripRefetchedFlies(lastFliesFetched);
        fliesFetched.addAll(lastFliesFetched);
      }
    } while (fliesFetched.length < FlyExhibitBloc.flyFetchCount &&
        numberFetchedFlies > 0);

    isFetching = false;
    prevFlyDoc = prevFlyDocFetched;
    sendToUI(fliesFetched);
  }

  //  name: stripRefetchedFlies
  //  description: Pass recently fetched flies to this method to compare
  //    list of fly exhibits to this.flies and remove any flies from fetchedFlies
  //    list that we already have contained in this.flies.
  void stripRefetchedFlies(List<FlyExhibit> fetchedFlies) {
    fetchedFlies.removeWhere((fetchedFlyExhibit) {
      // Note we are not using flies.contains here as this would require us
      // to override the == operator to correctly identify repeated fly exhibits
      // using document ids. This would be problematic in the UI as lists of
      // FlyExhibit are passed through streamcontrollers and interpreted by stream builders,
      // which use the equality operator to identify new items in the stream.
      return flies.fold(
          false,
          (value, currFlyExhibit) =>
              value || fetchedFlyExhibit.fly.docId == currFlyExhibit.fly.docId);
    });
  }

  /// We must override listenForUserMaterialProfileEvents from base class to
  /// correctly define behavior in the following scenario: user has scrolled
  /// to 'By Materials' tab, thus fetching some number of flies from Firestore.
  /// User then edits their materials on hand, thus changing which flies should
  /// be fetched next 'By Materials' fetch.
  /// To deal with this scenario, we set a flag materialsReindexedSinceLastFetch
  /// indicating that during the next flies fetch, we need to perform some
  /// extra work to select the correct flies.
  @override
  void listenForUserMaterialProfileEvents() {
    userBloc.userMaterialsProfile.listen((UserMaterialsTransfer umt) {
      materialsReindexedSinceLastFetch = true;
      super.updateFliesFromUserMaterialProfileEvent(umt);
    });
  }

  ///  Listen for fetch flies events being added to sink from UI (eg, when user
  ///  scrolls to bottom of screen and infinite scroll needs to load more
  ///  flies). First add the FlyExhibitLoadingIndicator, to tell UI to show
  ///  spinner, then call fliesFetch which will make request to db,
  ///  update flies, then add flies to fliesStreamController. We must override
  ///  this method in the ByMaterialsByExhibitBloc subclass so we can correctly
  ///  handle behavior of following situation: user tabs over to by materials tab
  ///  on ui, thus causing this bloc to request by materials fly fetch. User
  ///  then selects one or more materials they have on hand, followed by scrolling
  ///  to bottom of by materials tab, thus triggering another by materials fly
  ///  fetch. The underlying issue is that in this scenario, we can no longer
  ///  rely on the last fetched doc to be a reliable indicator of where we should
  ///  pick up from for the next by materials fly fetch, and instead we need to
  ///  go back through the ByMaterialsFlyExhibitBloc.initFliesFetch algorithm
  ///  to correctly select the next batch of flies from Firestore to show user.
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
        if (materialsReindexedSinceLastFetch) {
          initFliesFetch();
        } else {
          fliesFetch();
        }
      } else if (isFetching) {
        print('Received fetch request...ignoring - fetch in progress.');
      } else {
        // Unreachable, but you never know...
        throw Exception('event not found - unimplemented $ffe');
      }
    });
  }

  // We are overriding formatQueryAsFlyExhibits since by materials fly docs
  // are stored in separate top level collection, we need to insert the original
  // fly doc id in FlyExhibit.Fly so the favorite/unfavorite functionallity will
  // plug in correctly.
  @override
  List<FlyExhibit> formatQueryAsFlyExhibits(
      QuerySnapshot flyQueries, NewFlyFormTemplate flyFormTemplateDoc) {
    return flyQueries.docs.map((doc) {
      final flyDoc = doc.data();
      return FlyExhibit.fromUserProfileAndFly(
        flyExhibitType: flyExhibitType,
        userProfile: userProfile,
        fly: Fly.formattedForExhibit(
          docId: flyDoc[DbNames.originalFlyDocId],
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
}
