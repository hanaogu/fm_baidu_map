import 'package:uuid/uuid.dart';
import './base.dart';
import './types.dart';

// 线标记
class FmMapOverlaysCircle extends FmMapOverlays {
  FmMapOverlaysCircle({
    this.id,
    this.layer = "0",
    this.visible = true,
    this.zIndex,
    this.point,
    this.radius,
    this.fillColor,
    this.strokeWidth,
    this.strokeColor,
  }) {
    if (id == null) {
      var uuid = new Uuid();
      id = uuid.v1();
    }
  }
  String id;
  String layer = "0";
  bool visible = true;
  int zIndex;
  FmMapPoint point;
  int radius;
  int fillColor;
  int strokeWidth;
  int strokeColor;

  /// 删除标注
  @override
  Future remove() async {
    if (map != null) {
      await map.removeOverlays(id: id, layer: layer);
    }
  }

  @override
  Future setVisible(bool visible) async {
    if (map != null) {
      await map.setOverlaysVisible(id: id, layer: layer, visible: visible);
    }
  }

  @override
  Future setZIndex(int zIndex) async {
    if (map != null) {
      await map.setOverlaysZIndex(id: id, layer: layer, zIndex: zIndex);
    }
  }

  @override
  void fromMap(Map m) {
    if (!m.containsKey("id")) {
      var uuid = new Uuid();
      id = uuid.v1();
    }
    layer = m["layer"] ?? "0";
    visible = m["visible"] ?? true;
    zIndex = m["zIndex"];
    point = FmMapPoint(latitude: m["latitude"], longitude: m["longitude"]);
    radius = m["radius"];
    fillColor = m["fillColor"];
    strokeWidth = m["strokeWidth"];
    strokeColor = m["strokeColor"];
  }

  // 转json
  @override
  Map toMap() {
    Map option = {
      "id": id,
      "type": "circle",
      "layer": layer,
      "visible": visible,
      "latitude": point.latitude,
      "longitude": point.longitude,
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
    return option;
  }
}
