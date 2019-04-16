import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uuid/uuid.dart';
import 'dart:async';
import './over_types/types.dart';
import './over_types/base.dart';

typedef void FmBaiduMapStatusChange(FmMapStatusInfo info);
typedef void FmBaiduMessage(String name, Object arg);

/// 地图
class FmBaiduMap {
  static const MethodChannel _channel = const MethodChannel('fm_baidu_map');
  Widget _map;
  MethodChannel _eventChannel;
  String _name;

  /// 构造
  FmBaiduMap() {
    var uuid = new Uuid();
    _name = uuid.v1();
    _map = AndroidView(
      viewType: "FmBaiduMapView",
      creationParams: {"name": _name},
      creationParamsCodec: StandardMessageCodec(),
    );
  }
  /*
   * 获取2点距离
   */
  static Future<double> getDistance(
    FmMapPoint p1,
    FmMapPoint p2,
  ) async {
    return await _channel.invokeMethod("getDistance", {
      "latitude1": p1.latitude,
      "longitude1": p1.longitude,
      "latitude2": p2.latitude,
      "longitude2": p2.longitude,
    });
  }

  /*
   * 初始化并监听
   */
  void init({
    FmBaiduMessage onMessage,
    // 坐标状态改变时
    FmBaiduMapStatusChange onMapStatusChange,
  }) {
    _eventChannel = new MethodChannel(_name)
      ..setMethodCallHandler((MethodCall methodCall) {
        if (methodCall.method == "onMapStatusChange" &&
            onMapStatusChange != null) {
          onMapStatusChange(FmMapStatusInfo.create(methodCall.arguments));
        }
        if (onMessage != null) {
          onMessage(methodCall.method, methodCall.arguments);
        }
      });
  }

  /// 视图
  Widget get view => _map;
  /*
   * 添加一个标注
   */
  Future<FmMapOverlays> addOverlay(FmMapOverlays object) async {
    object.map = this;
    await _eventChannel.invokeMethod("addOverlays", {
      "objects": [object.toMap()],
    });
    return object;
  }

  /*
   * 添加一组标注
   */
  Future<List<FmMapOverlays>> addOverlays(List<FmMapOverlays> objects) async {
    await _eventChannel.invokeMethod(
      "addOverlays",
      {"objects": FmMapOverlays.toList(objects)},
    );
    FmBaiduMap t = this;
    objects.forEach((it) {
      it.map = t;
    });
    return objects;
  }

  /*
   * 更新一条记录
   */
  Future update(FmMapOverlays object) async {
    await updates([object]);
  }

  /*
   * 更新多条记录
   */
  Future updates(List<FmMapOverlays> objects) async {
    await _eventChannel.invokeMethod(
      "updateOverlays",
      {"objects": FmMapOverlays.toList(objects)},
    );
  }

  /*
   * 移除标注
   */
  Future removeOverlays({String id, String layer}) async {
    Map m = {};
    if (id != null) {
      m["id"] = id;
    }
    if (layer != null) {
      m["layer"] = layer;
    }
    await _eventChannel.invokeMethod("removeOverlays", m);
  }

  /*
   * 设置标注的顺序
   */
  Future setOverlaysZIndex({String id, String layer, int zIndex}) async {
    Map m = {"zIndex": zIndex};
    if (id != null) {
      m["id"] = id;
    }
    if (layer != null) {
      m["layer"] = layer;
    }
    await _eventChannel.invokeMethod("setOverlaysIndex", m);
  }

  /*
   * 设置显示或隐藏
   */
  Future setOverlaysVisible({
    String id,
    String layer,
    bool visible = true,
  }) async {
    Map m = {"visible": visible};
    if (id != null) {
      m["id"] = id;
    }
    if (layer != null) {
      m["layer"] = layer;
    }
    await _eventChannel.invokeMethod("setOverlaysVisible", m);
  }

  /*
  * 设置地图定位点
  * @param obj
  * String name, 对象名称
  * double latitude, 经度
  * double longitude, 纬度
  * float direction, 方向
  * float accuracy 圈直径大小
  */
  Future setCurrentPoint(
    FmMapPoint point, {
    double direction = 0,
    double accuracy = 500,
  }) async{
    await _eventChannel.invokeMethod("setCurrentPoint", {
      "latitude": point.latitude,
      "longitude": point.longitude,
      "direction": direction,
      "accuracy": accuracy
    });
  }

  /*
  * 设置地图定位到指定点
  * @param obj
  * latitude
  * longitude
  * overlook
  * rotate
  * zoom
  */
  Future setCenter(
    FmMapPoint point, {
    double overlook = 1,
    double rotate = 360,
    double zoom = 0,
  }) async{
    await _eventChannel.invokeMethod("setCenter", {
      "latitude": point.latitude,
      "longitude": point.longitude,
      "overlook": overlook,
      "rotate": rotate,
      "zoom": zoom
    });
  }
}
