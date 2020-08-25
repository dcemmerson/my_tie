import 'package:cloud_firestore/cloud_firestore.dart';

class NewFlyService {
  static const _newFlyForm = 'new_fly_form';
  static const _flyInProgress = 'fly_in_progress';

  Stream<QuerySnapshot> get newFlyForm {
    return FirebaseFirestore.instance.collection(_newFlyForm).snapshots();
  }

  Future<QueryDocumentSnapshot> getFlyInProgressDoc(String uid) async {
    var snapshot = await FirebaseFirestore.instance
        .collection(_flyInProgress)
        .where('uid', isEqualTo: uid)
        .get();

    if (snapshot.docs.length > 0)
      return snapshot.docs[0];
    else
      return null;
  }

  Future updateFlyAttributes(
      {String docId,
      String name,
      String difficulty,
      String type,
      String style,
      String target}) async {
    return FirebaseFirestore.instance
        .collection(_flyInProgress)
        .doc(docId)
        .update({
      'name': name,
      'difficulty': difficulty,
      'type': type,
      'style': style,
      'target': target
    });
  }

  Future addNewFlyAttributesDoc(
      {String uid,
      String name,
      String difficulty,
      String type,
      String style,
      String target}) {
    return FirebaseFirestore.instance.collection(_flyInProgress).add({
      'uid': uid,
      'name': name,
      'difficulty': difficulty,
      'type': type,
      'style': style,
      'target': target
    });
  }
}
