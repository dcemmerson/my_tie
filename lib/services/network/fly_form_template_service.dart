import 'package:cloud_firestore/cloud_firestore.dart';

class FlyFormTemplateService {
  static const _newFlyForm = 'new_fly_form';
  static const _newFlyFormIncoming = 'new_fly_form_incoming';

  Stream<QuerySnapshot> get newFlyFormStream {
    return FirebaseFirestore.instance
        .collection(_newFlyForm)
        .orderBy('last_modified', descending: true)
        .limit(1)
        // .doc(_newFlyFormDocId)
        .snapshots();
  }

  Future addMaterialToFormTemplate(
      {String uid, String material, String property, String value}) {
    print('abc');
    return null;
  }

  Future addAttributeToFormTemplate(
      {String uid, String attribute, String value}) {
    return FirebaseFirestore.instance
        .collection(_newFlyFormIncoming)
        .doc(uid)
        .set({
      'attributes': {attribute: value}
    }, SetOptions(merge: true));
  }
}
