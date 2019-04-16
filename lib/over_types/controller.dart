import '../map.dart';
import './base.dart';
import './types.dart';

// 控制器
class FmBaiduMapController {
  FmBaiduMapController({map}) {
    _map = map;
  }
  FmBaiduMap _map;
  set map(m) {
    _map = m;
  }

  get map => _map;

  // 删除一个图层
  Future removeLayer(String layer) async {
    if (_map != null) {
      await _map.removeOverlays(layer: layer);
    }
  }

  /// 添加一个标注
  Future<FmMapOverlays> addOverlay(FmMapOverlays object) async {
    if (_map != null) {
      return await _map.addOverlay(object);
    }
    return null;
  }

  /// 添加一组标注
  Future<List<FmMapOverlays>> addOverlays(List<FmMapOverlays> objects) async {
    if (_map != null) {
      return await _map.addOverlays(objects);
    }
    return null;
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
  }) async {
    if (_map != null) {
      return await _map.setCenter(
        point,
        overlook: overlook,
        rotate: rotate,
        zoom: zoom,
      );
    }
  }
}
