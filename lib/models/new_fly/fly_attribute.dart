import 'package:flutter/material.dart';

import '../db_names.dart';

/// filename: fly_attribute.dart
/// description: FlyAttribute represents attribute properties for a fly.
///   An attribute has an attribute name, and a value for that name. For example,
///   name = difficulty, value = medium. Two constructors are provided, default
///   constructor will set value equal to null, if provided value is null.
///   FlyAttribute.formattedFoReview constructor will take those null values and
///   enter in ly.nullReplacement, which can then directly be displayed on fly
///   review page.

import 'fly.dart';

class FlyAttribute {
  final String name;
  final String value;

  FlyAttribute({
    this.name,
    this.value,
  });

  FlyAttribute.formattedForReview({String name, String value})
      : this.name = name != null ? name : Fly.nullReplacement,
        this.value = value != null ? value : Fly.nullReplacement;

  FlyAttribute.formattedForEditing({this.name, this.value});

  Map<String, String> toMap() => {name: value};
  MapEntry toMapEntry() => MapEntry(name, value);

  Color get color {
    switch (name) {
      case (FlyForm.difficulty):
        switch (value) {
          case ('easy'):
            return const Color.fromRGBO(5, 135, 11, 0.9);
          case ('medium'):
            return const Color.fromRGBO(155, 155, 5, 0.9);
          case ('hard'):
            return const Color.fromRGBO(158, 5, 5, 0.9);
          default:
            return const Color.fromRGBO(150, 0, 158, 0.9);
        }
        return const Color.fromRGBO(150, 0, 158, 0.9);
      case (FlyForm.style):
        return const Color.fromRGBO(120, 30, 0, 0.9);
      case (FlyForm.target):
        return const Color.fromRGBO(7, 79, 9, 0.9);
      case (FlyForm.type):
        return Color.fromRGBO(222, 41, 10, 0.9);
      default:
        return Colors.black;
    }
  }
}
