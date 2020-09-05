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

  Future<List<String>> addFilesToStorage(
      {String uid, List<File> images}) async {
    final uuid = Uuid();
    final StorageReference ref = FirebaseStorage().ref().child(uid);

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
    await Future.wait(uploadTasks
            .map((uploadTask) => uploadTask.task.onComplete)
            .toList())
        .catchError((err) => print(err));

    // Now return the future that will resolve to a list of the uri strings.
    return Future.wait(uploadTasks
            .map((uploadTask) =>
                (uploadTask.ref.getDownloadURL().then((dyn) => dyn.toString())))
            .toList())
        .catchError((err) => print(err));
  }

  // Future deleteFilesInStorage({String uid, List<String> imageUris}) {
  //   final StorageReference ref = FirebaseStorage().ref().child(uid);

  //   final List<Future> deleteTasks = imageUris.map((imageUri) {
  //     StorageReference indRef = ref.child(imageUri);
  //     return indRef.delete();
  //   }).toList();

  //   return Future.wait(deleteTasks).catchError((err) => print(err));
  // }

  Future addNewFlyInstruction({
    String uid,
    String title,
    String description,
    int stepNumber,
    List<String> imageUris,
  }) {
    // Now update fly in progress doc in firestore.
    return FirebaseFirestore.instance
        .collection(_flyInProgress)
        // .doc(uid)
        // .collection('instructions')
//        .where(DbNames.instructionStep, isEqualTo: stepNumber)
        .doc(uid)
        .set(
      {
        DbNames.instructions: {
          stepNumber.toString(): {
            DbNames.instructionStep: stepNumber,
            DbNames.instructionTitle: title,
            DbNames.instructionDescription: description,
            DbNames.instructionImageUris: imageUris,
            DbNames.lastModified: DateTime.now(),
          }
        }
      },
      SetOptions(merge: true),
    );
  }
}

class FileUpload {
  final StorageReference ref;
  final StorageUploadTask task;

  FileUpload({this.ref, this.task});
}
