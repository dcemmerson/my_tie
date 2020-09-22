import 'package:my_tie/models/new_fly/fly_materials.dart';

import '../db_names.dart';

class UserProfile {
  final String uid;
  final String user;
  final String name;
  final String phoneNumber;

  final List<FlyMaterial> materialsOnHand;

  UserProfile(
      {this.name, this.phoneNumber, this.uid, this.user, this.materialsOnHand});

  UserProfile.fromDoc(Map doc)
      : name = doc[DbNames.name].toString(),
        uid = doc[DbNames.uid].toString(),
        phoneNumber = doc[DbNames.phoneNumber].toString(),
        user = doc[DbNames.user].toString(),
        materialsOnHand = _toListFlyMaterial(doc[DbNames.materialsOnHand]);

  static List<FlyMaterial> _toListFlyMaterial(List mats) => mats
      .map((mat) =>
          FlyMaterial(name: mat['name'], properties: mat['properties']))
      .toList();
}
