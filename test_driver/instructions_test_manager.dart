/// filename: instructions_test_manager.dart
/// description: Logic for testing instruction aspect of new fly form.

import 'dart:math';

import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

import 'test_utility.dart';
import 'test_value_keys.dart';

class InstructionsTestManager {
  static const emptyNamePlaceholder = 'No name';
  static const emptyAttributePlaceholder = '[None]';

  static final rnd = Random();
  static final List<Instruction> instructions = [
    Instruction(
        title: 'Marclar',
        description: 'Marclar, this is Marclar',
        stepNumber: 1),
    Instruction(
        title: 'Call Marclar',
        description: 'Calling all Marclar, this is Marclar',
        stepNumber: 2),
    Instruction(
        title: 'Marclar Directs',
        description: 'Hey you, Marclar',
        stepNumber: 3),
    Instruction(
        title: 'Marclar Responds', description: 'Yes, Marclar?', stepNumber: 4),
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

      await driver.tap(
          find.descendant(of: addPhotoField, matching: find.byType('Icon')));
      await driver.tap(find.text('Camera'));
      await driver.tap(find.text('Save'));
    });
  }

  Future deleteEachInstructionAndVerify(FlutterDriver driver) async {
    print('DELETE AND VERIFY INSTRUCTIONS');

    var deletedInstructions = 0;

    await Future.forEach(instructions, (Instruction instruction) async {
      print('tap on Step ' +
          (instruction.stepNumber - deletedInstructions).toString());
      await driver.scrollIntoView(find
          .byValueKey('Step ${instruction.stepNumber - deletedInstructions}'));
      await driver.tap(find.descendant(
          of: find.byValueKey(
              'Step ${instruction.stepNumber - deletedInstructions}'),
          matching: find.byType('Icon')));

      // We should now be on the edit instruction page.
      await driver.scrollIntoView(find.text(instruction.title));
      await driver.waitFor(find.text(instruction.title));
      await driver.scrollIntoView(find.text(instruction.description));
      await driver.waitFor(find.text(instruction.description));
      await driver.tap(find.text('Delete this step'));

      expect(await TestUtility.isPresent(find.text(instruction.title), driver),
          false);

      deletedInstructions++;
    });

    // Find 1st instruction in instructions, tap edit, verify info, on edit
    // instruction page, and tap delete.
  }

  Future verifyInstructionsReview(FlutterDriver driver,
      {List<Instruction> instrs}) async {
    // We should be on the instructions review screen at this point.

    if (instrs == null) instrs = instructions;
    print('instrs  = ');
    print(instrs);
    await Future.forEach(instrs, (Instruction instr) async {
      print(instr.stepNumber);
      final stepNumberFinder = find.text('Step ${instr.stepNumber}');
      final stepTitleFinder = find.text(instr.title);
      final stepDescriptionFinder = find.text(instr.description);

      await driver.scrollIntoView(stepNumberFinder);
      expect(await TestUtility.isPresent(stepNumberFinder, driver), true);

      await driver.scrollIntoView(stepTitleFinder);
      expect(await TestUtility.isPresent(stepNumberFinder, driver), true);

      await driver.scrollIntoView(stepDescriptionFinder);
      expect(await TestUtility.isPresent(stepDescriptionFinder, driver), true);
    });
  }
}

class Instruction {
  final String title;
  final String description;
  final int stepNumber;
//  final List<String> imageUr

  Instruction({this.title, this.description, this.stepNumber});
}
