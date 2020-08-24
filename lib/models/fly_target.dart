enum FlyTargets { Bass, Trout, Salmon, Other }

class FlyTarget {
  final FlyTargets _targets;

  FlyTarget(String target) : _targets = toEnum(target);

  get target => _targets;

  static FlyTargets toEnum(String target) {
    switch (target) {
      case 'bass':
        return FlyTargets.Bass;
      case 'trout':
        return FlyTargets.Trout;
      case 'salmon':
        return FlyTargets.Salmon;
      default:
        return FlyTargets.Other;
    }
  }
}
