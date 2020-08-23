import 'package:cloud_firestore/cloud_firestore.dart';

class NewFlyService {
  const NewFlyService();

  Stream<QuerySnapshot> get difficulties {
    return FirebaseFirestore.instance.collection('difficulties').snapshots();
  }

  Stream<QuerySnapshot> get flyStyles {
    return FirebaseFirestore.instance.collection('fly_styles').snapshots();
  }

  Stream<QuerySnapshot> get flyTypes {
    return FirebaseFirestore.instance.collection('fly_types').snapshots();
  }

  Stream<QuerySnapshot> get flyMaterials {
    return FirebaseFirestore.instance.collection('fly_materials').snapshots();
  }
}
