import 'package:flutter_driver/flutter_driver.dart';

class TestUtility {
  static Future<bool> isPresent(SerializableFinder finder, FlutterDriver driver,
      {Duration timeout = const Duration(seconds: 1)}) async {
    try {
      await driver.scrollIntoView(finder, timeout: timeout);
      await driver.waitFor(finder, timeout: timeout);
      return true;
    } catch (e) {
      return false;
    }
  }
}
