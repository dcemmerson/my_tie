class FlyAttribute {
  final String property;
  final String value;

  FlyAttribute({
    this.property,
    this.value,
  });

  Map<String, String> toMap() => {property: value};

  // FlyAttribute.fromDoc(Map doc)
  //     : this.name = doc[DbNames.flyName],
  //       this.difficulty = FlyDifficulty.fromString(doc[DbNames.flyDifficulty]),
  //       this.target = FlyTarget.fromString(doc[DbNames.flyTarget]),
  //       this.style = FlyStyle.fromString(doc[DbNames.flyStyle]),
  //       this.type = FlyType.fromString(
  //         doc[DbNames.flyType],
  //       );
}
