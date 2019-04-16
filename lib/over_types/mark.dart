import 'package:uuid/uuid.dart';
import './base.dart';
import './types.dart';

// 线标记
class FmMapOverlaysMark extends FmMapOverlays {
  FmMapOverlaysMark({
    this.id,
    this.layer = "0",
    this.visible = true,
    this.zIndex,
    this.point,
    this.icon,
    this.draggable = false,
    this.title,
    this.text,
    this.textSize = 16,
    this.textColor = 0xFF000000,
    this.rotate,
    this.anchorX = 0.5,
    this.anchorY = 0.5,
    this.scale = 1.0,
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
  String icon;
  bool draggable = false;
  String title;
  String text;
  int textSize = 16;
  int textColor = 0xFF000000;
  double rotate = 0.0;
  double anchorX = 0.5;
  double anchorY = 0.5;
  double scale = 1.0;

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
    draggable = m["draggable"] ?? false;
    if (m.containsKey("icon")) {
      icon = m["icon"];
    }
    if (m.containsKey("title")) {
      title = m["title"];
    }
    if (m.containsKey("title")) {
      title = m["title"];
    }
    textSize = m["textSize"] ?? 16;
    textColor = m["textColor"] ?? 0xFF000000;
    rotate = m["rotate"] ?? 0.0;
    anchorX = m["anchorX"] ?? 0.5;
    anchorY = m["anchorY"] ?? 0.5;
    scale = m["scale"] ?? 1.0;
  }

  // 转json
  @override
  Map toMap() {
    Map option = {
      "id": id,
      "type": "mark",
      "layer": layer,
      "visible": visible,
      "latitude": point.latitude,
      "longitude": point.longitude,
      "icon": icon,
      "draggable": draggable,
      "anchorX": anchorX,
      "anchorY": anchorY,
      "scale": scale,
      "textSize": textSize,
      "textColor": textColor,
    };
    if (zIndex != null) {
      option["zIndex"] = zIndex;
    }
    if (title != null) {
      option["title"] = title;
    }
    if (text != null) {
      option["text"] = text;
    }
    if (rotate != null) {
      option["rotate"] = rotate;
    }
    return option;
  }
}
