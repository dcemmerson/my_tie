/// filename: add_attribute.dart
/// description: Small class used when user needs to add a new property,
///   specifically an attribute, to add new fly form template in cloud firestore.
///   This class is just used to pass the information from the widget and
///   add it to the bloc sink.

class AddAttribute {
  final String attribute;
  final String newValue;

  AddAttribute({this.attribute, this.newValue});
}
