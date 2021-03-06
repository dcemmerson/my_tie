import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_driver/driver_extension.dart';
import 'package:my_tie/main.dart' as app;

void main() async {
  enableFlutterDriverExtension();

  // Required to allow integration tests access to location services and
  // device camera.
  const MethodChannel channel =
      MethodChannel('plugins.flutter.io/image_picker');

  channel.setMockMethodCallHandler((MethodCall methodCall) async {
    ByteData data = await rootBundle.load('assets/testing/test_image.jpeg');
    Uint8List bytes = data.buffer.asUint8List();
    Directory tempDir = await getTemporaryDirectory();
    File file = await File(
      '${tempDir.path}/tmp.tmp',
    ).writeAsBytes(bytes);
    return file.path;
  });

  runApp(DefaultAssetBundle(
      bundle: TestAssetBundle(), child: await app.initApp()));
}

class TestAssetBundle extends CachingAssetBundle {
  @override
  Future<String> loadString(String key, {bool cache = true}) async {
    final ByteData data = await load(key);
    if (data == null) throw FlutterError('Unable to load asset');
    return utf8.decode(data.buffer.asUint8List());
  }

  @override
  Future<ByteData> load(String key) async => rootBundle.load(key);
}
