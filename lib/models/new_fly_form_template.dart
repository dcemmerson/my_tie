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
    var ffa = List<FlyFormAttribute>();
    doc.forEach((key, value) {
      ffa.add(FlyFormAttribute(key.toString(), value));
    });

    return ffa;
  }

  static List<FlyFormMaterial> _toMaterialList(Map doc) {
    var ffm = List<FlyFormMaterial>();
    doc.forEach((key, value) {
      ffm.add(FlyFormMaterial(key.toString(), doc));
    });

    ffm.sort((a, b) => a.name.compareTo(b.name));
    return ffm;
  }
}
