import 'package:cloud_firestore/cloud_firestore.dart';

class NewFlyService {
  static const _newFlyDocId = 'kb5Vyvj3idUBXB9vkDzd';
  static const _newFlyForm = 'new_fly_form';
  static const _flyInProgress = 'fly_in_progress';

  Future<DocumentSnapshot> get newFlyForm {
    return FirebaseFirestore.instance
        .collection(_newFlyForm)
        .doc(_newFlyDocId)
        .get();
  }

  Future<DocumentSnapshot> getFlyInProgressDoc(String uid) async {
    var snapshot = await FirebaseFirestore.instance
        .collection(_flyInProgress)
        .where('uid', isEqualTo: uid)
        .get();

    if (snapshot.docs.length > 0)
      return snapshot.docs[0];
    else
      return null;
  }

  Future updateFlyMaterialsInProgress({
    String docId,
    String name,
    Map<String, String> properties,
  }) async {
    return FirebaseFirestore.instance.collection(_flyInProgress).doc(docId).set(
      {
        'materials': {
          name: properties,
        }
      },
      SetOptions(merge: true),
    );
  }

  Future updateFlyAttributes({
    String docId,
    Map<String, String> attributes,
  }) async {
    return FirebaseFirestore.instance.collection(_flyInProgress).doc(docId).set(
      {
        'attributes': attributes,
      },
      SetOptions(merge: true),
    );
  }

  Future addNewFlyAttributesDoc({
    String uid,
    Map<String, String> attributes,
  }) {
    return FirebaseFirestore.instance.collection(_flyInProgress).add({
      'uid': uid,
      'attributes': attributes,
    });
  }
}
