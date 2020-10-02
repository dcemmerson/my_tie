import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_tie/models/db_names.dart';

class UserService {
  UserService();

  Stream<QuerySnapshot> getUserProfile(uid) {
    return FirebaseFirestore.instance
        .collection(DbCollections.user)
        .where(DbNames.uid, isEqualTo: uid)
        .snapshots();
  }

  Future deleteUserProfileMaterial({
    String docId,
    String uid,
    String name,
    Map<String, String> properties,
  }) {
    return FirebaseFirestore.instance
        .collection(DbCollections.user)
        .doc(docId)
        .set(
      {
        DbNames.materialsOnHand: {
          name: FieldValue.arrayRemove([properties]),
        },
        DbNames.uploadedBy: uid,
        DbNames.lastModified: DateTime.now(),
      },
      SetOptions(merge: true),
    );
  }

  Future addUserProfileMaterial({
    String docId,
    String uid,
    String name,
    Map<String, String> properties,
  }) {
    return FirebaseFirestore.instance
        .collection(DbCollections.user)
        .doc(docId)
        .set(
      {
        DbNames.materialsOnHand: {
          name: FieldValue.arrayUnion([properties]),
        },
        DbNames.uploadedBy: uid,
        DbNames.lastModified: DateTime.now(),
      },
      SetOptions(merge: true),
    );
  }
}
