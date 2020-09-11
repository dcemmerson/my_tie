import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

import 'attributes_test_manager.dart';
import 'instructions_test_manager.dart';
import 'materials_test_manager.dart';
import 'new_fly_form_test_manager.dart';
import 'test_value_keys.dart';

void main() {
  final NewFlyFormTestManager newFlyFormTestManager = NewFlyFormTestManager();
  final AttributesTestManager attributesTestManager = AttributesTestManager();
  final MaterialsTestManager materialsTestManager = MaterialsTestManager();
  final InstructionsTestManager instructionsTestManager =
      InstructionsTestManager();

  Future<FlutterDriver> setupAndGetDriver() async {
    FlutterDriver driver = await FlutterDriver.connect();
    var connected = false;
    while (!connected) {
      try {
        await driver.waitUntilFirstFrameRasterized();
        connected = true;
      } catch (error) {}
    }
    return driver;
  }

  group('Add new fly form', () {
    // First, define the Finders and use them to locate widgets from the
    // test suite. Note: the Strings provided to the `byValueKey` method must
    // be the same as the Strings we used for the Keys in step 1.
    // final counterTextFinder = find.byValueKey('counter');
    // final buttonFinder = find.byValueKey('increment');

    FlutterDriver driver;

    // Connect to the Flutter driver before running any tests.
    setUpAll(() async {
      driver = await setupAndGetDriver();
    });

    // Close the connection to the driver after the tests have completed.
    tearDownAll(() async {
      if (driver != null) {
        driver.close();
      }
    });

    test('Add and delete attributes', () async {
      // Swipe page until we find the 'add new fly' button.
      final pageView = find.byType('PageView');
      await driver.waitFor(pageView);
      final addNewFlyButton = find.byValueKey(TestValueKeys.addNewFlyButton);

      await driver.scrollUntilVisible(pageView, addNewFlyButton,
          dxScroll: -300.0);

      // await driver.waitFor(addNewFlyButton);
      await driver.tap(addNewFlyButton);

      // Scroll down page until bottom buttons on form are visible.
      final clearFormButton = find.byValueKey(TestValueKeys.clearFormButton);
      await driver.scrollIntoView(clearFormButton);
      await newFlyFormTestManager.deleteFlyInProgress(driver);

      await driver.tap(addNewFlyButton);

      await newFlyFormTestManager.verifyFormIsCleared(driver);
      await attributesTestManager.fillOutAttributes(driver);

      //  Now verify that all the information we just entered actually appears
      //  on the new fly form review page.
      await attributesTestManager.verifyAttributesAppearInFormReview(driver);

      //  Scroll until delete button visible, tap the delete fly in progress
      //  button but on the confirm dialog, press cancel. Scroll back to top
      //  and verify correct attributes appear on screen.
      await driver.scrollIntoView(clearFormButton);
      await newFlyFormTestManager.deleteFlyInProgressButCancel(driver);
      await driver
          .scrollIntoView(find.byValueKey(TestValueKeys.editAttributesIcon));
      await attributesTestManager.verifyAttributesAppearInFormReview(driver);

      //  Finally, scroll back to delete buttons and delete the fly in progress
      //  that we created in this integration test.
      await driver.scrollIntoView(clearFormButton);
      await newFlyFormTestManager.deleteFlyInProgress(driver);
      print('FINISH TEST 1');
    });
    test('Add and delete materials', () async {
      //  Enter back into new fly form
      final addNewFlyButton = find.byValueKey(TestValueKeys.addNewFlyButton);
      await driver.tap(addNewFlyButton);

      // Scroll to bottom and clear form.
      // final clearFormButton = find.byValueKey(TestValueKeys.clearFormButton);
      // await driver.scrollIntoView(clearFormButton);
      // await newFlyFormTestManager.deleteFlyInProgress(driver);

      await materialsTestManager.fillOutMaterials(driver);
      await materialsTestManager.verifyMaterialsAppearInFormReview(driver);
      await materialsTestManager.removeEachMaterialAndVerifyRemoved(driver);
    });
    test('Add and delete instructions', () async {
      await instructionsTestManager.fillOutInstructions(driver);
    });
  });
}
