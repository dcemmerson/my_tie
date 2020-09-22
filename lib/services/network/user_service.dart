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
}
