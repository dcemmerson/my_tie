class FlyFormAttribute {
  final String name;
  final List<String> properties;

  FlyFormAttribute(this.name, List props)
      : this.properties = props.map((val) => val.toString()).toList();

  // static List<String> _toStringList(List untyped) {
  //   return untyped.map((val) {
  //     return val.tostring();
  //   });
  // }
}
