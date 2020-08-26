enum FlyTargets { Bass, Salmon, Trout, Other }

class FlyTarget {
  static const _bass = 'bass';
  static const _salmon = 'salmon';
  static const _trout = 'trout';
  static const _other = 'other';

  final FlyTargets target;

  FlyTarget(this.target);
  FlyTarget.fromString(String tar) : target = toEnum(tar);

  @override
  String toString() {
    switch (target) {
      case FlyTargets.Bass:
        return _bass;
      case FlyTargets.Salmon:
        return _salmon;
      case FlyTargets.Trout:
        return _trout;
      case FlyTargets.Other:
      default:
        return _other;
    }
  }

  static FlyTargets toEnum(String targ) {
    switch (targ) {
      case _bass:
        return FlyTargets.Bass;
      case _trout:
        return FlyTargets.Trout;
      case _salmon:
        return FlyTargets.Salmon;
      case _other:
        return FlyTargets.Salmon;
      default:
        return FlyTargets.Other;
    }
  }
}
