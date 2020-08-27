import 'db_names.dart';
import 'fly_form_attribute.dart';
import 'fly_form_material.dart';

class NewFlyFormTemplate {
  // final List<String> flyDifficulties;
  // final List<String> flyStyles;
  // final List<String> flyTargets;
  // final List<String> flyTypes;

  final List<FlyFormAttribute> flyFormAttributes;
  final List<FlyFormMaterial> flyFormMaterials;

  NewFlyFormTemplate.fromDoc(Map doc)
      : this.flyFormAttributes = _toAttributesList(doc[DbNames.attributes]),
        // this.flyDifficulties = List<String>.from(doc[DbNames.flyDifficulties]),
        //   this.flyStyles = List<String>.from(doc[DbNames.flyStyles]),
        //   this.flyTargets = List<String>.from(doc[DbNames.flyTargets]),
        //   this.flyTypes = List<String>.from(doc[DbNames.flyTypes]),
        this.flyFormMaterials = _toMaterialList(doc[DbNames.materials]);

  static List<FlyFormAttribute> _toAttributesList(Map doc) {
    var flyFormMaterials = List<FlyFormAttribute>();
    doc.forEach((key, value) {
      flyFormMaterials.add(FlyFormAttribute(key.toString(), value));
    });

    return flyFormMaterials;
  }

  static List<FlyFormMaterial> _toMaterialList(Map doc) {
    var flyFormMaterials = List<FlyFormMaterial>();
    doc.forEach((key, value) {
      flyFormMaterials.add(FlyFormMaterial(key.toString(), doc));
    });

    return flyFormMaterials;
  }
}
