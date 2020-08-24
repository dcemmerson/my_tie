import 'package:cloud_firestore/cloud_firestore.dart';

class NewFlyService {
  const NewFlyService();

  Stream<QuerySnapshot> get newFlyForm {
    return FirebaseFirestore.instance.collection('new_fly_form').snapshots();
  }
}
