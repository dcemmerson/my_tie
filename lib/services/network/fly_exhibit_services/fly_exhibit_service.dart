/// filename: fly_exhibit_service.dart
/// last modified: 10/04/2020
/// description: This file contains app related communication with firestore
///   service related to user querying firestore to see flies they can tie.
///

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_tie/models/db_names.dart';

abstract class FlyExhibitService {
  // flyCollectionDocId should correspond to fly's doc id found in the fly collection,
  // not the favorited_flies collection.
  Future<QuerySnapshot> getFavoritedFlyDoc(String flyCollectionDocId) {
    return FirebaseFirestore.instance
        .collection(DbCollections.favoritedFlies)
        .where(DbNames.originalFlyDocId, isEqualTo: flyCollectionDocId)
        .get();
  }

  Future<DocumentSnapshot> getFlyDoc(String docId) {
    return FirebaseFirestore.instance
        .collection(DbCollections.fly)
        .doc(docId)
        .get();
  }

  /// name: removeFavoriteFly
  /// description: Method that gets called upon user untapping the like/heart button
  ///   on a fly exhibit. All fly exhibit sort types (eg by materials, newest,
  ///   favorites), as need access to this functionallity, so we define this in
  ///   the FlyExhibitService base class.
  Future removeFavoriteFly(String uid, String originalFlyDocId) async {
    final query = await FirebaseFirestore.instance
        .collection(DbCollections.favoritedFlies)
        .where(DbNames.uid, isEqualTo: uid)
        .where(DbNames.originalFlyDocId, isEqualTo: originalFlyDocId)
        .get();

    return Future.wait(query.docs.map((doc) => doc.reference.delete()));
  }

  /// name: addFavoriteFly
  /// description: Method that gets called upon user tapping the like/heart button
  ///   on a fly exhibit. All fly exhibit sort types (eg by materials, newest,
  ///   favorites), as need access to this functionallity, so we define this in
  ///   the FlyExhibitService base class.
  Future addFavoriteFly(Map<String, dynamic> fly) {
    return FirebaseFirestore.instance
        .collection(DbCollections.favoritedFlies)
        .add({...fly, DbNames.dateFavorited: DateTime.now()});
  }

  // We define function bodies in all of the following functions as all sub
  // classes do not necessarily need to define implementations of each method.
  Future<QuerySnapshot> initGetCompletedFlies({String uid}) {
    throw Exception('unimplmented: initGetCompletedFlies');
  }

  Stream<QuerySnapshot> initGetCompletedFliesStream({String uid}) {
    throw Exception('unimplmented: initGetCompletedFliesStream');
  }

  Future<QuerySnapshot> getCompletedFliesByDateAfterDoc(
      {String uid, DocumentSnapshot prevDoc}) {
    throw Exception('unimplmented: getCompletedFliesByDateAfterDoc');
  }

  Stream<QuerySnapshot> getCompletedFliesStreamByDateAfterDoc(
      {String uid, DocumentSnapshot prevDoc}) {
    throw Exception('unimplmented: getCompletedFliesStreamByDateAfterDoc');
  }

  Stream<QuerySnapshot> getCompletedXFliesStream({String uid, int count = 5}) {
    throw Exception('unimplmented: getCompletedFliesStreamByDateAfterDoc');
  }
}
