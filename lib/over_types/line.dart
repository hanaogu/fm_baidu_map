import 'package:uuid/uuid.dart';
import './base.dart';
import './types.dart';

// 线标记
class FmMapOverlaysLine extends FmMapOverlays {
  FmMapOverlaysLine({
    this.id,
    this.layer = "0",
    this.points,
    this.visible = true,
    this.zIndex,
    this.color,
    this.width,
    this.dottedLine = false,
  }) {
    if (id == null) {
      var uuid = new Uuid();
      id = uuid.v1();
    }
  }

  String id;
  String layer;
  bool visible;
  int zIndex;
  int color;
  int width;
  bool dottedLine;
  List<FmMapPoint> points;

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
    if (m.containsKey("points")) {
      points = [];
      m["points"].forEach((it) {
        points.add(
          FmMapPoint(latitude: it["latitude"], longitude: it["longitude"]),
        );
      });
    }
    color = m["color"];
    width = m["width"];
    dottedLine = m["dottedLine"];
  }

  // 转json
  @override
  Map toMap() {
    Map option = {
      "id": id,
      "type": "line",
      "layer": layer,
      "visible": visible,
      "dottedLine": dottedLine,
      "points": FmMapPoint.toList(points),
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
    return option;
  }
}
