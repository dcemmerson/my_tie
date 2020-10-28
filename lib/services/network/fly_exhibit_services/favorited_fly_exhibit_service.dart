/// filename: favorited_fly_exhibit_service.dart
/// last modified: 10/26/2020
/// description: This file contains app related communication with firestore
///   service related to user querying firestore to see flies they can tie.
///

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_tie/models/db_names.dart';

import 'fly_exhibit_service.dart';

class FavoritedFlyExhibitService extends FlyExhibitService {
  static const fliesPerFetch = 5;

  @override
  Future<QuerySnapshot> initGetCompletedFlies() {
    return FirebaseFirestore.instance
        .collection(DbCollections.fly)
        .orderBy(DbNames.lastModified, descending: true)
        .limit(5)
        .get();
  }

  @override
  Future<QuerySnapshot> getCompletedFliesByDateAfterDoc(
      DocumentSnapshot prevDoc) {
    return FirebaseFirestore.instance
        .collection(DbCollections.fly)
        .orderBy(DbNames.lastModified, descending: true)
        .limit(5)
        .startAfterDocument(prevDoc)
        .get();
  }
}