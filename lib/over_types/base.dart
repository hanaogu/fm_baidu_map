import '../map.dart';
import 'dart:async';

abstract class FmMapOverlays {
  FmBaiduMap _map;
  set map(FmBaiduMap m) {
    _map = m;
  }

  // 更新地图
  Future update() async {
    if (_map == null) {
      return;
    }
    await _map.update(this);
  }

  Future remove();
  Future setVisible(bool visible);
  Future setZIndex(int zIndex);

  FmBaiduMap get map => _map;

  void fromMap(Map m);
  Map toMap();
  // 数组转Map
  static List<Map> toList(List<FmMapOverlays> list) {
    List<Map> m = [];
    list.forEach((it) {
      m.add(it.toMap());
    });
    return m;
  }
}
