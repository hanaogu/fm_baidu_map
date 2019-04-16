import 'package:flutter/services.dart';
import 'package:uuid/uuid.dart';
import './over_types/types.dart';

/// 百度定位
class FmBaiduLocation {
  static const MethodChannel _channel = const MethodChannel('fm_baidu_map');
  MethodChannel _eventChannel;
  String _name;
  FmBaiduLocation() {
    var uuid = new Uuid();
    _name = uuid.v1();
  }
  Future init({
    Map options = const {},
    void onLocation(FmBaiduLocationInfo arg),
  }) async {
    await _channel.invokeMethod("newInstanceLocation", {
      "name": _name,
      "isBaidu": true,
      "options": options,
    });
    // 监听事件
    _eventChannel = new MethodChannel(_name)
      ..setMethodCallHandler((MethodCall methodCall) {
        if (onLocation != null) {
          onLocation(FmBaiduLocationInfo.create(methodCall.arguments));
        }
      });
  }

  /// 开始定位
  Future start() async {
    await _eventChannel.invokeMethod("start");
  }

  /// 结束定位
  Future stop() async {
    await _eventChannel.invokeMethod("stop");
  }

  /// 销毁
  Future dispose() async {
    await _eventChannel.invokeMethod("dispose");
  }
}
