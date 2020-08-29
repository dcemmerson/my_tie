import 'fly_attribute.dart';
import 'fly_material.dart';

class Fly {
  final List<FlyAttribute> attributes;
  final List<FlyMaterial> materials;

  Fly({Map attrs, Map mats})
      : this.attributes = _toAttributeList(attrs),
        this.materials = _toMaterialList(mats);

  static List<FlyAttribute> _toAttributeList(Map attrs) {
    List<FlyAttribute> flyAttributes = [];
    attrs
        ?.forEach((k, v) => flyAttributes.add(FlyAttribute(name: k, value: v)));

    return flyAttributes;
  }

  static List<FlyMaterial> _toMaterialList(Map mats) {
    List<FlyMaterial> flyMaterials = [];
    mats?.forEach((k, v) => flyMaterials.add(FlyMaterial(name: k, props: v)));

    return flyMaterials;
  }

  String getAttribute(String name) {
    var attrFound =
        attributes.firstWhere((attr) => attr.name == name, orElse: () => null);

    if (attrFound != null) {
      return attrFound.value;
    }
    return null;
  }

  String getMaterial(String matName, String materialAttribute) {
    var matFound =
        materials.firstWhere((mat) => mat.name == matName, orElse: () => null);
    if (matFound != null) {
      return matFound.properties[materialAttribute];
    }
    return null;
  }
}
