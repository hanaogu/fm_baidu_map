import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fm_baidu_map/fm_baidu_map.dart';

void main() {
  const MethodChannel channel = MethodChannel('fm_baidu_map');

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });
}
