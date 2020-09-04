import 'dart:io';

/// filename: new_fly_service.dart
/// last modified: 09/03/2020
/// description: This file contains app related communication with firestore
///   service related to user adding a new fly to db. Functionallity provided
///   includes adding attributes, materials, and instructions to fly.
///
///   Note that firestore security permits user to only read/write a doc in
///   'fly_in_progress' collection whose id corresponds to the logged in user id.

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';
import 'package:my_tie/models/db_names.dart';

class NewFlyService {
  static const _flyInProgress = 'fly_in_progress';
  static const _instructions = 'instructions';

  Stream<DocumentSnapshot> getFlyInProgressDocStream(String uid) {
    return FirebaseFirestore.instance
        .collection(_flyInProgress)
        .doc(uid)
        .snapshots();
  }

  Future addFlyInProgressMaterial({
    String uid,
    String name,
    Map<String, String> properties,
  }) async {
    return FirebaseFirestore.instance.collection(_flyInProgress).doc(uid).set(
      {
        'materials': {
          name: FieldValue.arrayUnion([properties]),
        }
      },
      SetOptions(merge: true),
    );
  }

  Future deleteFlyInProgressMaterial({
    String uid,
    String name,
    Map<String, String> properties,
  }) async {
    return FirebaseFirestore.instance.collection(_flyInProgress).doc(uid).set(
      {
        'materials': {
          name: FieldValue.arrayRemove([properties]),
        }
      },
      SetOptions(merge: true),
    );
  }

  Future addNewFlyAttributes({
    String uid,
    Map<String, String> attributes,
    String flyName,
  }) {
    final Map<String, dynamic> flyInProgress = {
      'attributes': attributes,
    };

    if (flyName != null) flyInProgress[DbNames.flyName] = flyName;

    return FirebaseFirestore.instance
        .collection(_flyInProgress)
        .doc(uid)
        .set(flyInProgress, SetOptions(merge: true));
  }

  // Fly in progress instruction related.
  Stream<QuerySnapshot> getFlyInProgressInstructionStep(
      String uid, int stepNumber) {
    return FirebaseFirestore.instance
        .collection(_flyInProgress)
        .doc(uid)
        .collection(_instructions)
        .where(DbNames.instructionStep, isEqualTo: stepNumber)
        .snapshots();
  }

  Future addNewFlyInstruction({
    String uid,
    String title,
    String description,
    int stepNumber,
    List<File> images,
  }) async {
    var uuid = Uuid();
    final StorageReference ref = FirebaseStorage().ref();

    // Generate random identifiers for each file, get references to these in
    //  storage, then put corresponding file at that reference.
    final List<FileUpload> uploadTasks = images.map((image) {
      StorageReference indRef = ref.child(uuid.v4());
      return FileUpload(
        ref: indRef,
        task: indRef.putFile(image, StorageMetadata(contentLanguage: 'en')),
      );
    }).toList();

    // Wait until all files have been uploaded.
    await Future.wait(
        uploadTasks.map((uploadTask) => uploadTask.task.onComplete).toList());

    // Now obtain the uri associated with each file we just put in storage.
    final List<String> uris = await Future.wait(uploadTasks
        .map((uploadTask) =>
            (uploadTask.ref.getDownloadURL().then((dyn) => dyn.toString())))
        .toList());

    // Now update fly in progress doc in firestore.
    FirebaseFirestore.instance
        .collection(_flyInProgress)
        .doc(uid)
        .collection('instructions')
        .add({
      DbNames.instructionStep: stepNumber,
      DbNames.instructionTitle: title,
      DbNames.instructionDescription: description,
      DbNames.instructionImageUris: uris,
    });

    // List<String> uris = uploadTasks.map((task) => task)
    // return FirebaseFirestore.instance.collection(_flyInProgress).doc(uid);
  }
}

class FileUpload {
  final StorageReference ref;
  final StorageUploadTask task;

  FileUpload({this.ref, this.task});
}
