import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_tie/models/db_names.dart';

class NewFlyService {
  static const _newFlyForm = 'new_fly_form';
  static const _newFlyFormIncoming = 'new_fly_form_incoming';
  static const _flyInProgress = 'fly_in_progress';

  // Future<DocumentSnapshot> getFlyInProgressDoc(String uid) async {
  //   var snapshot = await FirebaseFirestore.instance
  //       .collection(_flyInProgress)
  //       .where('uid', isEqualTo: uid)
  //       .get();

  //   if (snapshot.docs.length > 0)
  //     return snapshot.docs[0];
  //   else
  //     return null;
  // }

  // Stream<QuerySnapshot> get newFlyFormStream {
  //   return FirebaseFirestore.instance
  //       .collection(_newFlyForm)
  //       .orderBy('last_modified', descending: true)
  //       .limit(1)
  //       // .doc(_newFlyFormDocId)
  //       .snapshots();
  // }

  Stream<DocumentSnapshot> getFlyInProgressDocStream(String uid) {
    print(uid);
    return FirebaseFirestore.instance
        .collection(_flyInProgress)
        .doc(uid)
//        .where('uid', isEqualTo: uid)
        .snapshots();
  }

  Future updateFlyMaterialsInProgress({
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

  // Future updateFlyAttributes({
  //   String docId,
  //   Map<String, String> attributes,
  // }) async {
  //   return FirebaseFirestore.instance.collection(_flyInProgress).doc(docId).set(
  //     {
  //       'attributes': attributes,
  //     },
  //     SetOptions(merge: true),
  //   );
  // }

  // Future addAtributeToFormTemplate(
  //     {String uid, String attribute, String value}) {
  //   return FirebaseFirestore.instance
  //       .collection(_newFlyFormIncoming)
  //       .doc(uid)
  //       .set({
  //     'attributes': {attribute: value}
  //   }, SetOptions(merge: true));
  // }

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
}
