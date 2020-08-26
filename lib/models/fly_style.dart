enum FlyStyles {
  Midge,
  Caddis,
  Mayfly,
  Streamer,
  Terrestrial,
  Egg,
  Worm,
  Attractor,
  Foam,
  Other,
}

class FlyStyle {
  static const _midge = 'midge';
  static const _caddis = 'caddis';
  static const _mayfly = 'mayfly';
  static const _streamer = 'streamer';
  static const _terrestrial = 'terrestrial';
  static const _egg = 'egg';
  static const _worm = 'worm';
  static const _attractor = 'attractor';
  static const _foam = 'foam';
  static const _other = 'other';

  final FlyStyles style;

  FlyStyle(this.style);
  FlyStyle.fromString(String sty) : style = toEnum(sty);

  @override
  String toString() {
    switch (style) {
      case FlyStyles.Midge:
        return _midge;
      case FlyStyles.Caddis:
        return _caddis;
      case FlyStyles.Mayfly:
        return _mayfly;
      case FlyStyles.Streamer:
        return _streamer;
      case FlyStyles.Terrestrial:
        return _terrestrial;
      case FlyStyles.Egg:
        return _egg;
      case FlyStyles.Worm:
        return _worm;
      case FlyStyles.Attractor:
        return _attractor;
      case FlyStyles.Foam:
        return _foam;
      case FlyStyles.Other:
      default:
        return _other;
    }
  }

  static FlyStyles toEnum(String sty) {
    switch (sty) {
      case _midge:
        return FlyStyles.Midge;
      case _caddis:
        return FlyStyles.Caddis;
      case _mayfly:
        return FlyStyles.Mayfly;
      case _streamer:
        return FlyStyles.Streamer;
      case _terrestrial:
        return FlyStyles.Terrestrial;
      case _egg:
        return FlyStyles.Egg;
      case _worm:
        return FlyStyles.Worm;
      case _attractor:
        return FlyStyles.Attractor;
      case _attractor:
        return FlyStyles.Foam;
      default:
        return FlyStyles.Other;
    }
  }
}
