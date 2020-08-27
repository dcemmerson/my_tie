import 'db_names.dart';
import 'fly_form_material.dart';

class NewFlyFormTemplate {
  final List<String> flyDifficulties;
  final List<String> flyStyles;
  final List<String> flyTargets;
  final List<String> flyTypes;

  final List<FlyFormMaterial> flyFormMaterials;

  NewFlyFormTemplate.fromDoc(Map doc)
      : this.flyDifficulties = List<String>.from(doc[DbNames.flyDifficulties]),
        this.flyStyles = List<String>.from(doc[DbNames.flyStyles]),
        this.flyTargets = List<String>.from(doc[DbNames.flyTargets]),
        this.flyTypes = List<String>.from(doc[DbNames.flyTypes]),
        this.flyFormMaterials = _toList(doc[DbNames.materials]);

  static Map<String, List<String>> toMapOfLists(Map<dynamic, dynamic> untyped) {
    // Following the strucutre in our db, key is a String and value is an array.
    return untyped.map((key, value) {
      return MapEntry<String, List<String>>(
          key.toString(), List<String>.from(value));
    });
  }

  static List<FlyFormMaterial> _toList(Map doc) {
    var flyFormMaterials = List<FlyFormMaterial>();
    doc.forEach((key, value) {
      flyFormMaterials.add(FlyFormMaterial(key.toString(), doc));
    });

    return flyFormMaterials;
  }
}
