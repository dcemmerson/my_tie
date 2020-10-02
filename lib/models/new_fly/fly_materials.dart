import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart' show IconData;
import 'package:my_tie/custom_icons/custom_icons_icons.dart';
import 'package:my_tie/models/db_names.dart';

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
  final Map<String, String> properties; // eg: {'color': 'red', 'size': 'small'}
  final String name; // Name of material, eg: 'beads'

  FlyMaterial({this.properties, this.name});

  FlyMaterial.fromMap({Map properties, this.name})
      : this.properties = _toStringStringMap(properties);

  static Map<String, String> _toStringStringMap(Map props) =>
      props.map((k, v) => MapEntry(k.toString(), v.toString()));

  IconData get icon {
    switch (name) {
      case DbNames.beads:
        return CustomIcons.bead;
      // case DbNames.dubbings:
      //   return CustomIcons.;
      case DbNames.eyes:
        return CustomIcons.eye;
      case DbNames.feathers:
        return CustomIcons.feather;
      // case DbNames.flosses:
      //   return ;
      case DbNames.furs:
        return CustomIcons.fur;
      case DbNames.hooks:
        return CustomIcons.hook_slanted;
      // case DbNames.synthetics:
      //   return;
      case DbNames.threads:
        return CustomIcons.thread;
      case DbNames.tinsels:
        return CustomIcons.tinsel;
      case DbNames.wires:
        return CustomIcons.wire;
      case DbNames.yarns:
        return CustomIcons.yarn;
      default:
        return CustomIcons.hook;
    }
  }

  Color get color {
    switch (properties['color']) {
      case 'red':
        return Colors.red;
      case 'black':
        return Colors.black;
      case 'olive':
        return Colors.lightGreen[900];
      case 'gray':
        return Colors.grey;
      case 'gold':
        return Colors.amber[900];
      default:
        return null;
    }
  }

  String get value =>
      properties.values.fold('', (prev, prop) => prev + prop + ' ');
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

  MapEntry toMapEntry() =>
      MapEntry(name, flyMaterials?.map((mat) => mat.properties)?.toList());

  IconData get icon {
    switch (name) {
      case DbNames.beads:
        return CustomIcons.bead;
      // case DbNames.dubbings:
      //   return CustomIcons.;
      case DbNames.eyes:
        return CustomIcons.eye;
      case DbNames.feathers:
        return CustomIcons.feather;
      // case DbNames.flosses:
      //   return ;
      case DbNames.furs:
        return CustomIcons.fur;
      case DbNames.hooks:
        return CustomIcons.hook_slanted;
      // case DbNames.synthetics:
      //   return;
      case DbNames.threads:
        return CustomIcons.thread;
      case DbNames.tinsels:
        return CustomIcons.tinsel;
      case DbNames.wires:
        return CustomIcons.wire;
      case DbNames.yarns:
        return CustomIcons.yarn;
      default:
        return CustomIcons.hook;
    }
  }

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
