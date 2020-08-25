import 'package:my_tie/models/fly_difficulty.dart';
import 'package:my_tie/models/fly_style.dart';
import 'package:my_tie/models/fly_target.dart';
import 'package:my_tie/models/fly_type.dart';

import 'db_names.dart';

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

  FlyAttributes.fromDoc(Map doc)
      : this.name = doc[DbNames.flyName],
        this.difficulty = FlyDifficulty.fromString(doc[DbNames.flyDifficulty]),
        this.target = FlyTarget.fromString(doc[DbNames.flyTarget]),
        this.style = FlyStyle.fromString(doc[DbNames.flyStyle]),
        this.type = FlyType.fromString(
          doc[DbNames.flyType],
        );
}
