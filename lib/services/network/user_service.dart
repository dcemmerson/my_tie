import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_tie/models/db_names.dart';

class UserService {
  UserService();

  Future addFavorite(String uid, String favoriteDocId) {
    return FirebaseFirestore.instance
        .collection(DbCollections.user)
        .doc(uid)
        .set({
      DbNames.favoritedFlies: FieldValue.arrayUnion([favoriteDocId]),
    }, SetOptions(merge: true));
  }

  Future removeFavorite(String uid, String favoriteDocId) {
    return FirebaseFirestore.instance
        .collection(DbCollections.user)
        .doc(uid)
        .set({
      DbNames.favoritedFlies: FieldValue.arrayRemove([favoriteDocId]),
    }, SetOptions(merge: true));
  }

  Stream<QuerySnapshot> getUserProfileStream(String uid) {
    return FirebaseFirestore.instance
        .collection(DbCollections.user)
        .where(DbNames.uid, isEqualTo: uid)
        .snapshots();
  }

  Future<QuerySnapshot> getUserProfile(String uid) {
    return FirebaseFirestore.instance
        .collection(DbCollections.user)
        .where(DbNames.uid, isEqualTo: uid)
        .get();
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

  Future requestFlyReindex(String uid) {
    return FirebaseFirestore.instance
        .collection(DbCollections.materialReindexRequests)
        .add({'uid': uid});
  }
}
