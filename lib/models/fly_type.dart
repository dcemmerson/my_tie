enum FlyTypes { Nymph, WetFly, DryFly, Emerger, Other }

class FlyType {
  final FlyTypes _type;

  FlyType(String type) : _type = toEnum(type);

  get type => _type;

  static FlyTypes toEnum(String style) {
    switch (style) {
      case 'nymph':
        return FlyTypes.Nymph;
      case 'wet fly':
        return FlyTypes.WetFly;
      case 'dry fly':
        return FlyTypes.DryFly;
      case 'emerger':
        return FlyTypes.Emerger;
      default:
        return FlyTypes.Other;
    }
  }
}
