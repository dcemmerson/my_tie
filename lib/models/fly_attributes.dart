import 'package:my_tie/models/fly_difficulty.dart';
import 'package:my_tie/models/fly_style.dart';
import 'package:my_tie/models/fly_target.dart';
import 'package:my_tie/models/fly_type.dart';

class FlyAttributes {
  final String name;

  final FlyDifficulty difficulty;
  final FlyTarget target;
  final FlyStyle style;
  final FlyType type;

  FlyAttributes({
    this.name,
    this.target,
    this.style,
    this.type,
    this.difficulty,
  });
}
