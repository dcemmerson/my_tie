import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_tie/models/fly_exhibits/fly_exhibit.dart';
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
  }) : super(
            userBloc: userBloc,
            flyExhibitService: byMaterialsFlyExhibitService,
            flyFormTemplateService: flyFormTemplateService);

  /// name: initFliesFetch
  /// description: We must override this method from FlyExhibitBloc because
  ///   favorited flies are stored in a top level collection (for simple
  ///   querying functionallity). When we query Firestore for a user's
  ///   favorites (from the favorites collection), we only obtain fly stubs
  ///   and not the entire fly doc - thus we must query the fly collection with
  ///   the doc id obtained from each fly stub.
  @override
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

  void initFliesFetchPostMaterialReindex() async {
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
}
