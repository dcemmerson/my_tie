enum FlyTypes { DryFly, Emerger, Nymph, WetFly, Other }

class FlyType {
  static const _nymph = 'nymph';
  static const _dryFly = 'dry fly';
  static const _emerger = 'emerger';
  static const _wefFly = 'wet fly';
  static const _other = 'other';

  final FlyTypes type;

  FlyType(this.type);

  @override
  String toString() {
    switch (type) {
      case FlyTypes.DryFly:
        return _dryFly;
      case FlyTypes.Emerger:
        return _emerger;
      case FlyTypes.Nymph:
        return _nymph;
      case FlyTypes.WetFly:
        return _wefFly;
      case FlyTypes.Other:
      default:
        return _other;
    }
  }

  static FlyTypes toEnum(String typ) {
    switch (typ) {
      case 'wet fly':
        return FlyTypes.WetFly;
      case 'dry fly':
        return FlyTypes.DryFly;
      case 'emerger':
        return FlyTypes.Emerger;
      case 'nymph':
        return FlyTypes.Nymph;
      default:
        return FlyTypes.Other;
    }
  }
}