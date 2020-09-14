/// filename: fly_material.dart
/// description: FlyMaterial represents fly material properties for a fly.
///   A material has an attribute name, and properites which are represented in
///   List<Map<String, String>>, so there can be multiple varieties of the
///   material. For example, name = beads,
///   properties = [{color: red, size: large}]. Two constructors are provided,
///   default constructor will set value equal to null, if provided value is null.
///   FlyMaterial.formattedFoReview constructor will take those null values and
///   enter in Fly.nullReplacement, which can then directly be displayed on
///   fly review page.

import 'fly.dart';

class FlyMaterial {
  final Map<String, String> properties;
  final String name; // Name of material

  FlyMaterial({this.properties, this.name});
}

class FlyMaterials {
  final String name; // eg beads
  final List<FlyMaterial> flyMaterials;

  FlyMaterials({this.name, List props})
      : flyMaterials = _toListFlyMaterials(name, props);

  FlyMaterials.formattedForReview({String name, List props})
      : this.name = name != null ? name : Fly.nullReplacement,
        flyMaterials = _toListFlyMaterialReplaceNull(name, props);

  FlyMaterials.formattedForEditing({this.name, List props})
      : flyMaterials = _toListFlyMaterials(name, props);

  /// name: _toListFlyMaterialReplaceNull
  /// description: Iterate through list from db and just convert list of
  ///   properties to a list of Map<String, String> and return the list. If
  ///   value of any property equals null, replace with Fly.nullReplacement
  static List<FlyMaterial> _toListFlyMaterialReplaceNull(
      String name, List props) {
    return props?.map((prop) {
      final m = Map<String, String>();
      (prop as Map).forEach((k, v) {
        m[k.toString()] = v != null ? v.toString() : Fly.nullReplacement;
      });
      return FlyMaterial(properties: m, name: name);
    })?.toList();
  }

  /// name: _toListFlyMaterials
  /// description: Iterate through list from db and just convert list of
  ///   properties to a list of Map<String, String> and return the list. If
  ///   value of any property equals null, leave that value as null. This is
  ///   necessary for the dropdowns on materials forms to function properly.
  static List<FlyMaterial> _toListFlyMaterials(String name, List props) {
    return props?.map((prop) {
      final m = Map<String, String>();
      (prop as Map).forEach((k, v) {
        m[k.toString()] = (v == null) ? v : v.toString();
      });
      return FlyMaterial(properties: m, name: name);
    })?.toList();
  }

  String getProperty(String prop) {
    return 'unimplemented';
//    return properties[prop];
  }
}
