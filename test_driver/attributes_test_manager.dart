/// filename: attributes_test_manager.dart
/// description: Logic for testing attributes aspect of new fly form.
///   Available functionallity includes verify that the attributes portion
///   of form was successfully cleared when deleting fly in progress,
///   fill out attributes portion of form, verify attributes portion, etc.

import 'dart:math';

import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

import 'test_value_keys.dart';

class AttributesTestManager {
  static const emptyPlaceholder = '[None]';
  static final rnd = Random();

  static const flyDifficulties = ['easy', 'medium', 'hard'];
  static const flyStyles = [
    'attractor',
    'caddis',
    'egg',
    'foam',
    'mayfly',
    'midge',
    'streamer',
    'terrestrial',
    'worm',
    'other'
  ];
  static const flyTypes = ['nymph', 'emerger', 'wet fly', 'dry fly', 'other'];
  static const flyTargets = [
    'trout',
    'salmon',
    'steelhead',
    'bass',
    'rainbow trout'
  ];

  final String flyName = 'Marclar';
  final String flyDifficulty;
  final String flyStyle;
  final String flyType;
  final String flyTarget;

  // Everytime we instantiate AttributesInfo for integration tests, we will
  //  use rnd to pseudo randomly select fly attributes.
  AttributesTestManager()
      : flyDifficulty = flyDifficulties[rnd.nextInt(flyDifficulties.length)],
        flyStyle = flyStyles[rnd.nextInt(flyStyles.length)],
        flyType = flyTypes[rnd.nextInt(flyTypes.length)],
        flyTarget = flyTargets[rnd.nextInt(flyTargets.length)];

  static Future verifyAttributesReviewIsCleared(FlutterDriver driver) async {
    expect(
        await driver
            .getText(find.byValueKey(TestValueKeys.nameAttributeReview)),
        emptyPlaceholder);
    expect(
        await driver
            .getText(find.byValueKey(TestValueKeys.difficultyAttributeReview)),
        emptyPlaceholder);
    expect(
        await driver
            .getText(find.byValueKey(TestValueKeys.styleAttributeReview)),
        emptyPlaceholder);
    expect(
        await driver
            .getText(find.byValueKey(TestValueKeys.typeAttributeReview)),
        emptyPlaceholder);
    expect(
        await driver
            .getText(find.byValueKey(TestValueKeys.targetAttributeReview)),
        emptyPlaceholder);
  }

  Future fillOutAttributes(FlutterDriver driver) async {
    // // Select edit attributes.
    final attributesIcon = find.byValueKey(TestValueKeys.editAttributesIcon);
    await driver.waitFor(attributesIcon);
    await driver.tap(attributesIcon);

    // // Enter in the name of this fly.
    await driver.tap(find.byValueKey(TestValueKeys.flyNameEntry));
//      WidgetTester.showKeyboard();
    await driver.enterText(flyName);

    // // // Select from dropdown the difficulty of this fly.
    final difficultyDropdown =
        find.byValueKey(TestValueKeys.difficultyAttributeDropdown);
    // driver.waitFor(difficultyDropdown);
    await driver.tap(difficultyDropdown);
    await driver.tap(find.text(flyDifficulty));
    // // // Select from dropdown the style of this fly.
    final styleDropdown = find.byValueKey(TestValueKeys.styleAttributeDropdown);
    // driver.waitFor(styleDropdown);
    await driver.tap(styleDropdown);
    await driver.tap(find.text(flyStyle));
    // // // Select from dropdown the type of this fly.
    final typeDropdown = find.byValueKey(TestValueKeys.typeAttributeDropdown);
    // driver.waitFor(typeDropdown);
    await driver.tap(typeDropdown);
    await driver.tap(find.text(flyType));

    // // // Select from dropdown the style of this fly.
    final targetDropdown =
        find.byValueKey(TestValueKeys.targetAttributeDropdown);
    // driver.waitFor(targetDropdown);
    await driver.tap(targetDropdown);
    await driver.tap(find.text(flyTarget));

    final saveAttributesButton = find.text('Save');
    await driver.tap(saveAttributesButton);
  }

  Future verifyAttributesAppearInFormReview(FlutterDriver driver) async {
    expect(
        await driver
            .getText(find.byValueKey(TestValueKeys.nameAttributeReview)),
        flyName);
    expect(
        await driver
            .getText(find.byValueKey(TestValueKeys.difficultyAttributeReview)),
        flyDifficulty);
    expect(
        await driver
            .getText(find.byValueKey(TestValueKeys.styleAttributeReview)),
        flyStyle);
    expect(
        await driver
            .getText(find.byValueKey(TestValueKeys.typeAttributeReview)),
        flyType);
    expect(
        await driver
            .getText(find.byValueKey(TestValueKeys.targetAttributeReview)),
        flyTarget);
  }
}
