class FlyAttribute {
  final String name;
  final String value;

  FlyAttribute({
    this.name,
    this.value,
  });

  Map<String, String> toMap() => {name: value};
}
