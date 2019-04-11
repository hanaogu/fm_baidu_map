import 'package:flutter/services.dart';
import 'package:uuid/uuid.dart';

class FmBaiduLocation {
  static const MethodChannel _channel =
      const MethodChannel('fm_baidu_location');
  MethodChannel _eventChannel;
  String _name;
  FmBaiduLocation() {
    var uuid = new Uuid();
    _name = uuid.v1();
  }
  void init({
    bool isBaidu = true,
    Map options = const {},
    void onLocation(Object arg),
  }) async {
    await _channel.invokeMethod("newInstance", {
      "name": _name,
      "isBaidu": isBaidu,
      "options": options,
    });
    _channel.setMethodCallHandler((name) {});
    // 监听事件
    _eventChannel = new MethodChannel(_name)
      ..setMethodCallHandler((MethodCall methodCall) {
        if (onLocation != null) {
          onLocation(methodCall.arguments);
        }
      });
  }

  /// 开始定位
  void start() {
    _eventChannel.invokeMethod("start");
  }

  /// 结束定位
  void stop() {
    _eventChannel.invokeMethod("stop");
  }

  /// 销毁
  void dispose() {
    _eventChannel.invokeMethod("dispose");
  }
}
