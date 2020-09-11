/// filename: instructions_test_manager.dart
/// description: Logic for testing instruction aspect of new fly form.

import 'dart:math';

import 'package:flutter_driver/flutter_driver.dart';

import 'test_value_keys.dart';

class InstructionsTestManager {
  static const emptyNamePlaceholder = 'No name';
  static const emptyAttributePlaceholder = '[None]';

  static final rnd = Random();
  static final List<Instruction> instructions = [
    Instruction(title: 'Marclar', description: 'Marclar, this is Marclar'),
    Instruction(
        title: 'Call Marclar',
        description: 'Calling all Marclar, this is Marclar'),
    Instruction(title: 'Marclar Directs', description: 'Hey you, Marclar'),
    Instruction(title: 'Marclar Responds', description: 'Yes, Marclar?'),
  ];

  // Everytime we instantiate AttributesInfo for integration tests, we will
  //  use rnd to pseudo randomly select fly attributes.
  InstructionsTestManager();

  Future fillOutInstructions(FlutterDriver driver) async {
    print('BEGIN ADDING OF INSTRUCTIONS');

    final addInstructionFinder =
        find.byValueKey(TestValueKeys.addInstructionKey);
    final enterTitleField = find.byType('InstructionNameTextInput');
    final enterDescriptionField =
        find.byType('InstructionDescriptionTextInput');
    final addPhotoField = find.byType('InstructionPhotoInput');

    await Future.forEach(instructions, (Instruction instr) async {
      await driver.scrollIntoView(addInstructionFinder);

      await driver.tap(addInstructionFinder);
      await driver.scrollIntoView(enterTitleField);
      await driver.tap(enterTitleField);
      await driver.enterText(instr.title);
      await driver.scrollIntoView(enterDescriptionField);
      await driver.tap(enterDescriptionField);
      await driver.enterText(instr.description);

      // await driver.tap(addPhotoField);
      await driver.tap(
          find.descendant(of: addPhotoField, matching: find.byType('Icon')));
      await driver.tap(find.text('Camera'));
      await driver.tap(find.text('Save'));
    });
  }
}

class Instruction {
  final String title;
  final String description;
//  final List<String> imageUr

  Instruction({this.title, this.description});
}
