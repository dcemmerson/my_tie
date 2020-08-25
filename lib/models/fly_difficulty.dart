enum FlyDifficulties { Easy, Medium, Hard, Other }

class FlyDifficulty {
  static const _easy = 'easy';
  static const _medium = 'medium';
  static const _hard = 'hard';
  static const _other = 'other';

  final FlyDifficulties difficulty;

//  FlyDifficulty(String difficulty) : _difficulty = toEnum(difficulty);
  FlyDifficulty(this.difficulty);

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
        return _other;
    }
  }

  static FlyDifficulties toEnum(String dif) {
    switch (dif) {
      case 'easy':
        return FlyDifficulties.Easy;
      case 'medium':
        return FlyDifficulties.Medium;
      case 'hard':
        return FlyDifficulties.Hard;
      case 'other':
      default:
        return FlyDifficulties.Other;
    }
  }
}
