import 'package:my_tie/models/fly_form_material.dart';

import 'fly_attribute.dart';
import 'fly_form_attribute.dart';
import 'fly_materials.dart';
import 'new_fly_form_template.dart';

class Fly {
  static const nullReplacement = '[None selected]';

  final String flyName;
  final List<FlyAttribute> attributes;
  final List<FlyMaterials> materials;

  Fly({this.flyName, Map attrs, Map mats})
      : this.attributes = _toAttributeList(attrs),
        this.materials = _toMaterialsList(mats);

  /// To format for review, we need to pass in the NewFlyFormTemplate from db,
  ///   which we will then use as a guide to ensure we either set attributes/
  ///   materials values to the value passed in, or Fly.nullReplacement.
  Fly.formattedForReview({
    String flyName,
    Map attrs,
    Map mats,
    NewFlyFormTemplate flyFormTemplate,
  })  : this.flyName =
            flyName ?? 'No name', // Must set flyName here rather than
        //  default arg (because if value doesnt exist in firebase, flyName will
        //  be explicitly set to null, even if we provide default arg)
        this.attributes =
            _toAttributeListForReview(attrs ?? {}, flyFormTemplate),
        this.materials = _toMaterialListForReview(mats ?? {}, flyFormTemplate);

  Fly.formattedForEditing(
      {this.flyName, Map attrs, Map mats, NewFlyFormTemplate flyFormTemplate})
      : this.attributes =
            _toAttributeListForEditing(attrs ?? {}, flyFormTemplate),
        this.materials = _toMaterialListForEditing(mats ?? {}, flyFormTemplate);

  static List<FlyAttribute> _toAttributeListForEditing(
      Map attrs, NewFlyFormTemplate flyFormTemplate) {
    List<FlyAttribute> flyAttributes =
        flyFormTemplate.flyFormAttributes.map((FlyFormAttribute ffa) {
      return FlyAttribute.formattedForEditing(
          name: ffa.name, value: attrs[ffa.name]);
    }).toList();

    return flyAttributes;
  }

  static List<FlyMaterials> _toMaterialListForEditing(
      Map mats, NewFlyFormTemplate flyFormTemplate) {
    List<FlyMaterials> flyMaterials =
        flyFormTemplate.flyFormMaterials.map((FlyFormMaterial ffm) {
      return FlyMaterials.formattedForEditing(
          name: ffm.name, props: mats[ffm.name]);
    }).toList();

    return flyMaterials;
  }

  static List<FlyAttribute> _toAttributeListForReview(
      Map attrs, NewFlyFormTemplate flyFormTemplate) {
    List<FlyAttribute> flyAttributes =
        flyFormTemplate.flyFormAttributes.map((FlyFormAttribute ffa) {
      return FlyAttribute.formattedForReview(
          name: ffa.name, value: attrs[ffa.name]);
    }).toList();

    return flyAttributes;
  }

  static List<FlyMaterials> _toMaterialListForReview(
      Map mats, NewFlyFormTemplate flyFormTemplate) {
    List<FlyMaterials> flyMaterials =
        flyFormTemplate.flyFormMaterials.map((FlyFormMaterial ffm) {
      return FlyMaterials.formattedForReview(
          name: ffm.name, props: mats[ffm.name]);
    }).toList();

    return flyMaterials;
  }

  static List<FlyAttribute> _toAttributeList(Map attrs) {
    List<FlyAttribute> flyAttributes = [];
    attrs
        ?.forEach((k, v) => flyAttributes.add(FlyAttribute(name: k, value: v)));

    return flyAttributes;
  }

  static List<FlyMaterials> _toMaterialsList(Map mats) {
    List<FlyMaterials> flyMaterials = [];
    mats?.forEach((k, v) => flyMaterials.add(FlyMaterials(name: k, props: v)));

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

  String getMaterial(
      int materialIndex, int propertyIndex, String propertyName) {
    if ((materialIndex == null ||
            propertyIndex == null ||
            propertyName == null) ||
        propertyIndex >= materials[materialIndex].flyMaterials.length) {
      return null;
    }
    return materials[materialIndex]
        .flyMaterials[propertyIndex]
        .properties[propertyName];
  }
}
