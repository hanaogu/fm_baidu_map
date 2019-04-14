import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uuid/uuid.dart';
import 'dart:async';

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
    double latitude1,
    double longitude1,
    double latitude2,
    double longitude2,
  ) async {
    return await _channel.invokeMethod("getDistance", {
      "latitude1": latitude1,
      "longitude1": longitude1,
      "latitude2": latitude2,
      "longitude2": longitude2,
    });
  }

  /*
   * 初始化并监听
   */
  void init(void onMessage(String name, Object arg)) {
    _eventChannel = new MethodChannel(_name)
      ..setMethodCallHandler((MethodCall methodCall) {
        if (onMessage != null) {
          onMessage(methodCall.method, methodCall.arguments);
        }
      });
  }

  /// 视图
  Widget get map => _map;
  List<String> addOverlays({List objects}) {
    List<String> ids = [];
    objects.forEach((it) {
      if (it["id"] != null) {
        var uuid = new Uuid();
        it["id"] = uuid.v1();
      }
      ids.add(it["id"]);
    });
    _eventChannel.invokeMethod("addOverlays", {"objects": objects});
    return ids;
  }

  /*
   * 更新一条记录
   */
  void update({object}) {
    updates(objects: [object]);
  }

  /*
   * 更新多条记录
   */
  void updates({objects}) {
    _eventChannel.invokeMethod("updateOverlays", {"objects": objects});
  }

  /*
   * 添加多段线 
   */
  String addLine({
    String id,
    String layer = "0",
    List points,
    bool visible = true,
    int zIndex,
    int color,
    int width,
    bool dottedLine = false,
  }) {
    Map option = {
      "id": id,
      "type": "line",
      "layer": layer,
      "visible": visible,
      "dottedLine": dottedLine,
      "points": points,
    };
    if (zIndex != null) {
      option["zIndex"] = zIndex;
    }
    if (color != null) {
      option["color"] = color;
    }
    if (width != null) {
      option["width"] = width;
    }

    return addOverlays(objects: [option])[0];
  }

/*
 * 添加文字标注 
 */
  String addText({
    String id,
    String layer = "0",
    bool visible = true,
    int zIndex,
    double latitude,
    double longitude,
    String text,
    int bgColor,
    double rotate,
    int fontSize,
    int fontColor,
  }) {
    Map option = {
      "id": id,
      "type": "text",
      "layer": layer,
      "visible": visible,
      "text": text,
      "latitude": latitude,
      "longitude": longitude,
    };
    if (zIndex != null) {
      option["zIndex"] = zIndex;
    }
    if (bgColor != null) {
      option["bgColor"] = bgColor;
    }
    if (fontColor != null) {
      option["fontColor"] = fontColor;
    }
    if (rotate != null) {
      option["rotate"] = rotate;
    }
    if (fontSize != null) {
      option["fontSize"] = fontSize;
    }

    return addOverlays(objects: [option])[0];
  }

  /*
   * 添加标注
   */
  String addMark({
    String id,
    String layer = "0",
    bool visible = true,
    int zIndex,
    double latitude,
    double longitude,
    String icon,
    bool draggable = false,
    String title,
    String text,
    int textSize = 16,
    int textColor = 0xFF000000,
    double rotate,
    double anchorX = 0.5,
    double anchorY = 0.5,
    double scale = 1.0,
  }) {
    Map option = {
      "id": id,
      "type": "mark",
      "layer": layer,
      "visible": visible,
      "latitude": latitude,
      "longitude": longitude,
      "icon": icon,
      "draggable": draggable,
      "anchorX": anchorX,
      "anchorY": anchorY,
      "scale": scale,
      "text": text,
      "textSize": textSize,
      "textColor": textColor,
    };
    if (zIndex != null) {
      option["zIndex"] = zIndex;
    }
    if (title != null) {
      option["title"] = title;
    }
    if (rotate != null) {
      option["rotate"] = rotate;
    }

    return addOverlays(objects: [option])[0];
  }

  /*
   * 画圆
   * String layer = "0",
   * double latitude,
   * double longitude,
   * int radius,
   * int fillColor,
   * int strokeWidth,
   * int strokeColor,
   */
  String addCircle({
    String id,
    String layer = "0",
    bool visible = true,
    int zIndex,
    double latitude,
    double longitude,
    int radius,
    int fillColor,
    int strokeWidth,
    int strokeColor,
  }) {
    Map option = {
      "id": id,
      "type": "circle",
      "layer": layer,
      "visible": visible,
      "latitude": latitude,
      "longitude": longitude,
      "radius": radius,
    };
    if (zIndex != null) {
      option["zIndex"] = zIndex;
    }
    if (fillColor != null) {
      option["fillColor"] = fillColor;
    }
    if (strokeWidth != null && strokeColor != null) {
      option["strokeColor"] = strokeColor;
      option["strokeWidth"] = strokeWidth;
    }
    return addOverlays(objects: [option])[0];
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
  void setCurrentPoint({
    double latitude,
    double longitude,
    double direction = 0,
    double accuracy = 500,
  }) {
    _eventChannel.invokeMethod("setCurrentPoint", {
      "latitude": latitude,
      "longitude": longitude,
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
  void setCenter({
    double latitude,
    double longitude,
    double overlook = 1,
    double rotate = 360,
    double zoom = 0,
  }) {
    _eventChannel.invokeMethod("setCenter", {
      "latitude": latitude,
      "longitude": longitude,
      "overlook": overlook,
      "rotate": rotate,
      "zoom": zoom
    });
  }
}
