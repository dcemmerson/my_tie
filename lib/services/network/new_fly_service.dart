/// filename: new_fly_service.dart
/// last modified: 09/03/2020
/// description: This file contains app related communication with firestore
///   service related to user adding a new fly to db. Functionallity provided
///   includes adding attributes, materials, and instructions to fly.
///
///   Note that firestore security permits user to only read/write a doc in
///   'fly_in_progress' collection whose id corresponds to the logged in user id.
///
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';
import 'package:my_tie/models/db_names.dart';

class NewFlyService {
  Future createFlyInProgressDoc({String uid}) {
    return FirebaseFirestore.instance
        .collection(DbCollections.flyInProgress)
        .add({DbNames.uploadedBy: uid, DbNames.toBePublished: false});
  }

  Stream<QuerySnapshot> getFlyInProgressDocStream(String uid) {
    return FirebaseFirestore.instance
        .collection(DbCollections.flyInProgress)
        .where(DbNames.uploadedBy, isEqualTo: uid)
        .where(DbNames.toBePublished, isEqualTo: false)
        // OrderBy is not necessary beause a cloud function ensures one user
        //  can only ever have one fly_in_progress doc at a time.
//        .orderBy(DbNames.created, descending: true)
//        .doc(uid)
        .snapshots();
  }

  Future addFlyInProgressMaterial({
    String docId,
    String uid,
    String name,
    Map<String, String> properties,
  }) {
    return FirebaseFirestore.instance
        .collection(DbCollections.flyInProgress)
        .doc(docId)
        .set(
      {
        DbNames.materials: {
          name: FieldValue.arrayUnion([properties]),
        },
        DbNames.uploadedBy: uid,
        DbNames.lastModified: DateTime.now(),
      },
      SetOptions(merge: true),
    );
  }

  Future deleteFlyInProgressMaterial({
    String docId,
    String name,
    Map<String, String> properties,
  }) {
    return FirebaseFirestore.instance
        .collection(DbCollections.flyInProgress)
        .doc(docId)
        .set(
      {
        DbNames.materials: {
          name: FieldValue.arrayRemove([properties]),
        },
        DbNames.lastModified: DateTime.now(),
      },
      SetOptions(merge: true),
    );
  }

  Future updateFlyInProgressInstructions(
      {String docId, String uid, Map instructions}) {
    return FirebaseFirestore.instance
        .collection(DbCollections.flyInProgress)
        .doc(docId)
        .set({
      DbNames.instructions: instructions,
      DbNames.lastModified: DateTime.now(),
      DbNames.uploadedBy: uid,
    }, SetOptions(mergeFields: [DbNames.instructions]));
  }

  Future addNewFlyAttributes({
    String docId,
    String uid,
    Map<String, String> attributes,
    String flyName,
    String flyDescription,
    List<String> topLevelImageUris,
  }) {
    final Map<String, dynamic> flyInProgress = {
      DbNames.uploadedBy: uid,
      DbNames.lastModified: DateTime.now(),
      if (attributes != null) DbNames.attributes: attributes,
      if (topLevelImageUris != null)
        DbNames.topLevelImageUris: topLevelImageUris,
      if (flyName != null) DbNames.flyName: flyName,
      if (flyDescription != null) DbNames.flyDescription: flyDescription,
    };

    return FirebaseFirestore.instance
        .collection(DbCollections.flyInProgress)
        .doc(docId)
        .set(flyInProgress, SetOptions(merge: true));
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

  Future addNewFlyInstruction({
    String docId,
    String uid,
    String title,
    String description,
    int stepNumber,
    List<String> imageUris,
  }) {
    // Now update fly in progress doc in firestore.
    return FirebaseFirestore.instance
        .collection(DbCollections.flyInProgress)
        .doc(docId)
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
        },
        DbNames.uploadedBy: uid,
        DbNames.lastModified: DateTime.now(),
      },
      SetOptions(merge: true),
    );
  }

  Future deleteFlyInProgress({String docId}) {
    return FirebaseFirestore.instance
        .collection(DbCollections.flyInProgress)
        .doc(docId)
        .delete();
  }

  Future publishFly(String prevDocId) {
    // All we do from client is set the to_be_published flag to true and call
    // the cloud function which will at some point sanitize and publish the fly.
    // Server side sanitization performs same checks as client side, meaning
    // the server side sanitization shouldn't fail unless malicious attempt
    // made. This allows us to quickly update user ui, even in offline mode.

    final updateFlyInProgress = FirebaseFirestore.instance
        .collection(DbCollections.flyInProgress)
        .doc(prevDocId)
        .set({DbNames.toBePublished: true}, SetOptions(merge: true));

    final triggerCloudFunction = CloudFunctions.instance
        .getHttpsCallable(functionName: 'publishFly')
        .call({'docId': prevDocId});

    return Future.wait([updateFlyInProgress, triggerCloudFunction]);
  }
}

class FileUpload {
  final StorageReference ref;
  final StorageUploadTask task;

  FileUpload({this.ref, this.task});
}
