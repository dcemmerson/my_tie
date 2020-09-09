/// filename: new_fly_form_test_manager.dart
/// description: Class which holds integration test logic for performin
///   common operations on the new fly form, such as deleting the fly in
///   progress, confirming the form is cleared, etc.

import 'package:flutter_driver/flutter_driver.dart';

import 'attributes_test_manager.dart';
import 'test_value_keys.dart';

class NewFlyFormTestManager {
  ///  name: deleteFlyInProgress
  ///  description: Delete fly in progress, and confirm delete on popup dialog.
  Future deleteFlyInProgress(FlutterDriver driver) async {
    await driver.tap(find.byValueKey(TestValueKeys.clearFormButton));
    final confirmDeleteButton =
        find.byValueKey(TestValueKeys.confirmClearFormButton);
    await driver.waitFor(confirmDeleteButton);
    await driver.tap(confirmDeleteButton);
  }

  ///  name: deleteFlyInProgressButCancel
  ///  description: Delete fly in progress, and confirm delete on popup dialog.
  Future deleteFlyInProgressButCancel(FlutterDriver driver) async {
    await driver.tap(find.byValueKey(TestValueKeys.clearFormButton));
    final confirmDeleteCancelButton =
        find.byValueKey(TestValueKeys.cancelClearFormButton);
    await driver.waitFor(confirmDeleteCancelButton);
    await driver.tap(confirmDeleteCancelButton);
  }

  Future verifyFormIsCleared(FlutterDriver driver) async {
    await AttributesTestManager.verifyAttributesReviewIsCleared(driver);
  }
}
