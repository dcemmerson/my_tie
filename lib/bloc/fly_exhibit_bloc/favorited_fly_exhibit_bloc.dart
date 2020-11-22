import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_tie/models/db_names.dart';
import 'package:my_tie/models/fly_exhibits/favorited_fly_exhibit.dart';
import 'package:my_tie/models/fly_exhibits/fly_exhibit.dart';
import 'package:my_tie/models/new_fly/fly.dart';
import 'package:my_tie/models/new_fly/new_fly_form_template.dart';
import 'package:my_tie/models/user_profile/user_materials_transfer.dart';
import 'package:my_tie/pages/tab_based_pages/tab_page.dart';
import 'package:my_tie/services/network/fly_exhibit_services/favorited_fly_exhibit_service.dart';
import 'package:my_tie/services/network/fly_form_template_service.dart';

import '../user_bloc.dart';
import 'fly_exhibit_bloc.dart';

class FavoritedFlyExhibitBloc extends FlyExhibitBloc {
  int flyRequestCount = 0;
  int flyFetchCount = 0;

  // final List<QueryDocumentSnapshot> favoriteDocs = [];
  final String exhibitBlocType = 'FavoritedFlyExhibitBloc';

  FlyExhibitType get flyExhibitType => FlyExhibitType.Favorites;

  // We need to override the getter for favoritedFlySink in the
  // FavoritedFlyExhibitBloc specifically because
  // @override
  // StreamSink<FlyExhibit> get favoritedFlySink => null;

  FavoritedFlyExhibitBloc({
    UserBloc userBloc,
    FlyFormTemplateService flyFormTemplateService,
    FavoritedFlyExhibitService favoritedFlyExhibitService,
  }) : super(
            userBloc: userBloc,
            flyExhibitService: favoritedFlyExhibitService,
            flyFormTemplateService: flyFormTemplateService) {
    favoritingBloc.favoritedFliesStreamController.stream
        .listen(_handleFlyExhibitFavorited);
  }

  void _handleFlyExhibitFavorited(FlyExhibit flyExhibit) {
    // if (flyExhibit.isFavorited) {
    //   // This means the flyExhibit on UI was previously favorited and user
    //   // probably tapped the heart to unfavorite this flyExhibit, so we need
    //   // to search through out flyExhibits in parent class and mark for removal,
    //   // if this flyExhibit exists in our flyExhibits in parent class.
    //   flies.removeWhere((flyEx) => flyEx.fly?.docId == flyExhibit.fly.docId);
    //   // favoriteDocs.removeWhere((doc) => doc.id == flyExhibit.fly.docId);
    //   fliesStreamController.add(flies);
    //   // });
    // } else {
    //   // User probably tapped to favorite a fly exhibit, meaning we need to add
    //   // the favorited fly exhibit to the top of the parent classes flyExhibits
    //   // and update stream.
    //   flies.insert(
    //       0,
    //       FlyExhibit.fromFlyExhibit(flyExhibit,
    //           flyExhibitType: FlyExhibitType.Favorites, favorited: true));
    //   // tallyFavoritedFliesDocs(flyExhibit);
    //   fliesStreamController.add(flies);
    // }
  }

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
    // fliesStreamController.add([FlyExhibitLoadingIndicator()]);

    final Future<QuerySnapshot> flyTemplateDocF =
        flyFormTemplateService.newFlyForm;
    final Future<QuerySnapshot> queryF =
        flyExhibitService.initGetCompletedFlies(uid: userProfile.uid);

    awaitFormatAndSendToUI(queryF, flyTemplateDocF);
  }

  /// name: fliesFetch
  /// description: We must override this method from FlyExhibitBloc for same
  ///   reason described in initFliesFetch.
  @override
  void fliesFetch() async {
    if (flies.length == 0) {
      // User must have "unliked" all favorited flies since last fetch, meaning
      // we no longer have a prevDoc to rely on to use in the next query. In this
      // case, we can just simply call initFliesFetch and return.
      initFliesFetch();
      return;
    }
    final Future<QuerySnapshot> flyTemplateDocF =
        flyFormTemplateService.newFlyForm;
    final Future<QuerySnapshot> queryF =
        flyExhibitService.getCompletedFliesByDateAfterDoc(
            uid: userProfile.uid,
            prevDoc: (flies[flies.length - 1] as FavoritedFlyExhibit).doc);

    awaitFormatAndSendToUI(queryF, flyTemplateDocF);
  }

  void awaitFormatAndSendToUI(Future<QuerySnapshot> queryF,
      Future<QuerySnapshot> flyTemplateDocF) async {
    // No need to use Future.wait, as query depeneds on flyFormTemplate.
    final flyFormTemplateDoc =
        NewFlyFormTemplate.fromDoc((await flyTemplateDocF).docs[0].data());
    final flyQueries = await queryF;

    // Add all the QueryDocumentSnapshot to our favoriteDocs list so we can
    // keep track of what docs we have already shown user and know where to
    // start the next query, when user scrolls to bottom of favorites page.
    // favoriteDocs.addAll(flyQueries.docs);
    final favoritedFlyExhibits =
        await Future.wait(flyQueries.docs.map((favoritedFlyDoc) {
      return flyExhibitService
          .getFlyDoc(favoritedFlyDoc.data()[DbNames.originalFlyDocId])
          .then((doc) {
        final flyDoc = doc.data();

        return FavoritedFlyExhibit(
          doc: favoritedFlyDoc,
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
          userProfile: userProfile,
        );
      });
    }).toList());

    isFetching = false;

    // setPrevDoc(flyQueries);
    updateFliesAndSendToUI(favoritedFlyExhibits);
  }

  void updateFliesAndSendToUI(List<FavoritedFlyExhibit> flyExhibits) {
    flies.addAll(flyExhibits);

    final List<FlyExhibit> fliesCopy = List.from(flies);
    if (flyExhibits.isEmpty) {
      print('addng end cap indicator');
      isEndCapIndicator = true;
      fliesCopy.add(FlyExhibitEndCapIndicator());
    }
    print('send fliesCopy to ui for favorites');
    fliesStreamController.add(fliesCopy);
  }
}
