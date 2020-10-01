import 'package:flutter/material.dart';
import 'package:my_tie/custom_icons/custom_icons_icons.dart';

import '../db_names.dart';

class FlyFormMaterial {
  final String name;
  final Map<String, List<String>> properties;
  // final Map<String, List

  FlyFormMaterial(this.name, Map doc)
      : this.properties = toMapOfLists(doc[name]);

  String get value => 'abc';
  // properties.values.fold('', (prev, prop) => prev + prop + ' ');

  static Map<String, List<String>> toMapOfLists(Map<dynamic, dynamic> untyped) {
    // Following the strucutre in our db, key is a String and value is an array.
    return untyped.map((key, value) {
      return MapEntry<String, List<String>>(
          key.toString(), List<String>.from(value));
    });
  }

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
}
