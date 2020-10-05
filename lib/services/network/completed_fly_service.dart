/// filename: completed_fly_service.dart
/// last modified: 10/04/2020
/// description: This file contains app related communication with firestore
///   service related to user querying firestore to see flies they can tie.
///

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';
import 'package:my_tie/models/db_names.dart';

class CompletedFlyService {
  Future<QuerySnapshot> getCompletedFliesByDate(String uid) {
    return FirebaseFirestore.instance
        .collection(DbCollections.fly)
        .orderBy(DbNames.lastModified, descending: true)
        .limit(20)
        .get();
  }
}
