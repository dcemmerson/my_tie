import 'dart:async';

import 'package:algolia/algolia.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_tie/algolia/algolia_app.dart';
import 'package:my_tie/bloc/user_bloc.dart';
import 'package:my_tie/misc/debounce.dart';
import 'package:my_tie/models/db_names.dart';
import 'package:my_tie/models/fly_exhibits/fly_exhibit.dart';
import 'package:my_tie/models/new_fly/fly.dart';
import 'package:my_tie/models/new_fly/new_fly_form_template.dart';
import 'package:my_tie/models/user_profile/user_materials_transfer.dart';
import 'package:my_tie/models/user_profile/user_profile.dart';
import 'package:my_tie/services/network/fly_form_template_service.dart';
import 'package:rxdart/subjects.dart';

/// filename: fly_search_bloc.dart
/// last modified: 12/13/2020
/// description: BLoC responsible for handling fly searches coming
///   from the UI. This class uses the debounce class when handling
///   user keyboard input events coming from UI to prevent excess
///   search result calls.

class FlySearchBloc {
  final Algolia algolia = AlgoliaApp.algolia;
  final UserBloc userBloc;
  final FlyFormTemplateService flyFormTemplateService;

  final filteredFliesStreamController =
      BehaviorSubject<List<FlyExhibit>>(seedValue: []);

  final _searchTermStreamController = StreamController<String>();
  StreamSink<String> flySearchTermSink;

  final List<FlyExhibit> flyExhibits = [];

  String currSearchTerm = '';
  UserProfile userProfile;

  // We pass in a list of the flies streams that are used for the fly exhibit
  // bloc part of the app.
  FlySearchBloc({this.userBloc, this.flyFormTemplateService}) {
    flySearchTermSink = _searchTermStreamController.sink;

    _searchTermStreamController.stream
        .listen(Debounce(Duration(milliseconds: 350), _handleSearches)());
    userBloc.userMaterialsProfile
        .listen((UserMaterialsTransfer umt) => userProfile = umt.userProfile);
  }

  void addFliesExhibits(List<FlyExhibit> fliesIncoming) {
    fliesIncoming.forEach((flyIncoming) {
      final existingFlyIndex = flyExhibits.indexWhere(
          (flyExhibit) => flyExhibit.fly.docId == flyIncoming.fly.docId);
      if (existingFlyIndex == -1) {
        flyExhibits.add(flyIncoming);
      }
    });
  }

  void _handleSearches([String searchTerm]) async {
    if (searchTerm != null) {
      currSearchTerm = searchTerm;
    }

    if (currSearchTerm.length > 0) {
      final filteredFlyExhibits = flyExhibits
          .where((flyExhibit) => flyExhibit.containsTerm(currSearchTerm))
          .toList();
      filteredFliesStreamController.add(filteredFlyExhibits);

      AlgoliaQuery query =
          algolia.instance.index('flies').setHitsPerPage(10).search(searchTerm);
      AlgoliaQuerySnapshot snap = await query.getObjects();

      final Future<QuerySnapshot> flyTemplateDocF =
          flyFormTemplateService.newFlyForm;
      final flyFormTemplate =
          NewFlyFormTemplate.fromDoc((await flyTemplateDocF).docs[0].data());

      // Filter down the hit results to only
      final hits = snap.hits
          // .where((hit) => !flyExhibits.fold(
          // false,
          // (prev, currExhibit) =>
          // prev || (currExhibit.fly.docId == hit.data['objectID'])))
          .map((hit) {
        final algoliaDoc = hit.data;
        return FlyExhibit.fromUserProfileAndFly(
          // doc: favoritedFlyDoc,
          fly: Fly.formattedForExhibit(
            docId: algoliaDoc['objectID'],
            // doc: doc,
            flyName: algoliaDoc[DbNames.flyName],
            flyDescription: algoliaDoc[DbNames.flyDescription],
            attrs: algoliaDoc[DbNames.attributes],
            mats: algoliaDoc[DbNames.materials],
            instr: algoliaDoc[DbNames.instructions],
            imageUris: algoliaDoc[DbNames.topLevelImageUris],
            flyFormTemplate: flyFormTemplate,
          ),
          userProfile: userProfile,
        );
      }).toList();
      filteredFliesStreamController.add(hits);
    }
  }

  void close() {
    _searchTermStreamController.close();
    flySearchTermSink.close();
  }
}
