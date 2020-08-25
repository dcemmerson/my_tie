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
      case 'midge':
        return FlyStyles.Midge;
      case 'caddis':
        return FlyStyles.Caddis;
      case 'mayfly':
        return FlyStyles.Mayfly;
      case 'streamer':
        return FlyStyles.Streamer;
      case 'terrestrial':
        return FlyStyles.Terrestrial;
      case 'egg':
        return FlyStyles.Egg;
      case 'worm':
        return FlyStyles.Worm;
      case 'attractor':
        return FlyStyles.Attractor;
      case 'foam':
        return FlyStyles.Foam;
      default:
        return FlyStyles.Other;
    }
  }
}
