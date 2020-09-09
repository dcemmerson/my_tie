import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

import 'attributes_test_manager.dart';
import 'new_fly_form_test_manager.dart';
import 'test_value_keys.dart';

void main() {
  final AttributesTestManager attributesInfo = AttributesTestManager();
  final NewFlyFormTestManager formTestManager = NewFlyFormTestManager();

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

      await driver.waitFor(addNewFlyButton);

      await driver.tap(addNewFlyButton);
//      await formTestManager.deleteFlyInProgress(driver);
      //     await formTestManager.verifyFormIsCleared(driver);
      await attributesInfo.fillOutAttributes(driver);

      // Now verify that all the information we just entered actually appears
      //  on the new fly form review page.
      await attributesInfo.verifyAttributesAppearInFormReview(driver);
    });
  });
}
