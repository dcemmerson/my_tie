/// filename: add_material.dart
/// description: Small class used when user needs to add a new property,
///   specifically a material, to add new fly form template in cloud firestore.
///   This class is just used to pass the information from the widget and
///   add it to the bloc sink.

class AddMaterial {
  final String materialName;
  final String property;
  final String newValue;

  AddMaterial({this.materialName, this.property, this.newValue});
}
