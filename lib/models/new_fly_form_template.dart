import 'db_names.dart';
import 'fly_form_attribute.dart';
import 'fly_form_material.dart';

class NewFlyFormTemplate {
  final List<FlyFormAttribute> flyFormAttributes;
  final List<FlyFormMaterial> flyFormMaterials;

  NewFlyFormTemplate.fromDoc(Map doc)
      : this.flyFormAttributes = _toAttributesList(doc[DbNames.attributes]),
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
