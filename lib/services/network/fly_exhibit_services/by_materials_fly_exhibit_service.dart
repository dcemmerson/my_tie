/// filename: by_materials_fly_exhibit_service.dart
/// last modified: 10/04/2020
/// description: This file contains app related communication with firestore
///   service related to user querying firestore to see flies they can tie.
///

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_tie/bloc/fly_exhibit_bloc/fly_exhibit_bloc.dart';
import 'package:my_tie/models/db_names.dart';

import 'fly_exhibit_service.dart';

class ByMaterialsFlyExhibitService extends FlyExhibitService {
  @override
  Future<QuerySnapshot> initGetCompletedFlies(
      {String uid, int flyFetchCount = FlyExhibitBloc.flyFetchCount}) {
    return FirebaseFirestore.instance
        .collection(DbCollections.byMaterialsFlies)
        .where('uid', isEqualTo: uid)
        .orderBy(DbNames.materialsOnHandCount, descending: true)
        .limit(flyFetchCount)
        .get();
  }

  // @override
  // Future<QuerySnapshot> initGetCompletedFlies({String uid}) {
  //   return FirebaseFirestore.instance
  //       .collection(DbCollections.fly)
  //       .orderBy(DbNames.lastModified, descending: true)
  //       .limit(5)
  //       .get();
  // }

  /// name: getCompletedFliesByDateAfterDoc
  /// description: function use by stream controller triggered by UI, when user
  ///   scrolls to bottom of page. Aux to initGetCompletedFlies().
  @override
  Future<QuerySnapshot> getCompletedFliesByDateAfterDoc(
      {String uid,
      DocumentSnapshot prevDoc,
      int flyFetchCount = FlyExhibitBloc.flyFetchCount}) {
    return FirebaseFirestore.instance
        .collection(DbCollections.byMaterialsFlies)
        .where('uid', isEqualTo: uid)
        .orderBy(DbNames.materialsOnHandCount, descending: true)
        .limit(flyFetchCount)
        .startAfterDocument(prevDoc)
        .get();
  }
}
