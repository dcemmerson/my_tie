import 'package:my_tie/misc/misc.dart';
import 'package:my_tie/models/new_fly/fly_materials.dart';

import '../db_names.dart';

class UserProfile {
  final String uid;
  final String docId;
  final String user;
  final String name;
  final String phoneNumber;
  final List<FlyMaterials> materialsOnHand;
  final List<String> favoriteFlyDocs;

  // final List<FlyMaterial> materialsOnHand;

  UserProfile({
    this.name,
    this.phoneNumber,
    this.uid,
    this.docId,
    this.user,
    this.materialsOnHand,
    this.favoriteFlyDocs,
  });

  UserProfile.fromDoc(Map doc, {this.docId})
      : name = doc[DbNames.name].toString(),
        uid = doc[DbNames.uid].toString(),
        phoneNumber = doc[DbNames.phoneNumber].toString(),
        user = doc[DbNames.user].toString(),
        materialsOnHand = _toMaterialsList(doc[DbNames.materialsOnHand]),
        favoriteFlyDocs = Misc.toListOfString(doc[DbNames.favoritedFlies]);

  List<FlyMaterial> getMaterials(String name) {
    FlyMaterials mats = materialsOnHand.firstWhere((mat) => mat.name == name,
        orElse: () => null);
    if (mats != null) return mats.flyMaterials;
    return [];
  }

  bool contains({String name, Map properties}) {
    bool matAlreadyExists = false;
    materialsOnHand.forEach((matGroup) {
      if (matGroup.name == name) {
        matGroup.flyMaterials.forEach((mat) {
          bool materialMatch = true;
          mat.properties.keys.forEach((k) {
            materialMatch =
                materialMatch && (mat.properties[k] == properties[k]);
          });
          matAlreadyExists = matAlreadyExists || materialMatch;
        });
      }
    });
    return matAlreadyExists;
  }

  static List<FlyMaterials> _toMaterialsList(Map mats) {
    List<FlyMaterials> flyMaterials = [];
    mats?.forEach((k, v) => flyMaterials.add(FlyMaterials(name: k, props: v)));

    return flyMaterials;
  }
}
