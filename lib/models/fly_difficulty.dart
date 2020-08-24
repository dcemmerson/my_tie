enum FlyDifficulties { Easy, Medium, Hard, Other }

class FlyDifficulty {
  final FlyDifficulties _difficulty;

  FlyDifficulty(String difficulty) : _difficulty = toEnum(difficulty);

  get difficulty => _difficulty;

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
