enum FlyDifficulties { Easy, Medium, Hard, Other }

class FlyDifficulty {
  static const _easy = 'easy';
  static const _medium = 'medium';
  static const _hard = 'hard';
  static const _other = 'other';

  final FlyDifficulties difficulty;

  FlyDifficulty(this.difficulty);
  FlyDifficulty.fromString(String dif) : difficulty = toEnum(dif);

  @override
  String toString() {
    switch (difficulty) {
      case FlyDifficulties.Easy:
        return _easy;
      case FlyDifficulties.Medium:
        return _medium;
      case FlyDifficulties.Hard:
        return _hard;
      case FlyDifficulties.Other:
      default:
        return _easy;
    }
  }

  static FlyDifficulties toEnum(String dif) {
    switch (dif) {
      case _easy:
        return FlyDifficulties.Easy;
      case _medium:
        return FlyDifficulties.Medium;
      case _hard:
        return FlyDifficulties.Hard;
      default:
        return FlyDifficulties.Easy;
    }
  }
}
