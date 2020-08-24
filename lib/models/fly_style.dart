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
  final FlyStyles _style;

  FlyStyle(String style) : _style = toEnum(style);

  get style => _style;

  static FlyStyles toEnum(String style) {
    switch (style) {
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
