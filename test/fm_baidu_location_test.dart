import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
// import 'package:fm_baidu_location_example/main.dart';
import 'package:fm_baidu_location/fm_baidu_location.dart';
import 'dart:async';

void main() {
  const MethodChannel channel = MethodChannel('fm_baidu_location');
  final FmBaiduLocation _local = FmBaiduLocation();
  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
    _local.init(onLocation: (e) {
      print(e);
    });
    _local.start();
    Future.delayed(Duration(milliseconds: 10000)).then((v) {
      _local.stop();
    });
  });
}
