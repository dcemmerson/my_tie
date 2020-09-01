enum AddPropertyType { Material, Attribute }

class AddPropertyArgument {
  final AddPropertyType addPropertyType;
  final String name;
  final String property;

  AddPropertyArgument({this.addPropertyType, this.name, this.property});
}
