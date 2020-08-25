class NewFlyFormTemplate {
  static const _flyDifficulties = 'fly_difficulties';
  static const _flyStyles = 'fly_styles';
  static const _flyTargets = 'fly_targets';
  static const _flyTypes = 'fly_types';

  final List<String> flyDifficulties;
  final List<String> flyStyles;
  final List<String> flyTargets;
  final List<String> flyTypes;

  NewFlyFormTemplate.fromDoc(Map doc)
      : this.flyDifficulties = List<String>.from(doc[_flyDifficulties]),
        this.flyStyles = List<String>.from(doc[_flyStyles]),
        this.flyTargets = List<String>.from(doc[_flyTargets]),
        this.flyTypes = List<String>.from(doc[_flyTypes]);
}
