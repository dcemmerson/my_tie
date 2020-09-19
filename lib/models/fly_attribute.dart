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
}
