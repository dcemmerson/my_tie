import 'db_names.dart';

class NewFlyFormTemplate {
  final List<String> flyDifficulties;
  final List<String> flyStyles;
  final List<String> flyTargets;
  final List<String> flyTypes;

  NewFlyFormTemplate.fromDoc(Map doc)
      : this.flyDifficulties = List<String>.from(doc[DbNames.flyDifficulties]),
        this.flyStyles = List<String>.from(doc[DbNames.flyStyles]),
        this.flyTargets = List<String>.from(doc[DbNames.flyTargets]),
        this.flyTypes = List<String>.from(doc[DbNames.flyTypes]);
}
