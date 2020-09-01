import 'package:cloud_firestore/cloud_firestore.dart';

class NewFlyService {
  static const _newFlyFormDocId = 'kb5Vyvj3idUBXB9vkDzd';
  static const _newFlyForm = 'new_fly_form';
  static const _newFlyFormIncoming = 'new_fly_form_incoming';
  static const _flyInProgress = 'fly_in_progress';

  Future<DocumentSnapshot> get newFlyForm {
    return FirebaseFirestore.instance
        .collection(_newFlyForm)
        .doc(_newFlyFormDocId)
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

  Stream<DocumentSnapshot> get newFlyFormStream {
    return FirebaseFirestore.instance
        .collection(_newFlyForm)
        //      .orderBy('last_modified')
//        .limit(1)
        .doc(_newFlyFormDocId)
        .snapshots();
  }

  Stream<QuerySnapshot> getFlyInProgressDocStream(String uid) {
    return FirebaseFirestore.instance
        .collection(_flyInProgress)
        .where('uid', isEqualTo: uid)
        .snapshots();
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

  Future addAtributeToFormTemplate(
      {String uid, String attribute, String value}) {
    print('send');
    return FirebaseFirestore.instance
        .collection(_newFlyFormIncoming)
        .doc(uid)
        .set({
      'attributes': {attribute: value}
    }, SetOptions(merge: true));
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
