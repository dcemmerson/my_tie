/// filename: completed_fly_service.dart
/// last modified: 10/04/2020
/// description: This file contains app related communication with firestore
///   service related to user querying firestore to see flies they can tie.
///

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_tie/models/db_names.dart';

class FlyExhibitService {
  static const fliesPerFetch = 5;

  Future<QuerySnapshot> initGetCompletedFliesByDate() {
    return FirebaseFirestore.instance
        .collection(DbCollections.fly)
        .orderBy(DbNames.lastModified, descending: true)
        .limit(5)
        .get();
  }

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
