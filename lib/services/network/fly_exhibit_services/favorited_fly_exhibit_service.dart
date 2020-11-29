/// filename: favorited_fly_exhibit_service.dart
/// last modified: 10/26/2020
/// description: This file contains app related communication with firestore
///   service related to user querying firestore to see flies they can tie.
///

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_tie/bloc/fly_exhibit_bloc/fly_exhibit_bloc.dart';
import 'package:my_tie/models/db_names.dart';

import 'fly_exhibit_service.dart';

class FavoritedFlyExhibitService extends FlyExhibitService {
  /// name: initCompletedFliesByDate
  /// description: function use by stream controller triggered by UI, when user
  ///   scrolls to bottom of page. Aux to initGetCompletedFlies().
  @override
  Future<QuerySnapshot> initGetCompletedFlies(
      {String uid, int flyFetchCount = FlyExhibitBloc.flyFetchCount}) {
    return FirebaseFirestore.instance
        .collection(DbCollections.favoritedFlies)
        .where(DbNames.uid, isEqualTo: uid)
        .orderBy(DbNames.dateFavorited, descending: true)
        .limit(flyFetchCount)
        .get();
  }

  /// name: getCompletedFliesByDateAfterDoc
  /// description: function use by stream controller triggered by UI, when user
  ///   scrolls to bottom of page. Aux to initGetCompletedFlies().
  @override
  Future<QuerySnapshot> getCompletedFliesByDateAfterDoc(
      {String uid,
      DocumentSnapshot prevDoc,
      int flyFetchCount = FlyExhibitBloc.flyFetchCount}) {
    return FirebaseFirestore.instance
        .collection(DbCollections.favoritedFlies)
        .orderBy(DbNames.dateFavorited, descending: true)
        .where(DbNames.uid, isEqualTo: uid)
        .limit(flyFetchCount)
        .startAfterDocument(prevDoc)
        // .startAfterDocument(prevDoc)
        .get();
  }
}
