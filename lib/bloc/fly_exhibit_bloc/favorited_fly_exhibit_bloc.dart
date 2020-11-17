import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_tie/models/db_names.dart';
import 'package:my_tie/models/fly_exhibits/fly_exhibit.dart';
import 'package:my_tie/models/new_fly/fly.dart';
import 'package:my_tie/models/new_fly/new_fly_form_template.dart';
import 'package:my_tie/pages/tab_based_pages/tab_page.dart';
import 'package:my_tie/services/network/fly_exhibit_services/favorited_fly_exhibit_service.dart';
import 'package:my_tie/services/network/fly_form_template_service.dart';

import '../user_bloc.dart';
import 'fly_exhibit_bloc.dart';

class FavoritedFlyExhibitBloc extends FlyExhibitBloc {
  int flyRequestCount = 0;
  int flyFetchCount = 0;

  final String exhibitBlocType = 'FavoritedFlyExhibitBloc';

  FlyExhibitType get flyExhibitType => FlyExhibitType.Favorites;

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
    if (flyExhibit.isFavorited) {
      // This means the flyExhibit on UI was previously favorited and user
      // probably tapped the heart to unfavorite this flyExhibit, so we need
      // to search through out flyExhibits in parent class and mark for removal,
      // if this flyExhibit exists in our flyExhibits in parent class.
      final List<FlyExhibit> updatedFlyExhibitsWillRemove = flies.map((flyEx) {
        if (flyEx.fly?.docId == flyExhibit.fly.docId) {
          flyEx.willBeRemoved = true;
        }
        return flyEx;
      }).toList();
      flies = updatedFlyExhibitsWillRemove;
      fliesStreamController.add(flies);

      Timer(Duration(seconds: 3), () {
        final List<FlyExhibit> updatedFlyExhibitsRemoved = flies.map((flyEx) {
          if (flyEx.fly?.docId == flyExhibit.fly.docId) {
            flyEx.isRemoved = true;
          }
          return flyEx;
        }).toList();

        flies = updatedFlyExhibitsRemoved;
        fliesStreamController.add(flies);
      });
    } else {
      // User probably tapps to favorite a fly exhibit, meaning we need to add
      // the favorited fly exhibit to the top of the parent classes flyExhibits
      // and update stream.
      flies.insert(0, flyExhibit);
      fliesStreamController.add(flies);
    }
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
    final Future<QuerySnapshot> flyTemplateDocF =
        flyFormTemplateService.newFlyForm;
    final Future<QuerySnapshot> queryF =
        flyExhibitService.initGetCompletedFlies(uid: userProfile.uid);

    // No need to use Future.wait, as query depeneds on flyFormTemplate.
    final flyFormTemplateDoc =
        NewFlyFormTemplate.fromDoc((await flyTemplateDocF).docs[0].data());
    final flyQueries = await queryF;

    final flyDocs = await Future.wait(flyQueries.docs.map((query) {
      return flyExhibitService
          .getFlyDoc(query.data()[DbNames.originalFlyDocId]);
    }).toList());

    setPrevDoc(flyQueries);
    formatDocSnapshotsAndSendFliesToUI(flyDocs, flyFormTemplateDoc);
  }

  /// name: fliesFetch
  /// description: We must override this method from FlyExhibitBloc for same
  ///   reason described in initFliesFetch.
  @override
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

    final flyDocs = await Future.wait(flyQueries.docs.map((query) {
      return flyExhibitService
          .getFlyDoc(query.data()[DbNames.originalFlyDocId]);
    }).toList());

    setPrevDoc(flyQueries);
    formatDocSnapshotsAndSendFliesToUI(flyDocs, flyFormTemplateDoc);
  }

  // @override
  // void fliesFetch() async {
  //   if (flyFetchCount == flyRequestCount) {
  //     flyRequestCount += 5;
  //     print('flyCount = ' + flyRequestCount.toString());

  //     favoritedFliesStream = flyExhibitService.getCompletedXFliesStream(
  //         uid: userProfile.uid, count: flyRequestCount);
  //     final Future<QuerySnapshot> templateDocF =
  //         flyFormTemplateService.newFlyForm;
  //     final flyFormTemplateDoc =
  //         NewFlyFormTemplate.fromDoc((await templateDocF).docs[0].data());

  //     favoritedFliesStream.listen((flyQueries) async {
  //       print('init flies fetch emitting');
  //       final flyDocs = await Future.wait(flyQueries.docs.map((query) {
  //         return flyExhibitService
  //             .getFlyDoc(query.data()[DbNames.originalFlyDocId]);
  //       }).toList());

  //       flyFetchCount = flyQueries.docs.length;

  //       formatDocSnapshotsAndSendFliesToUI(flyDocs, flyFormTemplateDoc);
  //     });
  //   } else {
  //     flies.removeWhere((fly) => fly is FlyExhibitLoadingIndicator);
  //     if (!flies.contains((fly) => fly is FlyExhibitEndCapIndicator)) {
  //       flies.add(FlyExhibitEndCapIndicator());
  //     }
  //     fliesStreamController.add(flies);
  //   }
  // }

  void formatDocSnapshotsAndSendFliesToUI(List<DocumentSnapshot> flyDocs,
      NewFlyFormTemplate flyFormTemplateDoc) async {
    // final UserMaterialsTransfer userMaterials =
    //     await userBloc.userMaterialsProfile.first;

    // userService.getUserProfile(authService.currentUser.uid);

    final List<FlyExhibit> flyExhibits = flyDocs.map((doc) {
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
}
